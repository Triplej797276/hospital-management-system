import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import './doctor_list_screen.dart'; // Import the new DoctorListScreen

class AddDoctorScreen extends StatelessWidget {
  const AddDoctorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final doctorIdController = TextEditingController();
    final specializationController = TextEditingController();
    final departmentController = TextEditingController();
    final qualificationsController = TextEditingController();
    final experienceController = TextEditingController();
    final contactController = TextEditingController();
    final emailController = TextEditingController();
    final addressController = TextEditingController();
    final availabilityController = TextEditingController();
    final RxBool isLoading = false.obs;

    Future<void> addDoctor() async {
      if (!formKey.currentState!.validate()) return;

      isLoading.value = true;
      try {
        // Register doctor using email and contact number as password
        await authController.registerDoctor(
          emailController.text.trim(),
          contactController.text.trim(),
          nameController.text.trim(),
        );

        // Add additional doctor details to Firestore
        await FirebaseFirestore.instance.collection('doctors').add({
          'doctorId': doctorIdController.text.trim(),
          'name': nameController.text.trim(),
          'specialization': specializationController.text.trim(),
          'department': departmentController.text.trim(),
          'qualifications': qualificationsController.text.trim(),
          'experience': int.tryParse(experienceController.text.trim()) ?? 0,
          'contact': contactController.text.trim(),
          'email': emailController.text.trim().toLowerCase(),
          'address': addressController.text.trim(),
          'availability': availabilityController.text.trim(),
          'timestamp': FieldValue.serverTimestamp(),
        });

        // Navigate to DoctorListScreen after successful addition
        Get.off(() => const DoctorListScreen());
        Get.snackbar('Success', 'Doctor added successfully',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white);
      } catch (e) {
        Get.snackbar('Error', e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white);
      } finally {
        isLoading.value = false;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Doctor'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: doctorIdController,
                  decoration: const InputDecoration(
                    labelText: 'Doctor ID',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Doctor ID';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Doctor Name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Doctor Name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: specializationController,
                  decoration: const InputDecoration(
                    labelText: 'Specialization',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Specialization';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: departmentController,
                  decoration: const InputDecoration(
                    labelText: 'Department',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Department';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: qualificationsController,
                  decoration: const InputDecoration(
                    labelText: 'Qualifications (e.g., MBBS, MD)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Qualifications';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: experienceController,
                  decoration: const InputDecoration(
                    labelText: 'Years of Experience',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Years of Experience';
                    }
                    if (int.tryParse(value) == null || int.parse(value) < 0) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: contactController,
                  decoration: const InputDecoration(
                    labelText: 'Contact Number (Used as Password)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Contact Number';
                    }
                    if (!RegExp(r'^\+?[1-9]\d{1,14}$').hasMatch(value.trim())) {
                      return 'Please enter a valid phone number';
                    }
                    if (value.trim().length < 6) {
                      return 'Contact number must be at least 6 digits for password';
                    }
                    return null;
                  },
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
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Email';
                    }
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: addressController,
                  decoration: const InputDecoration(
                    labelText: 'Address (Optional)',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: availabilityController,
                  decoration: const InputDecoration(
                    labelText: 'Availability (e.g., Mon-Fri, 9AM-5PM)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter Availability';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                Obx(
                  () => ElevatedButton(
                    onPressed: isLoading.value ? null : addDoctor,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      backgroundColor: Theme.of(context).primaryColor,
                    ),
                    child: isLoading.value
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                            'Add Doctor',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}