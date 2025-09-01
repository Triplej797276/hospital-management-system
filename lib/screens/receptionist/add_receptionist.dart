import 'dart:io' show File;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class AddReceptionistScreen extends StatefulWidget {
  const AddReceptionistScreen({super.key});

  @override
  _AddReceptionistScreenState createState() => _AddReceptionistScreenState();
}

class _AddReceptionistScreenState extends State<AddReceptionistScreen> {
  final nameController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final addressController = TextEditingController();
  final roleController = TextEditingController();
  final shiftController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  XFile? _selectedImage;
  String? _uploadedImageUrl;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _signInAnonymously();
  }

  Future<void> _signInAnonymously() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await FirebaseAuth.instance.signInAnonymously();
        print('Signed in anonymously: ${FirebaseAuth.instance.currentUser?.uid}');
      } else {
        print('Already signed in: ${user.uid}');
        await user.getIdToken(true);
      }
    } catch (e) {
      print('Anonymous sign-in error: $e');
      Get.snackbar(
        'Authentication Error',
        'Failed to sign in: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    try {
      if (kIsWeb) {
        final pickedFile = await picker.pickImage(source: ImageSource.gallery);
        if (pickedFile != null) {
          setState(() {
            _selectedImage = pickedFile;
            _uploadedImageUrl = null;
          });
        } else {
          Get.snackbar('Warning', 'No image selected',
              snackPosition: SnackPosition.BOTTOM);
        }
      } else {
        final status = await [Permission.photos, Permission.storage].request();
        if (status[Permission.photos]!.isGranted ||
            status[Permission.storage]!.isGranted) {
          final pickedFile = await picker.pickImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            print('Selected image path: ${pickedFile.path}');
            setState(() {
              _selectedImage = pickedFile;
              _uploadedImageUrl = null;
            });
          } else {
            Get.snackbar('Warning', 'No image selected',
                snackPosition: SnackPosition.BOTTOM);
          }
        } else {
          Get.snackbar('Error', 'Permission to access gallery denied',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.red,
              colorText: Colors.white);
        }
      }
    } catch (e) {
      print('Image picker error: $e');
      Get.snackbar('Error', 'Failed to pick image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<String?> _uploadImage(XFile image) async {
    try {
      setState(() {
        _isUploading = true;
      });
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        await _signInAnonymously();
      }
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('receptionist_photos')
          .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
      final uploadTask = kIsWeb
          ? storageRef.putData(
              await image.readAsBytes(),
              SettableMetadata(contentType: 'image/jpeg'),
            )
          : storageRef.putFile(
              File(image.path),
              SettableMetadata(contentType: 'image/jpeg'),
            );
      final snapshot = await uploadTask.whenComplete(() {});
      if (snapshot.state == TaskState.success) {
        final downloadUrl = await storageRef.getDownloadURL();
        print('Image uploaded successfully: $downloadUrl');
        return downloadUrl;
      } else {
        throw FirebaseException(
            plugin: 'firebase_storage',
            code: 'upload_failed',
            message: 'Upload task failed: ${snapshot.state}');
      }
    } on FirebaseException catch (e) {
      print('Firebase Storage error: ${e.code} - ${e.message}');
      Get.snackbar('Error', 'Failed to upload image: ${e.message}',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return null;
    } catch (e) {
      print('Image upload error: $e');
      Get.snackbar('Error', 'Failed to upload image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return null;
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _createUserAndAddReceptionist() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        _isUploading = true;
      });
      try {
        // Create user with email and password
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        String userId = userCredential.user!.uid;

        // Upload image if selected
        String? photoUrl;
        if (_selectedImage != null) {
          photoUrl = await _uploadImage(_selectedImage!);
          if (photoUrl == null) {
            Get.snackbar('Warning', 'Image upload failed, saving without image',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.orange,
                colorText: Colors.white);
          }
        }

        // Add receptionist data to Firestore
        await FirebaseFirestore.instance
            .collection('receptionists')
            .doc(userId)
            .set({
          'name': nameController.text.trim(),
          'contact': contactController.text.trim(),
          'email': emailController.text.trim(),
          'address': addressController.text.trim(),
          'role': roleController.text.trim(),
          'shift': shiftController.text.trim(),
          'photoUrl': photoUrl ?? '',
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Clear form fields
        nameController.clear();
        contactController.clear();
        emailController.clear();
        passwordController.clear();
        addressController.clear();
        roleController.clear();
        shiftController.clear();
        setState(() {
          _selectedImage = null;
          _uploadedImageUrl = null;
        });

        // Navigate back and show success message
        Get.back(result: true); // Pass result to trigger dashboard refresh
        Get.snackbar('Success', 'Receptionist added successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format.';
            break;
          case 'weak-password':
            errorMessage = 'The password is too weak.';
            break;
          default:
            errorMessage = 'Failed to create user: ${e.message}';
        }
        Get.snackbar('Error', errorMessage,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } catch (e) {
        print('Error: $e');
        Get.snackbar('Error', 'Failed to add receptionist: $e',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } finally {
        setState(() {
          _isUploading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Receptionist'),
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Get.back(), // Close screen without saving
            tooltip: 'Cancel',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: _uploadedImageUrl != null
                        ? Image.network(
                            _uploadedImageUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error, size: 40),
                          )
                        : _selectedImage != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: kIsWeb
                                    ? Image.network(_selectedImage!.path,
                                        fit: BoxFit.cover)
                                    : Image.file(File(_selectedImage!.path),
                                        fit: BoxFit.cover),
                              )
                            : const Center(child: Icon(Icons.add_a_photo, size: 40)),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter contact information' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Please enter an email';
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                    labelText: 'Password (Numbers Only)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a password';
                    }
                    if (!RegExp(r'^\d+$').hasMatch(value)) {
                      return 'Password must contain only numbers';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 digits';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter an address' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: roleController,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a role' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: shiftController,
                  decoration: const InputDecoration(
                    labelText: 'Shift (e.g., Morning, Evening)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a shift' : null,
                ),
                const SizedBox(height: 20),
                _isUploading
                    ? const CircularProgressIndicator()
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(
                            onPressed: _createUserAndAddReceptionist,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Add Receptionist'),
                          ),
                          ElevatedButton(
                            onPressed: () => Get.back(), // Cancel button
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Cancel'),
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    contactController.dispose();
    emailController.dispose();
    passwordController.dispose();
    addressController.dispose();
    roleController.dispose();
    shiftController.dispose();
    super.dispose();
  }
}