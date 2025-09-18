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

    Future<void> _addNurse() async {
      if (_formKey.currentState!.validate()) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        try {
          final userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim(),
          );

          await userCredential.user!.sendEmailVerification();

          await FirebaseFirestore.instance.collection('nurses').add({
            'name': _nameController.text,
            'department': _departmentController.text,
            'contact': _contactController.text,
            'email': _emailController.text.trim(),
            'created_at': FieldValue.serverTimestamp(),
          });

          Navigator.pop(context);
          Get.snackbar(
            'Success',
            'Nurse added successfully. Please verify your email.',
            snackPosition: SnackPosition.BOTTOM,
          );
          Navigator.pop(context);
        } on FirebaseAuthException catch (e) {
          Navigator.pop(context);
          String errorMessage = e.code == 'email-already-in-use'
              ? 'This email is already registered.'
              : e.code == 'invalid-email'
                  ? 'Invalid email format.'
                  : 'Failed to add nurse: ${e.message}';
          Get.snackbar('Error', errorMessage,
              snackPosition: SnackPosition.BOTTOM);
        }
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Nurse'),
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField(_nameController, 'Name', 'Enter a name'),
              _buildTextField(_emailController, 'Email', 'Enter email',
                  keyboardType: TextInputType.emailAddress, validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter an email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              }),
              _buildTextField(
                  _departmentController, 'Department', 'Enter department'),
              _buildTextField(_contactController, 'Contact', 'Enter contact',
                  keyboardType: TextInputType.phone, validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Enter a contact';
                }
                if (!RegExp(r'^\+?[\d\s-]{10,15}$').hasMatch(value)) {
                  return 'Enter a valid phone number';
                }
                return null;
              }),
              _buildTextField(_passwordController, 'Password', 'Enter password',
                  obscureText: true, validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a password';
                }
                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }
                return null;
              }),
              _buildTextField(
                  _confirmPasswordController, 'Confirm Password', 'Re-enter password',
                  obscureText: true, validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != _passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              }),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _addNurse,
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0077B6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8))),
                  child: const Text(
                    'Add Nurse',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label,
      String hintText, {
        bool obscureText = false,
        TextInputType keyboardType = TextInputType.text,
        String? Function(String?)? validator,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator ??
                (value) => value == null || value.isEmpty ? 'Enter $label' : null,
        decoration: InputDecoration(
          labelText: label,
          hintText: hintText,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
