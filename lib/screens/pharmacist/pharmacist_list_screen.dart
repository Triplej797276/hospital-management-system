import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'add_pharmacist_screen.dart'; // Import the add pharmacist screen

class PharmacistListScreen extends StatelessWidget {
  const PharmacistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pharmacists')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pharmacists').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading pharmacists'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final pharmacists = snapshot.data!.docs;
          return ListView.builder(
            itemCount: pharmacists.length,
            itemBuilder: (context, index) {
              final pharmacist = pharmacists[index];
              return ListTile(
                title: Text(pharmacist['name'] ?? 'Unknown'),
                subtitle: Text('Contact: ${pharmacist['contact'] ?? 'N/A'}'),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPharmacistScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
        tooltip: 'Add Pharmacist',
      ),
    );
  }
}