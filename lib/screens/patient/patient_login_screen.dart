import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/patients/patient_controller.dart';

class PatientLoginScreen extends StatelessWidget {
  const PatientLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PatientController patientController = Get.find<PatientController>();
    final emailController = TextEditingController();
    final phoneController = TextEditingController();

    Future<void> loginUser() async {
      final email = emailController.text.trim();
      final phone = phoneController.text.trim();

      if (email.isEmpty || !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        Get.snackbar('Error', 'Please enter a valid email');
        return;
      }
      if (phone.length < 10) {
        Get.snackbar('Error', 'Please enter a valid contact number (minimum 10 digits)');
        return;
      }

      await patientController.signIn(email, phone);
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
                  onPressed: patientController.isLoading.value ? null : loginUser,
                  child: patientController.isLoading.value
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