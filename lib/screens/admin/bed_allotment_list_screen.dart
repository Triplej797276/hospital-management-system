import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/admin/bed_allotment_controller.dart';

class BedAllotmentListScreen extends StatelessWidget {
  const BedAllotmentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BedAllotmentController controller = Get.put(BedAllotmentController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Beds Allotments'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (controller.bedAllotments.isEmpty) {
          return const Center(
            child: Text(
              "No Bed Allotments Found",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.bedAllotments.length,
          itemBuilder: (context, index) {
            final bed = controller.bedAllotments[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: bed['isOccupied'] ? Colors.red : Colors.green,
                  child: Icon(
                    bed['isOccupied'] ? Icons.bed : Icons.bed_outlined,
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  "Bed No: ${bed['bedNumber']}",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Ward: ${bed['ward']}"),
                    Text("Patient: ${bed['patientName']}"),
                    if (bed['patientId'] != null &&
                        bed['patientId'].toString().isNotEmpty)
                      Text("Patient ID: ${bed['patientId']}"),
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
