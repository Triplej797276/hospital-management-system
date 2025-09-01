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

  @override
  void onClose() {
    _isLoading.close(); // Dispose of RxBool
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
    if (_controller.isLoading) return; // Prevent multiple submissions
    if (_formKey.currentState!.validate()) {
      _controller.toggleLoading(true);
      try {
        // Sign in with Firebase Auth
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

       

        // Verify nurse exists in Firestore
        final nurseSnapshot = await FirebaseFirestore.instance
            .collection('nurses')
            .where('email', isEqualTo: _emailController.text.trim())
            .get();

        if (nurseSnapshot.docs.isEmpty) {
          Get.snackbar('Error', 'No nurse account found with this email',
              snackPosition: SnackPosition.BOTTOM);
          await FirebaseAuth.instance.signOut();
          return;
        }

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
        // Handle Firestore-specific errors
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
      appBar: AppBar(
        title: const Text('Nurse Login'),
        backgroundColor: Colors.cyan,
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
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
              const SizedBox(height: 16),
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
              const SizedBox(height: 20),
              Obx(
                () => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  ),
                  onPressed: _controller.isLoading ? null : _signInNurse,
                  child: _controller.isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Nurse Login'),
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () => Get.to(() => const AddNurseScreen()),
                child: const Text(
                  'Don’t have an account? Register as Nurse',
                  style: TextStyle(color: Colors.cyan),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}