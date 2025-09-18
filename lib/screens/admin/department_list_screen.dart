import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_department_screen.dart';

class DepartmentListScreen extends StatelessWidget {
  const DepartmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Departments')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('departments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading departments'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final departments = snapshot.data!.docs;
          return ListView.builder(
            itemCount: departments.length,
            itemBuilder: (context, index) {
              final department = departments[index];
              return ListTile(
                title: Text(department['name'] ?? 'Unknown'),
                subtitle: Text('Roles: ${department['roles']?.join(', ') ?? 'N/A'}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddDepartmentScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}