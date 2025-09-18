import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AmbulanceManagementController extends GetxController {
  // Observable lists for patients and ambulances
  var patients = <Map<String, dynamic>>[].obs;
  var ambulances = <Map<String, dynamic>>[].obs;

  final CollectionReference patientsCollection =
      FirebaseFirestore.instance.collection('patients');
  final CollectionReference ambulancesCollection =
      FirebaseFirestore.instance.collection('ambulances');

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
    fetchAmbulances();
  }

  // Fetch patients from Firestore
  void fetchPatients() {
    patientsCollection.snapshots().listen(
      (snapshot) {
        patients.value = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
      },
      onError: (e) {
        Get.snackbar('Error', 'Failed to fetch patients: $e',
            backgroundColor: Colors.red, colorText: Colors.white);
      },
    );
  }

  // Fetch ambulances from Firestore
  void fetchAmbulances() {
    ambulancesCollection.snapshots().listen(
      (snapshot) {
        ambulances.value = snapshot.docs.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          data['id'] = doc.id;
          return data;
        }).toList();
      },
      onError: (e) {
        Get.snackbar('Error', 'Failed to fetch ambulances: $e',
            backgroundColor: Colors.red, colorText: Colors.white);
      },
    );
  }

  // Add a new patient to Firestore
  Future<void> addPatient(String name, String condition, String location) async {
    try {
      await patientsCollection.add({
        'name': name,
        'condition': condition,
        'location': location,
        'assignedAmbulance': null,
        'timestamp': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Patient added successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add patient: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Add a new ambulance to Firestore
  Future<void> addAmbulance(String vehicleNumber, String type) async {
    try {
      await ambulancesCollection.add({
        'vehicleNumber': vehicleNumber,
        'type': type,
        'status': 'Available',
        'timestamp': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Ambulance added successfully',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add ambulance: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  // Assign an ambulance to a patient
  Future<void> assignAmbulance(String patientId, String ambulanceId) async {
    try {
      // Update patient with assigned ambulance
      await patientsCollection.doc(patientId).update({'assignedAmbulance': ambulanceId});
      // Update ambulance status
      await ambulancesCollection.doc(ambulanceId).update({'status': 'Assigned'});
      Get.snackbar('Success', 'Ambulance assigned to patient',
          backgroundColor: Colors.green, colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to assign ambulance: $e',
          backgroundColor: Colors.red, colorText: Colors.white);
    }
  }
}