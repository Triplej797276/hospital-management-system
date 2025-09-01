import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LaboratoristListScreen extends StatelessWidget {
  const LaboratoristListScreen({super.key});

  // Method to show the form for adding a new laboratorist
  void _showAddLaboratoristForm(BuildContext context) {
    final nameController = TextEditingController();
    final contactController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Laboratorist'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: contactController,
                decoration: const InputDecoration(labelText: 'Contact'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact information';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await FirebaseFirestore.instance
                      .collection('laboratorists')
                      .add({
                    'name': nameController.text,
                    'contact': contactController.text,
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error adding laboratorist: $e')),
                  );
                }
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Laboratorists')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('laboratorists').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading laboratorists'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final laboratorists = snapshot.data!.docs;
          return ListView.builder(
            itemCount: laboratorists.length,
            itemBuilder: (context, index) {
              final laboratorist = laboratorists[index];
              return ListTile(
                title: Text(laboratorist['name'] ?? 'Unknown'),
                subtitle: Text('Contact: ${laboratorist['contact'] ?? 'N/A'}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddLaboratoristForm(context),
        child: const Icon(Icons.add),
        tooltip: 'Add Laboratorist',
      ),
    );
  }
}