import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LaboratoristNoticesScreen extends StatefulWidget {
  const LaboratoristNoticesScreen({super.key});

  @override
  State<LaboratoristNoticesScreen> createState() => _LaboratoristNoticesScreenState();
}

class _LaboratoristNoticesScreenState extends State<LaboratoristNoticesScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Latest Notices',
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
                'Notices',
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
                          'Recent Notices',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'Check the latest updates and notices here.',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection('notices').orderBy('timestamp', descending: true).snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Center(child: Text('No notices available.'));
                              }
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final doc = snapshot.data!.docs[index];
                                  final data = doc.data() as Map<String, dynamic>;
                                  final title = data['title']?.toString() ?? 'Untitled Notice';
                                  final content = data['content']?.toString() ?? 'No content available.';
                                  final timestamp = (data['timestamp'] as Timestamp?)?.toDate();
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            title,
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.teal,
                                                ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(content),
                                          const SizedBox(height: 8),
                                          if (timestamp != null)
                                            Text(
                                              'Posted on: ${timestamp.toString().split(' ')[0]}',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: Colors.grey,
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