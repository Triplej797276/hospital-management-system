import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

// ------------------ Prescription Model ------------------
class Prescription {
  String id;
  String patientName;
  List<String> medications;
  String dosageInstructions;
  DateTime date;

  Prescription({
    required this.id,
    required this.patientName,
    required this.medications,
    required this.dosageInstructions,
    required this.date,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'medications': medications,
      'dosageInstructions': dosageInstructions,
      'date': Timestamp.fromDate(date),
    };
  }

  factory Prescription.fromMap(Map<String, dynamic> map) {
    return Prescription(
      id: map['id']?.toString() ?? '',
      patientName: map['patientName']?.toString() ?? 'Unknown',
      medications: List<String>.from(map['medications'] ?? []),
      dosageInstructions: map['dosageInstructions']?.toString() ?? '',
      date: (map['date'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

// ------------------ Controller ------------------
class PrescriptionsController extends GetxController {
  RxList<Prescription> prescriptions = RxList<Prescription>([]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController medicationsController = TextEditingController();
  final TextEditingController dosageController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  RxString editingId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _firestore.collection('prescriptions').snapshots().listen((snapshot) {
      prescriptions.assignAll(
        snapshot.docs.map((doc) {
          try {
            return Prescription.fromMap(doc.data());
          } catch (e) {
            Get.snackbar('Error', 'Failed to parse prescription ${doc.id}');
            return null;
          }
        }).whereType<Prescription>().toList()
          ..sort((a, b) => b.date.compareTo(a.date)),
      );
    }, onError: (e) {
      Get.snackbar('Error', 'Failed to fetch prescriptions: $e');
    });
  }

  Future<void> createPrescription() async {
    if (patientNameController.text.isEmpty ||
        medicationsController.text.isEmpty ||
        dosageController.text.isEmpty ||
        dateController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill all fields');
      return;
    }

    DateTime? parsedDate;
    try {
      parsedDate = DateFormat('yyyy-MM-dd').parse(dateController.text);
    } catch (e) {
      Get.snackbar('Error', 'Invalid date format');
      return;
    }

    final newPrescription = Prescription(
      id: editingId.value.isEmpty
          ? DateTime.now().millisecondsSinceEpoch.toString()
          : editingId.value,
      patientName: patientNameController.text,
      medications: medicationsController.text.split(',').map((e) => e.trim()).toList(),
      dosageInstructions: dosageController.text,
      date: parsedDate,
    );

    try {
      await _firestore.collection('prescriptions').doc(newPrescription.id).set(newPrescription.toMap());
      clearForm();
      Get.back();
      Get.snackbar('Success', editingId.value.isEmpty ? 'Prescription added' : 'Prescription updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to save prescription: $e');
    }
  }

  Future<void> deletePrescription(String id) async {
    try {
      await _firestore.collection('prescriptions').doc(id).delete();
      Get.snackbar('Success', 'Prescription deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete prescription: $e');
    }
  }

  void editPrescription(Prescription rx) {
    editingId.value = rx.id;
    patientNameController.text = rx.patientName;
    medicationsController.text = rx.medications.join(', ');
    dosageController.text = rx.dosageInstructions;
    dateController.text = DateFormat('yyyy-MM-dd').format(rx.date);
    Get.toNamed('/prescription_form');
  }

  void clearForm() {
    patientNameController.clear();
    medicationsController.clear();
    dosageController.clear();
    dateController.clear();
    editingId.value = '';
  }
}
