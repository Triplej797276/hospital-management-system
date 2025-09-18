import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicinesController extends GetxController {
  // Medicines list (all categories)
  final RxList<Map<String, dynamic>> medicines = <Map<String, dynamic>>[].obs;

  // Categories list
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;

  // Selected category for dropdown in form
  var selectedCategoryId = "".obs;

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController stockController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController sideEffectsController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchCategories().then((_) => fetchAllMedicines());
  }

  @override
  void onClose() {
    nameController.dispose();
    priceController.dispose();
    stockController.dispose();
    descriptionController.dispose();
    sideEffectsController.dispose();
    super.onClose();
  }

  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      final snapshot = await firestore.collection('medicine_categories').get();
      categories.value =
          snapshot.docs.map((doc) => {'id': doc.id, 'name': doc['name']}).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e');
    }
  }

  // Fetch all medicines across all categories
  Future<void> fetchAllMedicines() async {
    medicines.clear();
    for (var cat in categories) {
      final snapshot = await firestore
          .collection('medicine_categories')
          .doc(cat['id'])
          .collection('medicines')
          .get();

      final newMeds = snapshot.docs.map((doc) => {
            'id': doc.id,
            ...doc.data(),
            'categoryId': cat['id'],
          }).toList();

      medicines.addAll(newMeds);
    }
  }

  // Add medicine
  Future<void> addMedicine() async {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();
    final stockText = stockController.text.trim();
    final description = descriptionController.text.trim();
    final sideEffects = sideEffectsController.text.trim();

    if (name.isEmpty ||
        selectedCategoryId.value.isEmpty ||
        priceText.isEmpty ||
        stockText.isEmpty) {
      Get.snackbar('Error', 'All fields are required');
      return;
    }

    try {
      final price = double.tryParse(priceText);
      final stock = int.tryParse(stockText);
      if (price == null || stock == null) {
        Get.snackbar('Error', 'Price must be number & stock must be integer');
        return;
      }

      final docRef = await firestore
          .collection('medicine_categories')
          .doc(selectedCategoryId.value)
          .collection('medicines')
          .add({
        'name': name,
        'price': price,
        'stock': stock,
        'description': description,
        'sideEffects': sideEffects,
      });

      medicines.add({
        'id': docRef.id,
        'name': name,
        'price': price,
        'stock': stock,
        'description': description,
        'sideEffects': sideEffects,
        'categoryId': selectedCategoryId.value,
      });

      clearFields();
      Get.snackbar('Success', 'Medicine added');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add medicine: $e');
    }
  }

  // Edit medicine
  Future<void> editMedicine(String id, int index) async {
    final name = nameController.text.trim();
    final priceText = priceController.text.trim();
    final stockText = stockController.text.trim();
    final description = descriptionController.text.trim();
    final sideEffects = sideEffectsController.text.trim();

    if (name.isEmpty ||
        selectedCategoryId.value.isEmpty ||
        priceText.isEmpty ||
        stockText.isEmpty) return;

    try {
      final price = double.tryParse(priceText);
      final stock = int.tryParse(stockText);
      if (price == null || stock == null) {
        Get.snackbar('Error', 'Price must be number & stock must be integer');
        return;
      }

      await firestore
          .collection('medicine_categories')
          .doc(selectedCategoryId.value)
          .collection('medicines')
          .doc(id)
          .update({
        'name': name,
        'price': price,
        'stock': stock,
        'description': description,
        'sideEffects': sideEffects,
      });

      medicines[index] = {
        'id': id,
        'name': name,
        'price': price,
        'stock': stock,
        'description': description,
        'sideEffects': sideEffects,
        'categoryId': selectedCategoryId.value,
      };

      clearFields();
      Get.back();
      Get.snackbar('Success', 'Medicine updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update medicine: $e');
    }
  }

  // Delete medicine
  Future<void> deleteMedicine(String id, int index) async {
    try {
      final categoryId = medicines[index]['categoryId'];
      await firestore
          .collection('medicine_categories')
          .doc(categoryId)
          .collection('medicines')
          .doc(id)
          .delete();

      medicines.removeAt(index);
      Get.snackbar('Deleted', 'Medicine removed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete medicine: $e');
    }
  }

  // Clear input fields
  void clearFields() {
    nameController.clear();
    priceController.clear();
    stockController.clear();
    descriptionController.clear();
    sideEffectsController.clear();
  }

  // Show edit dialog
  void showEditDialog(Map<String, dynamic> medicine, int index) {
    selectedCategoryId.value = medicine['categoryId'];
    nameController.text = medicine['name'];
    priceController.text = medicine['price'].toString();
    stockController.text = medicine['stock'].toString();
    descriptionController.text = medicine['description'] ?? '';
    sideEffectsController.text = medicine['sideEffects'] ?? '';

    Get.defaultDialog(
      title: 'Edit Medicine',
      content: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: 150,
              child: TextField(controller: nameController, decoration: const InputDecoration(hintText: 'Name', border: OutlineInputBorder())),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 150,
              child: TextField(controller: priceController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Price', border: OutlineInputBorder())),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 150,
              child: TextField(controller: stockController, keyboardType: TextInputType.number, decoration: const InputDecoration(hintText: 'Stock', border: OutlineInputBorder())),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 150,
              child: TextField(controller: descriptionController, decoration: const InputDecoration(hintText: 'Description', border: OutlineInputBorder())),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: 150,
              child: TextField(controller: sideEffectsController, decoration: const InputDecoration(hintText: 'Side Effects', border: OutlineInputBorder())),
            ),
            const SizedBox(height: 8),
            // Category Dropdown in edit dialog
            Obx(() => DropdownButton<String>(
                  value: selectedCategoryId.value,
                  items: categories.map((cat) {
                    return DropdownMenuItem<String>(
                      value: cat['id'],
                      child: Text(cat['name']),
                    );
                  }).toList(),
                  onChanged: (val) {
                    selectedCategoryId.value = val ?? "";
                  },
                )),
          ],
        ),
      ),
      textConfirm: 'Save',
      textCancel: 'Cancel',
      onConfirm: () => editMedicine(medicine['id'], index),
      onCancel: () {
        clearFields();
        Get.back();
      },
    );
  }
}
