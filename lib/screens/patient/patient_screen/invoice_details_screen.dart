import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InvoiceDetailsScreen extends StatelessWidget {
  const InvoiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invoice = Get.arguments as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Invoice Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Invoice Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text('Invoice #: ${invoice['invoiceId'] ?? 'N/A'}'),
            Text('Amount: \$${invoice['amount'] ?? '0'}'),
            Text('Date: ${invoice['date'] ?? 'N/A'}'),
            // Add more fields as needed (e.g., description, payment status)
          ],
        ),
      ),
    );
  }
}