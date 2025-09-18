// NurseLoginScreen.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/screens/nurse/add_nurse_screen.dart';
import 'package:hsmproject/screens/nurse/nurse_dashboard_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NurseLoginController extends GetxController {
  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  void toggleLoading(bool value) => _isLoading.value = value;

  final RxString _nurseName = ''.obs;
  String get nurseName => _nurseName.value;
  void setNurseName(String name) => _nurseName.value = name;

  @override
  void onClose() {
    _isLoading.close();
    super.onClose();
  }
}

class NurseLoginScreen extends StatelessWidget {
  NurseLoginScreen({super.key});

  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final NurseLoginController _controller = Get.put(NurseLoginController());

  Future<void> _signInNurse() async {
    if (_controller.isLoading) return;
    if (_formKey.currentState!.validate()) {
      _controller.toggleLoading(true);
      try {
        // Firebase Auth Sign-in
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Verify nurse in Firestore
        final nurseSnapshot = await FirebaseFirestore.instance
            .collection('nurses')
            .where('email', isEqualTo: _emailController.text.trim())
            .limit(1)
            .get();

        if (nurseSnapshot.docs.isEmpty) {
          Get.snackbar('Error', 'No nurse account found with this email',
              snackPosition: SnackPosition.BOTTOM);
          await FirebaseAuth.instance.signOut();
          return;
        }

        final nurseDoc = nurseSnapshot.docs.first;
        final nurseData = nurseDoc.data();
        final nurseName = nurseData['name']?.toString() ?? 'Unknown Nurse';

        _controller.setNurseName(nurseName);

        Get.snackbar('Success', 'Nurse logged in successfully',
            snackPosition: SnackPosition.BOTTOM);
        Get.offAll(() => NurseDashboardScreen());
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = 'No nurse found with this email.';
            break;
          case 'wrong-password':
            errorMessage = 'Incorrect password.';
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format.';
            break;
          default:
            errorMessage = 'Failed to login: ${e.message}';
        }
        Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          Get.snackbar('Error', 'Access denied. Please contact support.',
              snackPosition: SnackPosition.BOTTOM);
          await FirebaseAuth.instance.signOut();
        } else {
          Get.snackbar('Error', 'Failed to verify nurse: ${e.message}',
              snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        Get.snackbar('Error', 'An unexpected error occurred: $e',
            snackPosition: SnackPosition.BOTTOM);
      } finally {
        _controller.toggleLoading(false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // ✅ Consistent theme
      appBar: AppBar(
        title: const Text(
          'Nurse Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.local_hospital,
                        // If Icons.nursing not available, use Icons.local_hospital
                        size: 80, color: Colors.blueAccent),
                    const SizedBox(height: 12),
                    const Text(
                      'Nurse Portal',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Email
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon:
                            const Icon(Icons.email, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                            .hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Password
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon:
                            const Icon(Icons.lock, color: Colors.blueAccent),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Colors.blueAccent, width: 2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Login Button
                    Obx(() => _controller.isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.blueAccent,
                          )
                        : SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: _signInNurse,
                              child: const Text(
                                'Sign In as Nurse',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          )),
                    const SizedBox(height: 16),

                    // Create Account
                    TextButton(
                      onPressed: () =>
                          Get.to(() => const AddNurseScreen()),
                      child: const Text(
                        'Create Nurse Account',
                        style: TextStyle(
                            color: Colors.blueAccent,
                            fontSize: 16,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
