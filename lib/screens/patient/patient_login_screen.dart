  import 'package:flutter/material.dart';
  import 'package:get/get.dart';
  import 'package:hsmproject/controllers/auth_controller.dart';

  class PatientLoginScreen extends StatelessWidget {
    const PatientLoginScreen({super.key});

    @override
    Widget build(BuildContext context) {
      final AuthController authController = Get.find<AuthController>();
      final emailController = TextEditingController();
      final phoneController = TextEditingController();

      Future<void> loginUser() async {
        await authController.signIn(
          emailController.text.trim(),
          phoneController.text.trim(),
          'patient',
        );
      }

      return Scaffold(
        appBar: AppBar(title: const Text('Patient Login')),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Enter your email',
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Contact Number (Password)',
                  hintText: 'Enter your contact number',
                ),
                keyboardType: TextInputType.phone,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              Obx(() => ElevatedButton(
                    onPressed: authController.isLoading.value ? null : loginUser,
                    child: authController.isLoading.value
                        ? const CircularProgressIndicator()
                        : const Text('Login'),
                  )),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  Get.toNamed('/add_patient');
                },
                child: const Text('Register as new patient'),
              ),
            ],
          ),
        ),
      );
    }
  }