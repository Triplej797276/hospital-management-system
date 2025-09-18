import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/auth_controller.dart';
import 'package:hsmproject/controllers/pharmacist/medicine_categories_controller.dart';

class MedicineCategoriesScreen extends StatelessWidget {
  const MedicineCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final MedicineCategoriesController controller = Get.put(MedicineCategoriesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Categories'),
        backgroundColor: Colors.blue[800],
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => authController.signOut(),
            tooltip: 'Sign Out',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.categoryController,
                    decoration: const InputDecoration(
                      hintText: 'Enter new category',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: controller.addCategory,
                  child: const Text('Add'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[800],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => controller.categories.isEmpty
                    ? const Center(
                        child: Text('No categories added yet.',
                            style: TextStyle(fontSize: 16, color: Colors.grey)),
                      )
                    : ListView.separated(
                        itemCount: controller.categories.length,
                        separatorBuilder: (_, __) => const Divider(),
                        itemBuilder: (context, index) {
                          final category = controller.categories[index];
                          return ListTile(
                            title: Text(category['name'],
                                style: const TextStyle(fontSize: 18)),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.orange),
                                  onPressed: () {
                                    controller.categoryController.text = category['name'];
                                    Get.defaultDialog(
                                      title: 'Edit Category',
                                      content: TextField(
                                        controller: controller.categoryController,
                                        decoration: const InputDecoration(
                                            hintText: 'Category Name'),
                                      ),
                                      textConfirm: 'Save',
                                      textCancel: 'Cancel',
                                      onConfirm: () => controller.editCategory(index, category['id']),
                                      onCancel: () => controller.categoryController.clear(),
                                    );
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () => controller.deleteCategory(index, category['id']),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
