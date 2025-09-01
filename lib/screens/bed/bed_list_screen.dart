import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BedListScreen extends StatelessWidget {
  const BedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beds Management')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('beds').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading beds'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final beds = snapshot.data!.docs;
          return ListView.builder(
            itemCount: beds.length,
            itemBuilder: (context, index) {
              final bed = beds[index];
              return ListTile(
                title: Text('Bed ID: ${bed['id'] ?? 'Unknown'}'),
                subtitle: Text(
                    'Ward: ${bed['ward'] ?? 'N/A'} | Status: ${bed['status'] ?? 'N/A'} | Patient ID: ${bed['patientId'] ?? 'None'}'),
              );
            },
          );
        },
      ),
    );
  }
}