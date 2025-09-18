import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientAdmissionsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  var patients = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  void fetchPatients() {
    _firestore.collection('patients').snapshots().listen((snapshot) {
      patients.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> addPatient(String name, String admissionDate) async {
    try {
      await _firestore.collection('patients').add({
        'name': name,
        'admissionDate': admissionDate,
        'createdAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar(
        'Success',
        'Patient admitted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to admit patient: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void showPatientDetails(String name, String id) {
    Get.snackbar(
      'Patient Details',
      'Details for $name (ID: $id)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.blue,
      colorText: Colors.white,
    );
  }
}