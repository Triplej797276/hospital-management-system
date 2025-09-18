import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineBillsController extends GetxController {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List of bills
  final RxList<Map<String, dynamic>> bills = <Map<String, dynamic>>[].obs;

  // List of patients
  final RxList<Map<String, dynamic>> patients = <Map<String, dynamic>>[].obs;

  // List of medicines
  final RxList<Map<String, dynamic>> medicines = <Map<String, dynamic>>[].obs;

  // Selected patient
  var selectedPatientId = "".obs;

  // Selected medicines for the bill
  final RxList<Map<String, dynamic>> selectedMedicines = <Map<String, dynamic>>[].obs;

  // Text controllers
  final TextEditingController quantityController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
    fetchAllMedicines();
    fetchBills();
  }

  @override
  void onClose() {
    quantityController.dispose();
    super.onClose();
  }

  // Fetch all patients
  Future<void> fetchPatients() async {
    try {
      final snapshot = await firestore.collection('patients').get();
      patients.value = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch patients: $e');
    }
  }

  // Fetch all medicines
  Future<void> fetchAllMedicines() async {
    try {
      final categoriesSnapshot = await firestore.collection('medicine_categories').get();
      List<Map<String, dynamic>> allMedicines = [];
      for (var cat in categoriesSnapshot.docs) {
        final medSnapshot = await firestore
            .collection('medicine_categories')
            .doc(cat.id)
            .collection('medicines')
            .get();
        allMedicines.addAll(medSnapshot.docs.map((doc) {
          return {
            'id': doc.id,
            'categoryId': cat.id,
            'categoryName': cat['name'],
            ...doc.data(),
          };
        }));
      }
      medicines.value = allMedicines;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch medicines: $e');
    }
  }

  // Fetch bills
  Future<void> fetchBills() async {
    try {
      final snapshot = await firestore.collection('medicine_bills').get();
      bills.value = snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch bills: $e');
    }
  }

  // Add medicine to selected list
  void addMedicineToBill(Map<String, dynamic> medicine, int quantity) {
    if (quantity <= 0) return;
    final existingIndex =
        selectedMedicines.indexWhere((m) => m['id'] == medicine['id']);
    if (existingIndex >= 0) {
      selectedMedicines[existingIndex]['quantity'] += quantity;
    } else {
      selectedMedicines.add({
        ...medicine,
        'quantity': quantity,
      });
    }
  }

  // Calculate total
  double get totalAmount => selectedMedicines.fold(
      0, (sum, m) => sum + (m['price'] * (m['quantity'] ?? 1)));

  // Save bill
  Future<void> saveBill() async {
    if (selectedPatientId.value.isEmpty || selectedMedicines.isEmpty) {
      Get.snackbar('Error', 'Select patient and medicines');
      return;
    }

    final billData = {
      'patientId': selectedPatientId.value,
      'medicines': selectedMedicines.map((m) {
        return {
          'id': m['id'],
          'name': m['name'],
          'price': m['price'],
          'quantity': m['quantity'],
        };
      }).toList(),
      'totalAmount': totalAmount,
      'date': Timestamp.now(),
    };

    try {
      final docRef = await firestore.collection('medicine_bills').add(billData);
      bills.add({'id': docRef.id, ...billData});
      selectedMedicines.clear();
      selectedPatientId.value = "";
      Get.snackbar('Success', 'Medicine bill added');
    } catch (e) {
      Get.snackbar('Error', 'Failed to add bill: $e');
    }
  }

  // Delete bill
  Future<void> deleteBill(String id, int index) async {
    try {
      await firestore.collection('medicine_bills').doc(id).delete();
      bills.removeAt(index);
      Get.snackbar('Deleted', 'Bill removed');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete bill: $e');
    }
  }
}
