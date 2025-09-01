import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BedAllotmentListScreen extends StatelessWidget {
  const BedAllotmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Beds Allotments')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('bed_allotments').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading bed allotments'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final allotments = snapshot.data!.docs;
          return ListView.builder(
            itemCount: allotments.length,
            itemBuilder: (context, index) {
              final allotment = allotments[index];
              return ListTile(
                title: Text('Bed ID: ${allotment['bedId'] ?? 'Unknown'}'),
                subtitle: Text('Patient ID: ${allotment['patientId'] ?? 'N/A'} | Allotment Date: ${allotment['allotmentDate'] ?? 'N/A'}'),
              );
            },
          );
        },
      ),
    );
  }
}