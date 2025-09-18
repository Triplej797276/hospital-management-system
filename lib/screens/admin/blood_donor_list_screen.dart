import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BloodDonorListScreen extends StatelessWidget {
  const BloodDonorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Blood Donors')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('blood_donors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading blood donors'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final donors = snapshot.data!.docs;
          return ListView.builder(
            itemCount: donors.length,
            itemBuilder: (context, index) {
              final donor = donors[index];
              return ListTile(
                title: Text(donor['name'] ?? 'Unknown'),
                subtitle: Text(
                    'Blood Type: ${donor['bloodType'] ?? 'N/A'} | Contact: ${donor['contact'] ?? 'N/A'} | Last Donation: ${donor['lastDonation'] ?? 'None'}'),
              );
            },
          );
        },
      ),
    );
  }
}