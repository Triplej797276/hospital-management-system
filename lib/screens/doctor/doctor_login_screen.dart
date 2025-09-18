import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import './add_doctor_screen.dart';
import '../admin/doctor_list_screen.dart';

class DoctorLoginScreen extends StatelessWidget {
  const DoctorLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final emailController = TextEditingController();
    final contactController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: const Text(
          'Doctor Login',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.list, color: Colors.white),
            onPressed: () {
              Get.to(() => const DoctorListScreen());
            },
            tooltip: 'View Doctor List',
          ),
        ],
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.medical_services,
                      size: 80, color: Colors.blueAccent),
                  const SizedBox(height: 12),
                  const Text(
                    'Doctor Portal',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Email Field
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Doctor Email',
                      prefixIcon:
                          const Icon(Icons.email, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  // Contact / Password Field
                  TextField(
                    controller: contactController,
                    decoration: InputDecoration(
                      labelText: 'Contact Number (Password)',
                      prefixIcon:
                          const Icon(Icons.phone, color: Colors.blueAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.blueAccent, width: 2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.phone,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      _handleSignIn(
                          authController, emailController, contactController);
                    },
                  ),
                  const SizedBox(height: 24),

                  // Login Button
                  Obx(() => authController.isLoading.value
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
                            onPressed: () {
                              _handleSignIn(authController, emailController,
                                  contactController);
                            },
                            child: const Text(
                              'Sign In as Doctor',
                              style: TextStyle(fontSize: 18),
                            ),
                          ),
                        )),
                  const SizedBox(height: 16),

                  // Create Account
                  TextButton(
                    onPressed: () {
                      Get.to(() =>  AddDoctorScreen());
                    },
                    child: const Text(
                      'Create Doctor Account',
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
    );
  }

  void _handleSignIn(
    AuthController authController,
    TextEditingController emailController,
    TextEditingController contactController,
  ) {
    final email = emailController.text.trim();
    final contact = contactController.text.trim();

    // Email validation
    if (email.isEmpty ||
        !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Contact validation
    if (contact.isEmpty || contact.length < 6) {
      Get.snackbar(
        'Error',
        'Contact number must be at least 6 digits',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    authController.signIn(email, contact, 'doctor');
  }
}
