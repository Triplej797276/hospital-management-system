import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddPatientScreen extends StatelessWidget {
  const AddPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final conditionController = TextEditingController();
    final emailController = TextEditingController();
    final contactNumberController = TextEditingController();
    final RxBool isLoading = false.obs; // Add loading state

    Future<void> addPatient() async {
      try {
        // Basic validation
        if (nameController.text.trim().isEmpty) {
          Get.snackbar('Error', 'Please enter patient name');
          return;
        }
        if (emailController.text.trim().isEmpty ||
            !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(emailController.text.trim())) {
          Get.snackbar('Error', 'Please enter a valid email');
          return;
        }
        if (contactNumberController.text.trim().length < 10) {
          Get.snackbar('Error', 'Please enter a valid contact number (minimum 10 characters)');
          return;
        }
        final age = int.tryParse(ageController.text.trim()) ?? 0;
        if (age <= 0) {
          Get.snackbar('Error', 'Please enter a valid age');
          return;
        }

        // Check if current user is admin
        // User? currentUser = FirebaseAuth.instance.currentUser;
        // if (currentUser == null || currentUser.email != 'jayjadhav2507@gmail.com') {
        //   Get.snackbar('Error', 'Only admins can add patients');
        //   return;
        // }

        // isLoading.value = true;

        // Create user in Firebase Authentication
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text.trim().toLowerCase(),
          password: contactNumberController.text.trim(), // Use contact number as password
        );

        // Store patient data in Firestore
        await FirebaseFirestore.instance.collection('patients').doc(userCredential.user!.uid).set({
          'name': nameController.text.trim(),
          'age': age,
          'condition': conditionController.text.trim(),
          'email': emailController.text.trim().toLowerCase(),
          'contact_number': contactNumberController.text.trim(),
          'role': 'patient', // Add role for compatibility with role-based system
          'createdAt': FieldValue.serverTimestamp(),
        });

        Get.back();
        Get.snackbar('Success', 'Patient added successfully');
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'email-already-in-use':
            errorMessage = 'The email address is already in use.';
            break;
          case 'invalid-email':
            errorMessage = 'The email address is not valid.';
            break;
          case 'weak-password':
            errorMessage = 'The contact number is too weak. Please use at least 10 characters.';
            break;
          case 'operation-not-allowed':
            errorMessage = 'Email/password accounts are not enabled.';
            break;
          default:
            errorMessage = 'Failed to create user: ${e.message}';
        }
        Get.snackbar('Error', errorMessage);
      } catch (e) {
        Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add Patient')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Patient Name',
                hintText: 'Enter full name',
              ),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(
                labelText: 'Age',
                hintText: 'Enter age',
              ),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: conditionController,
              decoration: const InputDecoration(
                labelText: 'Condition',
                hintText: 'Enter medical condition',
              ),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email (Username)',
                hintText: 'Enter email address',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            TextField(
              controller: contactNumberController,
              decoration: const InputDecoration(
                labelText: 'Contact Number (Password)',
                hintText: 'Enter contact number',
              ),
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            Obx(() => ElevatedButton(
                  onPressed: isLoading.value ? null : addPatient,
                  child: isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Add Patient'),
                )),
          ],
        ),
      ),
    );
  }
}