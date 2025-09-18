import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hsmproject/controllers/case_manager/laboratory_services_controller.dart';

class LaboratoryServicesScreen extends StatelessWidget {
  const LaboratoryServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LaboratoryServicesController controller = Get.put(LaboratoryServicesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Laboratory Services'),
        backgroundColor: Colors.purple,
      ),
      body: Obx(() {
        if (controller.laboratorists.isEmpty) {
          return const Center(
            child: Text(
              "No Laboratorists Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.laboratorists.length,
          itemBuilder: (context, index) {
            final lab = controller.laboratorists[index];
            final formattedDate = lab['createdAt'] != null
                ? DateFormat('dd MMM yyyy, hh:mm a').format(lab['createdAt'])
                : 'Unknown';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.purple,
                          child: Text(
                            lab['name'][0].toUpperCase(),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            lab['name'],
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.purple.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            lab['role'],
                            style: const TextStyle(color: Colors.purple, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text("Email: ${lab['email']}"),
                    Text("Contact: ${lab['contact']}"),
                    Text("Created At: $formattedDate"),
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
