import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_patient_screen.dart';

class PatientList extends StatelessWidget {
  const PatientList({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Patients')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('patients').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading patients'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final patients = snapshot.data!.docs;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal, // For horizontal scrolling if table is wide
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Name')),
                DataColumn(label: Text('Age')),
                DataColumn(label: Text('Condition')),
              ],
              rows: patients.map((patient) {
                return DataRow(cells: [
                  DataCell(Text(patient['name'] ?? 'Unknown')),
                  DataCell(Text(patient['age']?.toString() ?? 'N/A')),
                  DataCell(Text(patient['condition'] ?? 'N/A')),
                ]);
              }).toList(),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddPatientScreen()),
        tooltip: 'Add Patient',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}