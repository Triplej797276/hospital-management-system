import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// Bed model
class Bed {
  final String id; // Firestore document ID
  final String bedNumber;
  String status;
  String patient;
  final String bedType;
  final DateTime? assignedAt;

  Bed({
    required this.id,
    required this.bedNumber,
    required this.status,
    required this.patient,
    required this.bedType,
    this.assignedAt,
  });

  Map<String, dynamic> toMap() => {
        'bedNumber': bedNumber,
        'status': status,
        'patient': patient,
        'bedType': bedType,
        'assignedAt': assignedAt?.toIso8601String(),
      };

  factory Bed.fromMap(Map<String, dynamic> map, String id) => Bed(
        id: id,
        bedNumber: map['bedNumber'] ?? '',
        status: map['status'] ?? 'Available',
        patient: map['patient'] ?? 'None',
        bedType: map['bedType'] ?? 'Non-AC',
        assignedAt: map['assignedAt'] != null ? DateTime.parse(map['assignedAt']) : null,
      );
}

class BedController extends GetxController {
  final CollectionReference bedsRef = FirebaseFirestore.instance.collection('beds');
  final RxList<Bed> beds = <Bed>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Bind beds to Firestore stream for real-time updates
    beds.bindStream(
      bedsRef.snapshots().map(
        (snapshot) => snapshot.docs
            .map((doc) => Bed.fromMap(doc.data() as Map<String, dynamic>, doc.id))
            .toList(),
      ),
    );
  }

  // Add a new bed
  Future<void> addBed({
    required String bedNumber,
    required String bedType,
  }) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate inputs
      if (bedNumber.isEmpty || !['VIP Ward', 'AC', 'Non-AC'].contains(bedType)) {
        throw 'Invalid bed number or type';
      }

      // Check for duplicate bed number
      final existingBed = await bedsRef.where('bedNumber', isEqualTo: bedNumber).get();
      if (existingBed.docs.isNotEmpty) {
        throw 'Bed number already exists';
      }

      // Add bed to Firestore
      final bed = Bed(
        id: '', // Firestore generates ID
        bedNumber: bedNumber,
        status: 'Available',
        patient: 'None',
        bedType: bedType,
        assignedAt: null,
      );
      await bedsRef.add(bed.toMap());
      Get.snackbar(
        'Success',
        'Bed $bedNumber added successfully',
        backgroundColor: const Color(0xFF0077B6),
        colorText: Colors.white,
      );
    } catch (e) {
      errorMessage.value = 'Failed to add bed: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Assign a bed to a patient
  Future<void> assignBed(String bedId, String patient) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Validate inputs
      if (patient.isEmpty) {
        throw 'Patient name is required';
      }

      // Check if bed exists and is available
      final doc = await bedsRef.doc(bedId).get();
      if (!doc.exists || (doc.data() as Map<String, dynamic>)['status'] != 'Available') {
        throw 'Bed is not available';
      }

      // Update bed in Firestore
      await bedsRef.doc(bedId).update({
        'status': 'Occupied',
        'patient': patient,
        'assignedAt': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      errorMessage.value = 'Failed to assign bed: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Unassign a bed
  Future<void> unassignBed(String bedId) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // Check if bed exists and is occupied
      final doc = await bedsRef.doc(bedId).get();
      if (!doc.exists || (doc.data() as Map<String, dynamic>)['status'] != 'Occupied') {
        throw 'Bed is not occupied';
      }

      // Update bed in Firestore
      await bedsRef.doc(bedId).update({
        'status': 'Available',
        'patient': 'None',
        'assignedAt': null,
      });
    } catch (e) {
      errorMessage.value = 'Failed to unassign bed: $e';
      Get.snackbar(
        'Error',
        errorMessage.value,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Get analytics (e.g., available beds count, occupancy rate)
  Map<String, dynamic> getBedAnalytics() {
    final totalBeds = beds.length;
    final availableBeds = beds.where((bed) => bed.status == 'Available').length;
    final occupancyRate = totalBeds > 0 ? ((totalBeds - availableBeds) / totalBeds * 100).toStringAsFixed(1) : '0.0';

    return {
      'totalBeds': totalBeds,
      'availableBeds': availableBeds,
      'occupiedBeds': totalBeds - availableBeds,
      'occupancyRate': occupancyRate,
    };
  }

  // Filter beds by type
  List<Bed> filterBedsByType(String bedType) {
    if (bedType == 'All') return beds.toList();
    return beds.where((bed) => bed.bedType == bedType).toList();
  }
}