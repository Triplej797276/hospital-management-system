import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MedicineCategoriesController extends GetxController {
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final TextEditingController categoryController = TextEditingController();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  @override
  void onClose() {
    categoryController.dispose();
    super.onClose();
  }

  // Fetch categories
  Future<void> fetchCategories() async {
    try {
      final snapshot = await firestore.collection('medicine_categories').get();
      categories.value = snapshot.docs.map((doc) => {
        'id': doc.id,
        'name': doc['name'],
      }).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch categories: $e');
    }
  }

  // Add new category
  Future<void> addCategory() async {
    final name = categoryController.text.trim();
    if (name.isEmpty) return;

    try {
      final docRef = await firestore.collection('medicine_categories').add({'name': name});
      categories.add({'id': docRef.id, 'name': name});
      categoryController.clear();
      Get.snackbar('Success', 'Category added');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add category: $e');
    }
  }

  // Edit category
  Future<void> editCategory(int index, String docId) async {
    final newName = categoryController.text.trim();
    if (newName.isEmpty) return;

    try {
      await firestore.collection('medicine_categories').doc(docId).update({'name': newName});
      categories[index] = {'id': docId, 'name': newName};
      categoryController.clear();
      Get.back();
      Get.snackbar('Success', 'Category updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update category: $e');
    }
  }

  // Delete category
  Future<void> deleteCategory(int index, String docId) async {
    try {
      await firestore.collection('medicine_categories').doc(docId).delete();
      categories.removeAt(index);
      Get.snackbar('Deleted', 'Category removed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete category: $e');
    }
  }
}
