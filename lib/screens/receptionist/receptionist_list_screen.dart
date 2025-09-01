import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/screens/receptionist/add_receptionist.dart'; // Adjust path as needed

class ReceptionistListScreen extends StatelessWidget {
  const ReceptionistListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Receptionists'),
        backgroundColor: Colors.blue,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('receptionists').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print('Firestore error: ${snapshot.error}');
            return const Center(child: Text('Error loading receptionists'));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final receptionists = snapshot.data!.docs;
          return ListView.builder(
            itemCount: receptionists.length,
            itemBuilder: (context, index) {
              final receptionist = receptionists[index];
              final data = receptionist.data() as Map<String, dynamic>;
              final photoUrl = data.containsKey('photoUrl') ? data['photoUrl'] as String? : null;
              return ListTile(
                leading: photoUrl != null && photoUrl.isNotEmpty
                    ? CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.grey[200],
                        child: ClipOval(
                          child: Image.network(
                            photoUrl,
                            fit: BoxFit.cover,
                            width: 40,
                            height: 40,
                            errorBuilder: (context, error, stackTrace) {
                              print('Image load error for URL $photoUrl: $error');
                              return const Icon(Icons.broken_image, color: Colors.red);
                            },
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                              );
                            },
                          ),
                        ),
                      )
                    : const CircleAvatar(
                        radius: 20,
                        child: Icon(Icons.person, color: Colors.grey),
                      ),
                title: Text(data['name'] ?? 'Unknown'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact: ${data['contact'] ?? 'N/A'}'),
                    Text('Email: ${data['email'] ?? 'N/A'}'),
                    Text('Address: ${data['address'] ?? 'N/A'}'),
                    Text('Role: ${data['role'] ?? 'N/A'}'),
                    Text('Shift: ${data['shift'] ?? 'N/A'}'),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => const AddReceptionistScreen()),
        tooltip: 'Add Receptionist',
        child: const Icon(Icons.person_add),
      ),
    );
  }
}