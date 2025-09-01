import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BloodBankScreen extends StatelessWidget {
  const BloodBankScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Bank')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('blood_bank').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading blood bank'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final bloodRecords = snapshot.data!.docs;
          return ListView.builder(
            itemCount: bloodRecords.length,
            itemBuilder: (context, index) {
              final blood = bloodRecords[index];
              return ListTile(
                title: Text('Blood Type: ${blood['bloodType'] ?? 'Unknown'}'),
                subtitle: Text('Quantity: ${blood['quantity'] ?? 'N/A'}'),
              );
            },
          );
        },
      ),
    );
  }
}