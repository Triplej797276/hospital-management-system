import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/screens/receptionist/add_receptionist.dart';

class ReceptionistListScreen extends StatelessWidget {
  const ReceptionistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receptionists'),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('receptionists')
            .orderBy('name')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading receptionists'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final receptionists = snapshot.data!.docs;

          if (receptionists.isEmpty) {
            return const Center(
              child: Text(
                "No Receptionists Found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              // 🔹 Counter card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Total Receptionists: ${receptionists.length}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),

              // 🔹 Data table
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.all(Colors.blue[100]),
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columns: const [
                      DataColumn(
                          label: Text("Photo",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue))),
                      DataColumn(
                          label: Text("Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue))),
                      DataColumn(
                          label: Text("Contact",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue))),
                      DataColumn(
                          label: Text("Email",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue))),
                      DataColumn(
                          label: Text("Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue))),
                      DataColumn(
                          label: Text("Role",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue))),
                      DataColumn(
                          label: Text("Shift",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue))),
                    ],
                    rows: receptionists.map((receptionist) {
                      final data =
                          receptionist.data() as Map<String, dynamic>;
                      final photoUrl = data['photoUrl'] as String?;

                      return DataRow(
                        cells: [
                          DataCell(
                            CircleAvatar(
                              radius: 20,
                              backgroundColor: Colors.grey[200],
                              backgroundImage: (photoUrl != null &&
                                      photoUrl.isNotEmpty)
                                  ? NetworkImage(photoUrl)
                                  : null,
                              child: (photoUrl == null || photoUrl.isEmpty)
                                  ? const Icon(Icons.person,
                                      color: Colors.grey)
                                  : null,
                            ),
                          ),
                          DataCell(Text(data['name'] ?? 'Unknown')),
                          DataCell(Text(data['contact'] ?? 'N/A')),
                          DataCell(Text(data['email'] ?? 'N/A')),
                          DataCell(Text(data['address'] ?? 'N/A')),
                          DataCell(Text(data['role'] ?? 'N/A')),
                          DataCell(Text(data['shift'] ?? 'N/A')),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // 🔹 Floating button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () => Get.to(() => const AddReceptionistScreen()),
        icon: const Icon(Icons.person_add),
        label: const Text("Add Receptionist"),
      ),
    );
  }
}
