import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/auth_controller.dart';
import 'package:hsmproject/controllers/patients/patient_controller.dart';

class AddPatientScreen extends StatelessWidget {
  const AddPatientScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final PatientController patientController = Get.find<PatientController>();
    final nameController = TextEditingController();
    final ageController = TextEditingController();
    final conditionController = TextEditingController();
    final emailController = TextEditingController();
    final contactNumberController = TextEditingController();

    Future<void> addPatient() async {
      try {
        

        final name = nameController.text.trim();
        final age = int.tryParse(ageController.text.trim()) ?? 0;
        final condition = conditionController.text.trim();
        final email = emailController.text.trim().toLowerCase();
        final contactNumber = contactNumberController.text.trim();

        await patientController.registerPatient(
          email: email,
          contactNumber: contactNumber,
          name: name,
          age: age,
          condition: condition,
        );
      } catch (e) {
        Get.snackbar('Error', 'An unexpected error occurred: ${e.toString()}');
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
                  onPressed: patientController.isLoading.value ? null : addPatient,
                  child: patientController.isLoading.value
                      ? const CircularProgressIndicator()
                      : const Text('Add Patient'),
                )),
          ],
        ),
      ),
    );
  }
}