import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/pharmacist/pharmacist_controller.dart';

class PharmacistProfileScreen extends StatelessWidget {
  const PharmacistProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PharmacistController controller = Get.put(PharmacistController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: controller.signOut,
          )
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Obx(() {
          if (controller.user.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = controller.profile.value;
          final name = data['name'] ?? controller.user.value!.displayName ?? 'Pharmacist';
          final email = data['email'] ?? controller.user.value!.email ?? '';
          final contact = data['contact'] ?? 'N/A';
          final employeeId = data['employeeId'] ?? 'N/A';
          final uid = controller.user.value!.uid;

          return Column(
            children: [
              const SizedBox(height: 20),
              const CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blue,
                child: Icon(Icons.person, size: 60, color: Colors.white),
              ),
              const SizedBox(height: 16),
              Text(
                name,
                style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pharmacist Profile',
                style: TextStyle(fontSize: 18, color: Colors.blue),
              ),
              const SizedBox(height: 24),

              // Profile Info Card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      _buildInfoRow('Name', name),
                      _buildInfoRow('Email', email),
                      _buildInfoRow('Contact', contact),
                      _buildInfoRow('Employee ID', employeeId),
                      _buildInfoRow('UID', uid),
                    ],
                  ),
                ),
              )
            ],
          );
        }),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Text(
                label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              )),
          Expanded(
              flex: 3,
              child: Text(
                value,
                style: const TextStyle(fontSize: 16),
              )),
        ],
      ),
    );
  }
}
