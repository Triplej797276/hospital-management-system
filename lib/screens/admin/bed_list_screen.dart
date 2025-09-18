import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BedListScreen extends StatelessWidget {
  const BedListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Beds Management'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('beds').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('❌ Error loading beds'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final beds = snapshot.data!.docs;

          if (beds.isEmpty) {
            return const Center(child: Text('No Beds Found'));
          }

          return ListView.builder(
            itemCount: beds.length,
            itemBuilder: (context, index) {
              final bed = beds[index];
              final bedData = bed.data() as Map<String, dynamic>;

              final isOccupied = bedData['isOccupied'] ?? false;
              final ward = bedData['ward'] ?? 'N/A';
              final bedNumber = bedData['bedNumber'] ?? 'Unknown';
              final patientId = bedData['patientId'] ?? 'None';

              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    radius: 28,
                    backgroundColor: isOccupied ? Colors.red : Colors.green,
                    child: Icon(
                      isOccupied ? Icons.hotel : Icons.bed_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  title: Text(
                    "Bed No: $bedNumber",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ward: $ward",
                            style: const TextStyle(fontSize: 14)),
                        Text("Patient ID: $patientId",
                            style: const TextStyle(fontSize: 14)),
                        Text(
                          isOccupied ? "Status: Occupied" : "Status: Available",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isOccupied ? Colors.red : Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 18),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
