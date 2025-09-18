import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/receptionists/emergency_services_controller.dart';

class EmergencyServicesScreen extends StatelessWidget {
  const EmergencyServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final EmergencyServicesController controller = Get.put(EmergencyServicesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text("Emergency Services"),
        backgroundColor: Colors.redAccent,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          _showAddEmergencyDialog(context, controller);
        },
      ),
      body: Obx(() {
        if (controller.emergencies.isEmpty) {
          return const Center(
            child: Text(
              "No Emergency Cases",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.emergencies.length,
          itemBuilder: (context, index) {
            final caseData = controller.emergencies[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _statusColor(caseData['status']),
                  child: const Icon(Icons.local_hospital, color: Colors.white),
                ),
                title: Text(
                  caseData['patientName'],
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Emergency: ${caseData['emergencyType']}"),
                    Text("Status: ${caseData['status']}"),
                    if (caseData['time'] != null)
                      Text("Time: ${caseData['time']}"),
                  ],
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "Delete") {
                      controller.deleteEmergency(caseData['id']);
                    } else {
                      controller.updateStatus(caseData['id'], value);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: "Admitted", child: Text("Mark as Admitted")),
                    const PopupMenuItem(value: "Under Treatment", child: Text("Mark as Under Treatment")),
                    const PopupMenuItem(value: "Critical", child: Text("Mark as Critical")),
                    const PopupMenuItem(value: "Discharged", child: Text("Mark as Discharged")),
                    const PopupMenuDivider(),
                    const PopupMenuItem(value: "Delete", child: Text("Delete Case")),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }

  /// 🔹 Color based on status
  Color _statusColor(String status) {
    switch (status) {
      case "Admitted":
        return Colors.blue;
      case "Under Treatment":
        return Colors.orange;
      case "Critical":
        return Colors.red;
      case "Discharged":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  /// 🔹 Add new emergency dialog
  void _showAddEmergencyDialog(BuildContext context, EmergencyServicesController controller) {
    final nameCtrl = TextEditingController();
    final typeCtrl = TextEditingController();
    String status = "Admitted";

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Emergency Case"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: "Patient Name"),
              ),
              TextField(
                controller: typeCtrl,
                decoration: const InputDecoration(labelText: "Emergency Type"),
              ),
              DropdownButtonFormField<String>(
                value: status,
                items: const [
                  DropdownMenuItem(value: "Admitted", child: Text("Admitted")),
                  DropdownMenuItem(value: "Under Treatment", child: Text("Under Treatment")),
                  DropdownMenuItem(value: "Critical", child: Text("Critical")),
                  DropdownMenuItem(value: "Discharged", child: Text("Discharged")),
                ],
                onChanged: (val) {
                  if (val != null) status = val;
                },
                decoration: const InputDecoration(labelText: "Status"),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
            ElevatedButton(
              onPressed: () {
                if (nameCtrl.text.isNotEmpty && typeCtrl.text.isNotEmpty) {
                  controller.addEmergency(nameCtrl.text, typeCtrl.text, status);
                  Get.back();
                }
              },
              child: const Text("Add"),
            ),
          ],
        );
      },
    );
  }
}
