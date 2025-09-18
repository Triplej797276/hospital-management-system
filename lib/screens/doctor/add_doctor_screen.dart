import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/doctors/add_doctor_controller.dart';

class AddDoctorScreen extends StatelessWidget {
  AddDoctorScreen({super.key});

  final DoctorController controller = Get.put(DoctorController());

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final specializationController = TextEditingController();
  final departmentController = TextEditingController();
  final qualificationController = TextEditingController();
  final experienceController = TextEditingController();
  final contactController = TextEditingController();
  final emailController = TextEditingController();
  final availabilityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Doctor'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _buildTextField('Name', nameController),
              _buildTextField('Specialization', specializationController),
              _buildTextField('Department', departmentController),
              _buildTextField('Qualifications', qualificationController),
              _buildTextField('Experience (years)', experienceController, keyboardType: TextInputType.number),
              _buildTextField('Contact', contactController, keyboardType: TextInputType.phone),
              _buildTextField('Email', emailController, keyboardType: TextInputType.emailAddress),
              _buildTextField('Availability', availabilityController),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                ),
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final doctorData = {
                      'name': nameController.text,
                      'specialization': specializationController.text,
                      'department': departmentController.text,
                      'qualifications': qualificationController.text,
                      'experience': int.tryParse(experienceController.text) ?? 0,
                      'contact': contactController.text,
                      'email': emailController.text,
                      'availability': availabilityController.text,
                    };
                    await controller.addDoctor(doctorData);
                    Get.back(); // Go back to list
                  }
                },
                child: const Text('Add Doctor'),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {TextInputType keyboardType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) => value == null || value.isEmpty ? 'Enter $label' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
