import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/receptionists/pharmacists_services_controller.dart';

class PharmacistsServicesScreen extends StatelessWidget {
  const PharmacistsServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PharmacistsServicesController controller =
        Get.put(PharmacistsServicesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pharmacists Services'),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        if (controller.pharmacists.isEmpty) {
          return const Center(
            child: Text(
              "No Pharmacists Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.pharmacists.length,
          itemBuilder: (context, index) {
            final pharm = controller.pharmacists[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Colors.teal,
                  child: Icon(Icons.local_pharmacy, color: Colors.white),
                ),
                title: Text(
                  pharm['name'],
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Email: ${pharm['email']}"),
                    Text("Phone: ${pharm['phone']}"),
                    Text("License: ${pharm['license']}"),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
