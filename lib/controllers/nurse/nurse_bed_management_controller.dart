import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class Bed {
  final String id;
  final String bedNumber;
  final String status;
  final String patient;
  final String bedType;
  final String ward;
  final Timestamp? lastCleaned;

  Bed({
    required this.id,
    required this.bedNumber,
    required this.status,
    required this.patient,
    required this.bedType,
    required this.ward,
    this.lastCleaned,
  });

  factory Bed.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Bed(
      id: doc.id,
      bedNumber: data['bedNumber'] ?? '',
      status: data['status'] ?? 'Available',
      patient: data['patient'] ?? 'None',
      bedType: data['bedType'] ?? 'General',
      ward: data['ward'] ?? 'General Ward',
      lastCleaned: data['lastCleaned'],
    );
  }

  get cleaningStatus => null;

  get equipment => null;

  get priorityLevel => null;

  Map<String, dynamic> toFirestore() {
    return {
      'bedNumber': bedNumber,
      'status': status,
      'patient': patient,
      'bedType': bedType,
      'ward': ward,
      'lastCleaned': lastCleaned ?? FieldValue.serverTimestamp(),
    };
  }
}

class NurseBedManagementController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Bed> beds = <Bed>[].obs;

  @override
  void onInit() {
    super.onInit();
    _fetchBeds();
  }

  void _fetchBeds() {
    _firestore.collection('beds').snapshots().listen((snapshot) {
      beds.value = snapshot.docs.map((doc) => Bed.fromFirestore(doc)).toList();
    });
  }

  Future<void> addBed(String bedNumber, String bedType, String ward) async {
    try {
      await _firestore.collection('beds').add({
        'bedNumber': bedNumber,
        'status': 'Available',
        'patient': 'None',
        'bedType': bedType,
        'ward': ward,
        'lastCleaned': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Bed added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0077B6),
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to add bed: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> updateBed(Bed bed) async {
    try {
      await _firestore.collection('beds').doc(bed.id).update(bed.toFirestore());
      Get.snackbar('Success', 'Bed updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0077B6),
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update bed: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> deleteBed(String id) async {
    try {
      await _firestore.collection('beds').doc(id).delete();
      Get.snackbar('Success', 'Bed deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0077B6),
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete bed: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> markBedAsCleaned(String id) async {
    try {
      await _firestore.collection('beds').doc(id).update({
        'lastCleaned': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Bed marked as cleaned',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF0077B6),
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to mark bed as cleaned: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}