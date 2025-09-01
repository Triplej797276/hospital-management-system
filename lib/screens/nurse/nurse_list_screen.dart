import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hsmproject/screens/nurse/add_nurse_screen.dart';

class NurseListScreen extends StatelessWidget {
  const NurseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nurses')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('nurses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading nurses'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final nurses = snapshot.data!.docs;
          return ListView.builder(
            itemCount: nurses.length,
            itemBuilder: (context, index) {
              final nurse = nurses[index];
              return ListTile(
                title: Text(nurse['name'] ?? 'Unknown'),
                subtitle: Text('Department: ${nurse['department'] ?? 'N/A'} | Contact: ${nurse['contact'] ?? 'N/A'}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to a screen or show a dialog to add a nurse
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNurseScreen()),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Nurse',
      ),
    );
  }
}

