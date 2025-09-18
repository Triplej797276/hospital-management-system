import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/doctors/profile_controller.dart';

class DoctorProfileScreen extends StatelessWidget {
  DoctorProfileScreen({super.key});

  final Color primaryColor = const Color(0xFF1E3A8A);
  final Color backgroundColor = const Color(0xFFF5F5F5);

  final DoctorProfileController controller = Get.put(DoctorProfileController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Doctor Profile',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: primaryColor,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final doctor = controller.doctor.value;

        if (doctor == null) {
          return const Center(child: Text('Doctor data not found'));
        }

        return SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [backgroundColor, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: primaryColor,
                    child: Text(
                      doctor.name != null && doctor.name!.isNotEmpty
                          ? doctor.name![0].toUpperCase()
                          : 'D',
                      style: const TextStyle(fontSize: 40, color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text(
                    doctor.name ?? 'Doctor',
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    doctor.email ?? 'Not provided',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                ),
                const SizedBox(height: 24),
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Profile Information', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const Divider(height: 20, thickness: 1),
                        Row(children: [const Icon(Icons.person), const SizedBox(width: 10), Text(doctor.name ?? 'Not provided')]),
                        const SizedBox(height: 12),
                        Row(children: [const Icon(Icons.email), const SizedBox(width: 10), Text(doctor.email ?? 'Not provided')]),
                        const SizedBox(height: 12),
                        Row(children: [const Icon(Icons.phone), const SizedBox(width: 10), Text(doctor.phone ?? 'Not provided')]),
                        const SizedBox(height: 12),
                        Row(children: [const Icon(Icons.badge), const SizedBox(width: 10), Text(doctor.specialization ?? 'General')]),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
