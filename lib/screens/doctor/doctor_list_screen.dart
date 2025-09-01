import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_doctor_screen.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors List'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctors').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading doctors',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final doctors = snapshot.data!.docs;
          if (doctors.isEmpty) {
            return const Center(
              child: Text(
                'No doctors found',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columnSpacing: 16,
                dataRowHeight: 60,
                headingRowHeight: 56,
                headingRowColor: WidgetStateProperty.all(Theme.of(context).primaryColor.withOpacity(0.1)),
                border: TableBorder.all(
                  color: Colors.grey.shade300,
                  width: 1,
                ),
                columns: const [
                  DataColumn(
                    label: Text(
                      'Doctor ID',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Specialization',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Department',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Qualifications',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Experience',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Contact',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Availability',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ],
                rows: doctors.asMap().entries.map((entry) {
                  final index = entry.key;
                  final doctor = entry.value;
                  return DataRow(
                    color: WidgetStateProperty.all(
                      index % 2 == 0 ? Colors.white : Colors.grey.shade50,
                    ),
                    cells: [
                      DataCell(
                        Text(
                          doctor['doctorId'] ?? 'N/A',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        Text(
                          doctor['name'] ?? 'Unknown',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ),
                      DataCell(
                        Text(
                          doctor['specialization'] ?? 'N/A',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        Text(
                          doctor['department'] ?? 'N/A',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        Text(
                          doctor['qualifications'] ?? 'N/A',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        Text(
                          '${doctor['experience']?.toString() ?? '0'} years',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        Text(
                          doctor['contact'] ?? 'N/A',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        Text(
                          doctor['email'] ?? 'N/A',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                      DataCell(
                        Text(
                          doctor['availability'] ?? 'N/A',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddDoctorScreen()),
        tooltip: 'Add Doctor',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}