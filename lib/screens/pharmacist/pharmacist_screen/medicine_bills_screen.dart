import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/pharmacist/medicine_bills_controller.dart';


class MedicineBillsScreen extends StatelessWidget {
  const MedicineBillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(MedicineBillsController());
    final RxBool showForm = false.obs;
    final TextEditingController quantityController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Bills'),
        backgroundColor: Colors.blue[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Toggle Form
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => showForm.value = !showForm.value,
                icon: Obx(() => Icon(showForm.value ? Icons.close : Icons.add)),
                label:
                    Obx(() => Text(showForm.value ? "Close Form" : "Add Bill")),
              ),
            ),

            const SizedBox(height: 16),

            Obx(() => showForm.value
                ? Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Patient Dropdown
                          Obx(() => DropdownButton<String>(
                                value: controller.selectedPatientId.value.isEmpty
                                    ? null
                                    : controller.selectedPatientId.value,
                                hint: const Text("Select Patient"),
                                items: controller.patients.map((p) {
                                  return DropdownMenuItem<String>(
                                    value: p['id'],
                                    child: Text(p['name']),
                                  );
                                }).toList(),
                                onChanged: (value) =>
                                    controller.selectedPatientId.value = value ?? "",
                              )),
                          const SizedBox(height: 16),

                          // Medicine Selection
                          Text('Add Medicine'),
                          ...controller.medicines.map((medicine) {
                            final TextEditingController qtyController =
                                TextEditingController();
                            return Row(
                              children: [
                                Expanded(child: Text(medicine['name'])),
                                SizedBox(
                                  width: 50,
                                  child: TextField(
                                    controller: qtyController,
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        const InputDecoration(hintText: 'Qty'),
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    final qty =
                                        int.tryParse(qtyController.text) ?? 1;
                                    controller.addMedicineToBill(medicine, qty);
                                  },
                                )
                              ],
                            );
                          }).toList(),

                          const SizedBox(height: 16),

                          Obx(() => Text(
                              'Total: ${controller.totalAmount.toStringAsFixed(2)}')),

                          const SizedBox(height: 16),

                          ElevatedButton(
                            onPressed: () => controller.saveBill(),
                            child: const Text('Save Bill'),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink()),

            const SizedBox(height: 16),

            // Display Bills
            Expanded(
              child: Obx(() {
                if (controller.bills.isEmpty) {
                  return const Center(child: Text('No bills yet.'));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Patient')),
                      DataColumn(label: Text('Medicines')),
                      DataColumn(label: Text('Total')),
                      DataColumn(label: Text('Date')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: controller.bills.map((bill) {
                      final index = controller.bills.indexOf(bill);
                      final patientName = controller.patients
                              .firstWhereOrNull(
                                  (p) => p['id'] == bill['patientId'])?['name'] ??
                          'Unknown';
                      final medicinesText = (bill['medicines'] as List)
                          .map((m) => "${m['name']} x${m['quantity']}")
                          .join(', ');

                      return DataRow(cells: [
                        DataCell(Text(patientName)),
                        DataCell(Text(medicinesText)),
                        DataCell(Text(bill['totalAmount'].toString())),
                        DataCell(Text(
                            (bill['date'] as Timestamp).toDate().toString())),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  controller.deleteBill(bill['id'], index),
                            )
                          ],
                        ))
                      ]);
                    }).toList(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
