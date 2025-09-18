import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDepartmentScreen extends StatelessWidget {
  const AddDepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Department'),
        backgroundColor: const Color(0xFF0077B6),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Department Name',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    await FirebaseFirestore.instance.collection('departments').add({
                      'name': name,
                      'created_at': FieldValue.serverTimestamp(),
                    });
                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Department name is required')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B6),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                child: const Text(
                  'Add Department',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
