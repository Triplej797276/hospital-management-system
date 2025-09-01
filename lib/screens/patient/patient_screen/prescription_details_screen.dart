import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PrescriptionDetailsScreen extends StatelessWidget {
  const PrescriptionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prescription = Get.arguments as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Prescription Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prescription Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text('Doctor: ${prescription['doctorName'] ?? 'Unknown'}'),
            Text('Medication: ${prescription['medication'] ?? 'N/A'}'),
            // Add more fields as needed (e.g., dosage, instructions)
          ],
        ),
      ),
    );
  }
}