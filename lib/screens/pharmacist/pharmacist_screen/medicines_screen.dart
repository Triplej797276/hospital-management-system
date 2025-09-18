import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/auth_controller.dart';
import 'package:hsmproject/controllers/pharmacist/medicines_controller.dart';
import 'package:collection/collection.dart';

class MedicinesScreen extends StatelessWidget {
  const MedicinesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final MedicinesController controller = Get.put(MedicinesController());

    final RxBool showForm = false.obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicines'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Toggle Add Medicine form
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => showForm.value = !showForm.value,
                icon: Obx(() => Icon(showForm.value ? Icons.close : Icons.add)),
                label: Obx(() => Text(showForm.value ? "Close Form" : "Add Medicine")),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[800],
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Medicine Form
            Obx(() => showForm.value
                ? Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: [
                          _buildTextField(controller.nameController, 'Name'),
                          _buildTextField(controller.priceController, 'Price', isNumber: true),
                          _buildTextField(controller.stockController, 'Stock', isNumber: true),
                          _buildTextField(controller.descriptionController, 'Description'),
                          _buildTextField(controller.sideEffectsController, 'Side Effects'),

                          // Category dropdown in form
                          Obx(() => DropdownButton<String>(
                                value: controller.selectedCategoryId.value.isEmpty
                                    ? null
                                    : controller.selectedCategoryId.value,
                                hint: const Text("Select Category"),
                                items: controller.categories.map((cat) {
                                  return DropdownMenuItem<String>(
                                    value: cat['id'],
                                    child: Text(cat['name']),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  controller.selectedCategoryId.value = value ?? "";
                                },
                              )),

                          SizedBox(
                            width: 150,
                            child: ElevatedButton(
                              onPressed: () {
                                controller.addMedicine();
                                showForm.value = false; // close form automatically
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue[800],
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('Add'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox.shrink()),

            const SizedBox(height: 20),

            // Medicines Table
            Expanded(
              child: Obx(() {
                if (controller.medicines.isEmpty) {
                  return const Center(child: Text('No medicines added yet.'));
                }
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Name')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Price')),
                      DataColumn(label: Text('Stock')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Side Effects')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: controller.medicines.map((medicine) {
                      final categoryName = controller.categories
                              .firstWhereOrNull((c) => c['id'] == medicine['categoryId'])?['name'] ??
                          'Unknown';
                      final index = controller.medicines.indexOf(medicine);
                      return DataRow(cells: [
                        DataCell(Text(medicine['name'])),
                        DataCell(Text(categoryName)),
                        DataCell(Text(medicine['price'].toString())),
                        DataCell(Text(medicine['stock'].toString())),
                        DataCell(Text(medicine['description'] ?? '')),
                        DataCell(Text(medicine['sideEffects'] ?? '')),
                        DataCell(Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => controller.showEditDialog(medicine, index),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.deleteMedicine(medicine['id'], index),
                            ),
                          ],
                        )),
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

  Widget _buildTextField(TextEditingController controller, String hint,
      {bool isNumber = false}) {
    return SizedBox(
      width: 150,
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          border: const OutlineInputBorder(),
          contentPadding: const EdgeInsets.symmetric(horizontal: 12),
        ),
      ),
    );
  }
}
