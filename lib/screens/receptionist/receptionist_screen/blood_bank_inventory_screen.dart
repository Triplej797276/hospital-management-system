import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/receptionists/blood_bank_services_controller.dart';

class BloodInventoryScreens extends StatelessWidget {
  const BloodInventoryScreens({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BloodInventoryController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Blood Inventory'),
        backgroundColor: Colors.redAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.bloodUnits.isEmpty) {
            return const Center(
              child: Text(
                'No blood units found',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            );
          }

          return ListView.builder(
            itemCount: controller.bloodUnits.length,
            itemBuilder: (context, index) {
              final unit = controller.bloodUnits[index];
              return Card(
                elevation: 3,
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: unit['status'] == 'Available' ? Colors.green : Colors.orange,
                    child: Text(unit['bloodGroup'], style: const TextStyle(color: Colors.white)),
                  ),
                  title: Text('Units: ${unit['unitsAvailable']}'),
                  subtitle: Text('Status: ${unit['status']}\nDonor: ${unit['donorName']}'),
                  isThreeLine: true,
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          // Add edit functionality here
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          controller.deleteBloodUnit(unit['id']);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.redAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          // Add new blood unit dialog
        },
      ),
    );
  }
}
