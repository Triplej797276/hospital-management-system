import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/receptionists/packages_services_controller.dart';

class PackagesServicesScreen extends StatelessWidget {
  const PackagesServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PackagesServicesController controller = Get.put(PackagesServicesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Packages Services'),
        backgroundColor: Colors.green,
      ),
      body: Obx(() {
        if (controller.packages.isEmpty) {
          return const Center(
            child: Text(
              "No Packages Available",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          itemCount: controller.packages.length,
          itemBuilder: (context, index) {
            final pkg = controller.packages[index];
            return Card(
              margin: const EdgeInsets.all(12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ExpansionTile(
                title: Text(pkg['packageName'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                subtitle: Text("₹${pkg['price']} | ${pkg['duration']}"),
                children: [
                  ...pkg['services'].map<Widget>((service) => ListTile(
                        leading: const Icon(Icons.check_circle, color: Colors.green),
                        title: Text(service),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.deletePackage(pkg['id']),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddPackageDialog(context, controller);
        },
      ),
    );
  }

  /// 🔹 Dialog to add new package
  void _showAddPackageDialog(BuildContext context, PackagesServicesController controller) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final durationCtrl = TextEditingController();
    final servicesCtrl = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Add New Package"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: "Package Name")),
              TextField(controller: priceCtrl, decoration: const InputDecoration(labelText: "Price (₹)"), keyboardType: TextInputType.number),
              TextField(controller: durationCtrl, decoration: const InputDecoration(labelText: "Duration")),
              TextField(
                controller: servicesCtrl,
                decoration: const InputDecoration(
                    labelText: "Services (comma separated)", hintText: "Ex: Doctor Visit, Blood Test"),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && priceCtrl.text.isNotEmpty) {
                final services = servicesCtrl.text.split(',').map((e) => e.trim()).toList();
                controller.addPackage(
                  nameCtrl.text,
                  int.parse(priceCtrl.text),
                  durationCtrl.text,
                  services,
                );
                Get.back();
              }
            },
            child: const Text("Add"),
          ),
        ],
      ),
    );
  }
}
