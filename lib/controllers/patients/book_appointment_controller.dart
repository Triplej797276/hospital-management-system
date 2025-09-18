import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookAppointmentController extends GetxController {
  final TextEditingController doctorController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();

  @override
  void onClose() {
    doctorController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.onClose();
  }

  Future<void> bookAppointment() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        await FirebaseFirestore.instance.collection('appointments').add({
          'patientId': user.uid,
          'doctorName': doctorController.text,
          'date': dateController.text,
          'time': timeController.text,
          'createdAt': Timestamp.now(),
        });
        Get.snackbar('Success', 'Appointment booked successfully');
        Get.back(); // Return to PatientDashboardScreen
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to book appointment');
    }
  }
}