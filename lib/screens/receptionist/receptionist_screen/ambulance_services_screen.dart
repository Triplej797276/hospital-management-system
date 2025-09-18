import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/receptionists/ambulance_services_controller.dart';

class AmbulanceServicesScreen extends StatelessWidget {
  const AmbulanceServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AmbulanceServicesController controller =
        Get.put(AmbulanceServicesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ambulance Services'),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddAmbulanceDialog(context, controller);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Obx(() {
              // Calculate counts
              final availableCount = controller.ambulances
                  .where((a) => a["status"] == "Available")
                  .length;
              final assignedCount = controller.ambulances
                  .where((a) => a["status"] == "Assigned")
                  .length;

              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildCounterCard(
                    color: Colors.green,
                    label: "Available",
                    count: availableCount,
                  ),
                  _buildCounterCard(
                    color: Colors.orange,
                    label: "Assigned",
                    count: assignedCount,
                  ),
                  _buildCounterCard(
                    color: Colors.redAccent,
                    label: "Total",
                    count: controller.ambulances.length,
                  ),
                ],
              );
            }),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.ambulances.isEmpty) {
                  return const Center(
                    child: Text(
                      "No ambulances available",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(0),
                  itemCount: controller.ambulances.length,
                  itemBuilder: (context, index) {
                    final ambulance = controller.ambulances[index];
                    return Card(
                      elevation: 3,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: ambulance["status"] == "Assigned"
                              ? Colors.orange
                              : Colors.green,
                          child: const Icon(Icons.local_hospital,
                              color: Colors.white),
                        ),
                        title: Text(
                          "Vehicle: ${ambulance["vehicleNumber"]}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Type: ${ambulance["type"]}\nStatus: ${ambulance["status"]}",
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == "delete") {
                              controller.deleteAmbulance(ambulance["id"]);
                            } else if (value == "assign") {
                              controller.updateAmbulanceStatus(
                                  ambulance["id"], "Assigned");
                            } else if (value == "available") {
                              controller.updateAmbulanceStatus(
                                  ambulance["id"], "Available");
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(
                              value: "assign",
                              child: Text("Mark as Assigned"),
                            ),
                            PopupMenuItem(
                              value: "available",
                              child: Text("Mark as Available"),
                            ),
                            PopupMenuItem(
                              value: "delete",
                              child: Text("Delete"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a counter card
  Widget _buildCounterCard({
    required Color color,
    required String label,
    required int count,
  }) {
    return Card(
      elevation: 4,
      color: color.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        width: 100,
        height: 70,
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$count",
              style: const TextStyle(
                  fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  /// Dialog for adding a new ambulance
  void _showAddAmbulanceDialog(
      BuildContext context, AmbulanceServicesController controller) {
    final typeController = TextEditingController();
    final vehicleController = TextEditingController();
    String status = "Available";

    Get.defaultDialog(
      title: "Add Ambulance",
      content: Column(
        children: [
          TextField(
            controller: typeController,
            decoration: const InputDecoration(
              labelText: "Ambulance Type",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: vehicleController,
            decoration: const InputDecoration(
              labelText: "Vehicle Number",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: status,
            decoration: const InputDecoration(
              labelText: "Status",
              border: OutlineInputBorder(),
            ),
            items: ["Available", "Assigned"]
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (value) {
              status = value ?? "Available";
            },
          ),
        ],
      ),
      textCancel: "Cancel",
      textConfirm: "Add",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (typeController.text.isNotEmpty &&
            vehicleController.text.isNotEmpty) {
          controller.addAmbulance(
            type: typeController.text,
            vehicleNumber: vehicleController.text,
            status: status,
          );
          Get.back();
        } else {
          Get.snackbar("Error", "Please fill all fields");
        }
      },
    );
  }
}
