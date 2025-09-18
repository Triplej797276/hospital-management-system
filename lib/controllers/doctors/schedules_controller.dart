import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Schedule {
  String id;
  DateTime startTime;
  DateTime endTime;
  String description;
  String? patientName; // New field for patient name

  Schedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.description,
    this.patientName,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'startTime': Timestamp.fromDate(startTime),
      'endTime': Timestamp.fromDate(endTime),
      'description': description,
      'patientName': patientName, // Include patientName in the map
    };
  }

  factory Schedule.fromMap(Map<String, dynamic> map) {
    return Schedule(
      id: map['id']?.toString() ?? '',
      startTime: (map['startTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      endTime: (map['endTime'] as Timestamp?)?.toDate() ?? DateTime.now(),
      description: map['description']?.toString() ?? 'No description',
      patientName: map['patientName']?.toString(),
    );
  }
}

class SchedulesController extends GetxController {
  RxList<Schedule> schedules = RxList<Schedule>([]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController startTimeController = TextEditingController();
  final TextEditingController endTimeController = TextEditingController();
  final TextEditingController patientNameController = TextEditingController();
  RxString editingId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    _firestore.collection('doctors').snapshots().listen((snapshot) async {
      List<Schedule> tempSchedules = [];
      for (var doc in snapshot.docs) {
        try {
          // Fetch the latest appointment from the 'appointments' subcollection
          var appointmentSnapshot = await _firestore
              .collection('doctors')
              .doc(doc.id)
              .collection('appointments')
              .orderBy('bookingTime', descending: true)
              .limit(1)
              .get();

          String? patientName;
          if (appointmentSnapshot.docs.isNotEmpty) {
            patientName = appointmentSnapshot.docs.first.data()['patientName']?.toString();
          }

          var schedule = Schedule.fromMap({
            ...doc.data(),
            'patientName': patientName, // Add patientName to the map
          });
          tempSchedules.add(schedule);
        } catch (e) {
          print('Error parsing document ${doc.id}: $e');
        }
      }
      schedules.assignAll(
        tempSchedules
            .where((schedule) => schedule.startTime.isAfter(DateTime.now()))
            .toList()
          ..sort((a, b) => a.startTime.compareTo(b.startTime)),
      );
    });
  }

  Future<void> setSchedule() async {
    try {
      if (descriptionController.text.isEmpty) {
        Get.snackbar('Error', 'Description cannot be empty');
        return;
      }
      if (startTimeController.text.isEmpty || endTimeController.text.isEmpty) {
        Get.snackbar('Error', 'Please select start and end times');
        return;
      }

      final newSchedule = Schedule(
        id: editingId.value.isEmpty
            ? DateTime.now().millisecondsSinceEpoch.toString()
            : editingId.value,
        startTime: DateTime.parse(startTimeController.text),
        endTime: DateTime.parse(endTimeController.text),
        description: descriptionController.text,
        patientName: null, // Initialize with null
      );

      if (newSchedule.startTime.isBefore(DateTime.now())) {
        Get.snackbar('Error', 'Cannot schedule in the past');
        return;
      }

      await _firestore
          .collection('doctors')
          .doc(newSchedule.id)
          .set(newSchedule.toMap());

      clearForm();
      Get.back();
      Get.snackbar('Success',
          'Schedule ${editingId.value.isEmpty ? 'added' : 'updated'} successfully');
    } catch (e) {
      Get.snackbar('Error',
          'Failed to ${editingId.value.isEmpty ? 'add' : 'update'} schedule: $e');
    }
  }

  Future<void> deleteSchedule(String id) async {
    try {
      await _firestore.collection('doctors').doc(id).delete();
      Get.snackbar('Success', 'Schedule deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete schedule: $e');
    }
  }

  Future<void> bookAppointment(String scheduleId, String patientName) async {
    try {
      if (patientName.isEmpty) {
        Get.snackbar('Error', 'Patient name cannot be empty');
        return;
      }
      // Add appointment to the subcollection
      await _firestore
          .collection('doctors')
          .doc(scheduleId)
          .collection('appointments')
          .add({
        'patientName': patientName,
        'bookingTime': Timestamp.fromDate(DateTime.now()),
      });

      // Update the main schedule document with the patient name
      await _firestore
          .collection('doctors')
          .doc(scheduleId)
          .update({'patientName': patientName});

      Get.snackbar('Success', 'Appointment booked successfully for $patientName');
    } catch (e) {
      Get.snackbar('Error', 'Failed to book appointment: $e');
    }
  }

  void editSchedule(Schedule schedule) {
    editingId.value = schedule.id;
    descriptionController.text = schedule.description;
    startTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(schedule.startTime);
    endTimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(schedule.endTime);
    Get.toNamed('/schedule_form');
  }

  void clearForm() {
    descriptionController.clear();
    startTimeController.clear();
    endTimeController.clear();
    patientNameController.clear();
    editingId.value = '';
  }
}