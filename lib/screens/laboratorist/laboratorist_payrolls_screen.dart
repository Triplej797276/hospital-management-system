import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LaboratoristPayrollsScreen extends StatefulWidget {
  const LaboratoristPayrollsScreen({super.key});

  @override
  State<LaboratoristPayrollsScreen> createState() => _LaboratoristPayrollsScreenState();
}

class _LaboratoristPayrollsScreenState extends State<LaboratoristPayrollsScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'View Payrolls',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Payroll Details',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Salary Information',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'View your salary and payment details here.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection('payrolls').orderBy('date', descending: true).snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Center(child: Text('No payroll records available.'));
                              }
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final doc = snapshot.data!.docs[index];
                                  final data = doc.data() as Map<String, dynamic>;
                                  final employeeName = data['employee_name']?.toString() ?? 'Unknown';
                                  final amount = data['amount']?.toString() ?? '0.00';
                                  final date = (data['date'] as Timestamp?)?.toDate();
                                  final status = data['status']?.toString() ?? 'Pending';
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Employee: $employeeName',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text('Amount: \$${amount}'),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Date: ${date != null ? date.toString().split(' ')[0] : 'N/A'}',
                                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                  color: Colors.grey,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            'Status: $status',
                                            style: TextStyle(
                                              color: status == 'Paid' ? Colors.green : Colors.red,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}