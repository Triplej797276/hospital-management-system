import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Bed Model
class Bed {
  String id;
  bool isOccupied;
  String patientId;
  String ward;
  String bedNumber;

  Bed({
    required this.id,
    required this.isOccupied,
    this.patientId = '',
    required this.ward,
    required this.bedNumber,
  });

  factory Bed.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Bed(
      id: doc.id,
      isOccupied: data['isOccupied'] ?? false,
      patientId: data['patientId'] ?? '',
      ward: data['ward'] ?? 'General',
      bedNumber: data['bedNumber'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'isOccupied': isOccupied,
      'patientId': patientId,
      'ward': ward,
      'bedNumber': bedNumber,
    };
  }
}

// Patient Model
class Patient {
  String id;
  String name;

  var medicalNotes;

  var condition;

  Patient({required this.id, required this.name});

  factory Patient.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Patient(
      id: doc.id,
      name: data['name'] ?? 'Unknown',
    );
  }

  get priorityLevel => null;

  get admissionDate => null;

  Object? patientId() => null;

  Map<String, dynamic> toFirestore() {
    return {'name': name};
  }
}

// Bed Management Controller
class BedManagementController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Bed>> fetchBeds() {
    return _firestore.collection('beds').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Bed.fromFirestore(doc)).toList();
    });
  }

  Stream<List<Patient>> fetchPatients() {
    return _firestore.collection('patients').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Patient.fromFirestore(doc)).toList();
    });
  }

  Future<void> addBed(String ward, String bedNumber) async {
    try {
      await _firestore.collection('beds').add({
        'isOccupied': false,
        'patientId': '',
        'ward': ward,
        'bedNumber': bedNumber,
      });
    } catch (e) {
      throw Exception('Failed to add bed: $e');
    }
  }

  Future<void> addPatient(String name) async {
    try {
      await _firestore.collection('patients').add({'name': name});
    } catch (e) {
      throw Exception('Failed to add patient: $e');
    }
  }

  Future<void> assignBed(String bedId, String patientId) async {
    try {
      await _firestore.collection('beds').doc(bedId).update({
        'isOccupied': true,
        'patientId': patientId,
      });
    } catch (e) {
      throw Exception('Failed to assign bed: $e');
    }
  }

  Future<void> unassignBed(String bedId) async {
    try {
      await _firestore.collection('beds').doc(bedId).update({
        'isOccupied': false,
        'patientId': '',
      });
    } catch (e) {
      throw Exception('Failed to unassign bed: $e');
    }
  }
}