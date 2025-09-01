import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentDetailsScreen extends StatelessWidget {
  const DocumentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final document = Get.arguments as Map<String, dynamic>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Document Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            Text('Title: ${document['title'] ?? 'Untitled'}'),
            Text('Created: ${document['createdAt'] ?? 'N/A'}'),
            Text('Content: ${document['content'] ?? 'N/A'}'),
            // Add more fields or actions as needed (e.g., download, edit)
          ],
        ),
      ),
    );
  }
}