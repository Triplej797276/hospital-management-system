import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/receptionists/beds_services_controller.dart';

class BedsServicesScreen extends StatelessWidget {
  const BedsServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BedsServicesController controller = Get.put(BedsServicesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beds Services'),
        backgroundColor: Colors.indigo,
      ),
      body: Obx(() {
        if (controller.beds.isEmpty) {
          return const Center(
            child: Text(
              "No Beds Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.beds.length,
          itemBuilder: (context, index) {
            final bed = controller.beds[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: bed['isOccupied'] ? Colors.red : Colors.green,
                  child: Icon(
                    bed['isOccupied'] ? Icons.hotel : Icons.bed,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Bed ${bed['bedNumber']} - ${bed['ward']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Occupied: ${bed['isOccupied'] ? 'Yes' : 'No'}"),
                    Text("Patient ID: ${bed['patientId'].isEmpty ? 'N/A' : bed['patientId']}"),
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
