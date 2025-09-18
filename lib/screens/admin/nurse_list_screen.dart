import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hsmproject/screens/nurse/add_nurse_screen.dart';

class NurseListScreen extends StatelessWidget {
  const NurseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Nurses"),
        backgroundColor: Colors.teal[400],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('nurses').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading nurses"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final nurses = snapshot.data!.docs;

          if (nurses.isEmpty) {
            return const Center(
              child: Text(
                "No Nurses Found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              // 🔹 Counter
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Total Nurses: ${nurses.length}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal,
                  ),
                ),
              ),

              // 🔹 DataTable
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.teal[50]),
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columns: const [
                        DataColumn(
                          label: Text(
                            "Name",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Department",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Contact",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                      ],
                      rows: nurses.map((nurse) {
                        return DataRow(
                          cells: [
                            DataCell(Text(nurse['name'] ?? "Unknown")),
                            DataCell(Text(nurse['department'] ?? "N/A")),
                            DataCell(Text(nurse['contact'] ?? "N/A")),
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // 🔹 Floating Action Button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddNurseScreen()),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text("Add Nurse"),
      ),
    );
  }
}
