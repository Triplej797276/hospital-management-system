import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../pharmacist/add_pharmacist_screen.dart'; // Import the add pharmacist screen

class PharmacistListScreen extends StatelessWidget {
  const PharmacistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacists'),
        backgroundColor: Colors.green,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pharmacists')
            .orderBy('name')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading pharmacists'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final pharmacists = snapshot.data!.docs;

          if (pharmacists.isEmpty) {
            return const Center(
              child: Text(
                "No Pharmacists Found",
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
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Total Pharmacists: ${pharmacists.length}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                ),
              ),

              // 🔹 Data table
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor:
                        MaterialStateProperty.all(Colors.green[100]),
                    border: TableBorder.all(color: Colors.grey.shade300),
                    columns: const [
                      DataColumn(
                          label: Text("Name",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green))),
                      DataColumn(
                          label: Text("Contact",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green))),
                      DataColumn(
                          label: Text("Email",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green))),
                      DataColumn(
                          label: Text("Address",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green))),
                      DataColumn(
                          label: Text("Role",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green))),
                    ],
                    rows: pharmacists.map((pharmacist) {
                      final data = pharmacist.data() as Map<String, dynamic>;

                      return DataRow(
                        cells: [
                          DataCell(Text(data['name'] ?? 'Unknown')),
                          DataCell(Text(data['contact'] ?? 'N/A')),
                          DataCell(Text(data['email'] ?? 'N/A')),
                          DataCell(Text(data['address'] ?? 'N/A')),
                          DataCell(Text(data['role'] ?? 'N/A')),
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
        backgroundColor: Colors.green,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddPharmacistScreen(),
            ),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text("Add Pharmacist"),
      ),
    );
  }
}
