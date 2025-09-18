import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PatientCasesController extends GetxController {
  // Reference to the Firestore collection
  CollectionReference get _patientCases =>
      FirebaseFirestore.instance.collection('patientCases');

  // Reactive variable to track loading state for creating a new case
  final RxBool isCreatingCase = false.obs;

  // Stream for patient cases
  Stream<QuerySnapshot> get patientCasesStream =>
      _patientCases
          .where('status', isEqualTo: 'Active')
          .orderBy('lastUpdated', descending: true)
          .snapshots();

  // Function to create a new patient case
  Future<void> createNewCase() async {
    isCreatingCase.value = true;
    try {
      await _patientCases.add({
        'caseNumber': 'Case ${_generateCaseNumber()}',
        'createdAt': FieldValue.serverTimestamp(),
        'lastUpdated': FieldValue.serverTimestamp(),
        'status': 'Active',
      });
      Get.snackbar(
        'Success',
        'New patient case created successfully!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create new case: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreatingCase.value = false;
    }
  }

  // Helper function to generate a unique case number
  String _generateCaseNumber() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}