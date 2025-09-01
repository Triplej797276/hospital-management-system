import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class PayrollListScreen extends StatelessWidget {
  const PayrollListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payrolls')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('payrolls').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading payrolls'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final payrolls = snapshot.data!.docs;
          return ListView.builder(
            itemCount: payrolls.length,
            itemBuilder: (context, index) {
              final payroll = payrolls[index];
              return ListTile(
                title: Text('Employee ID: ${payroll['employeeId'] ?? 'Unknown'}'),
                subtitle: Text(
                    'Role: ${payroll['role'] ?? 'N/A'} | Amount: ${payroll['amount'] ?? 'N/A'} | Date: ${payroll['date'] ?? 'N/A'}'),
              );
            },
          );
        },
      ),
    );
  }
}