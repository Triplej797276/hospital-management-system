import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AddDepartmentScreen extends StatelessWidget {
  const AddDepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();
    final rolesController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Add New Department')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Department Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: rolesController,
              decoration: const InputDecoration(
                labelText: 'Roles (comma-separated, optional)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isNotEmpty) {
                  final roles = rolesController.text
                      .split(',')
                      .map((role) => role.trim())
                      .where((role) => role.isNotEmpty)
                      .toList();

                  await FirebaseFirestore.instance.collection('departments').add({
                    'name': name,
                    'roles': roles,
                  });
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Department name is required')),
                  );
                }
              },
              child: const Text('Add Department'),
            ),
          ],
        ),
      ),
    );
  }
}