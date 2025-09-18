import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/receptionists/insurance_services_controller.dart';

class InsuranceServicesScreen extends StatelessWidget {
  const InsuranceServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final InsuranceServicesController controller =
        Get.put(InsuranceServicesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Insurance Services'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 4,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add),
        onPressed: () {
          _showAddInsuranceDialog(context, controller);
        },
      ),
      body: Obx(() {
        if (controller.insurances.isEmpty) {
          return const Center(
            child: Text(
              "No insurance records available",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.insurances.length,
          itemBuilder: (context, index) {
            final insurance = controller.insurances[index];
            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: insurance["status"] == "Active"
                      ? Colors.green
                      : (insurance["status"] == "Expired"
                          ? Colors.red
                          : Colors.orange),
                  child: const Icon(Icons.assignment, color: Colors.white),
                ),
                title: Text(
                  "${insurance["companyName"]}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  "Policy: ${insurance["policyNumber"]}\nCoverage: ${insurance["coverage"]}\nExpiry: ${insurance["expiryDate"]}\nStatus: ${insurance["status"]}",
                ),
                isThreeLine: true,
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == "delete") {
                      controller.deleteInsurance(insurance["id"]);
                    } else {
                      controller.updateInsuranceStatus(insurance["id"], value);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: "Active",
                      child: Text("Mark as Active"),
                    ),
                    const PopupMenuItem(
                      value: "Expired",
                      child: Text("Mark as Expired"),
                    ),
                    const PopupMenuItem(
                      value: "Pending",
                      child: Text("Mark as Pending"),
                    ),
                    const PopupMenuItem(
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
    );
  }

  /// Dialog to add insurance record
  void _showAddInsuranceDialog(
      BuildContext context, InsuranceServicesController controller) {
    final companyController = TextEditingController();
    final policyController = TextEditingController();
    final coverageController = TextEditingController();
    final expiryController = TextEditingController();
    String status = "Pending";

    Get.defaultDialog(
      title: "Add Insurance",
      content: Column(
        children: [
          TextField(
            controller: companyController,
            decoration: const InputDecoration(
              labelText: "Company Name",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: policyController,
            decoration: const InputDecoration(
              labelText: "Policy Number",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: coverageController,
            decoration: const InputDecoration(
              labelText: "Coverage Amount",
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: expiryController,
            decoration: const InputDecoration(
              labelText: "Expiry Date (YYYY-MM-DD)",
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
            items: ["Active", "Expired", "Pending"]
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (value) {
              status = value ?? "Pending";
            },
          ),
        ],
      ),
      textCancel: "Cancel",
      textConfirm: "Add",
      confirmTextColor: Colors.white,
      onConfirm: () {
        if (companyController.text.isNotEmpty &&
            policyController.text.isNotEmpty &&
            coverageController.text.isNotEmpty &&
            expiryController.text.isNotEmpty) {
          controller.addInsurance(
            companyName: companyController.text,
            policyNumber: policyController.text,
            coverage: coverageController.text,
            expiryDate: expiryController.text,
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
