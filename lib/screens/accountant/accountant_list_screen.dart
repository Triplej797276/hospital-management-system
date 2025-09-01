import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'add_accountant_screen.dart';

class AccountantListScreen extends StatelessWidget {
  const AccountantListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accountants'),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('accountants').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading accountants'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final accountants = snapshot.data!.docs;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Contact')),
                  DataColumn(label: Text('Email')),
                  DataColumn(label: Text('Address')),
                  DataColumn(label: Text('Designation')),
                  DataColumn(label: Text('Salary')),
                  DataColumn(label: Text('Department')),
                  DataColumn(label: Text('Joining Date')),
                ],
                rows: accountants.map((accountant) {
                  return DataRow(cells: [
                    DataCell(Text(accountant['name'] ?? 'Unknown')),
                    DataCell(Text(accountant['contact'] ?? 'N/A')),
                    DataCell(Text(accountant['email'] ?? 'N/A')),
                    DataCell(Text(accountant['address'] ?? 'N/A')),
                    DataCell(Text(accountant['designation'] ?? 'N/A')),
                    DataCell(Text(accountant['salary']?.toString() ?? '0.0')),
                    DataCell(Text(accountant['department'] ?? 'N/A')),
                    DataCell(Text(accountant['joining_date'] ?? 'N/A')),
                  ]);
                }).toList(),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddAccountantScreen()),
        tooltip: 'Add Accountant',
        backgroundColor: Colors.blue[700],
        child: const Icon(Icons.person_add, color: Colors.white, size: 28),
        elevation: 6,
        hoverElevation: 12,
      ),
    );
  }
}