import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddNurseScreen extends StatelessWidget {
  const AddNurseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    final _nameController = TextEditingController();
    final _departmentController = TextEditingController();
    final _contactController = TextEditingController();
    final _passwordController = TextEditingController();
    final _confirmPasswordController = TextEditingController();
    final _emailController = TextEditingController();

    // Function to handle nurse addition
    Future<void> _addNurse() async {
      if (_formKey.currentState!.validate()) {
        // Show loading dialog
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => const Center(child: CircularProgressIndicator()),
        );

        try {
          // Create Firebase Auth user
          final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          // Send email verification
          await userCredential.user!.sendEmailVerification();

          // Add nurse details to Firestore
          await FirebaseFirestore.instance.collection('nurses').add({
            'name': _nameController.text,
            'department': _departmentController.text,
            'contact': _contactController.text,
            'email': _emailController.text.trim(),
            'created_at': FieldValue.serverTimestamp(),
          });

          // Close loading dialog
          Navigator.pop(context);

          // Show success message and navigate back
          Get.snackbar('Success', 'Nurse added successfully. Please verify your email.',
              snackPosition: SnackPosition.BOTTOM);
          Navigator.pop(context); // Return to NurseListScreen
        } on FirebaseAuthException catch (e) {
          // Close loading dialog
          Navigator.pop(context);

          String errorMessage;
          switch (e.code) {
            case 'email-already-in-use':
              errorMessage = 'This email is already registered.';
              break;
            case 'invalid-email':
              errorMessage = 'Invalid email format.';
              break;
            default:
              errorMessage = 'Failed to add nurse: ${e.message}';
          }
          Get.snackbar('Error', errorMessage, snackPosition: SnackPosition.BOTTOM);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add Nurse')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Nurse Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter an email';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _departmentController,
                decoration: const InputDecoration(labelText: 'Department'),
                validator: (value) => value!.isEmpty ? 'Enter a department' : null,
              ),
              TextFormField(
                controller: _contactController,
                decoration: const InputDecoration(labelText: 'Contact'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter a contact';
                  }
                  if (!RegExp(r'^\+?[\d\s-]{10,15}$').hasMatch(value)) {
                    return 'Enter a valid phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
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
              TextFormField(
                controller: _confirmPasswordController,
                decoration: const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please confirm your password';
                  }
                  if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _addNurse,
                child: const Text('Add Nurse'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}