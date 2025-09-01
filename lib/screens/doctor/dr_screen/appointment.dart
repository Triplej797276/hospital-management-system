import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// Appointment Model
class Appointment {
  String id;
  String patientName;
  DateTime date;
  String status;
  String? notes;

  Appointment({
    required this.id,
    required this.patientName,
    required this.date,
    required this.status,
    this.notes,
  });

  // Convert Appointment to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'date': Timestamp.fromDate(date),
      'status': status,
      'notes': notes,
    };
  }

  // Create Appointment from Firestore document
  factory Appointment.fromMap(Map<String, dynamic> map) {
    return Appointment(
      id: map['id'],
      patientName: map['patientName'],
      date: (map['date'] as Timestamp).toDate(),
      status: map['status'],
      notes: map['notes'],
    );
  }
}

// Appointments Controller
class AppointmentsController extends GetxController {
  RxList<Appointment> appointments = RxList<Appointment>([]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final uuid = Uuid();

  @override
  void onInit() {
    super.onInit();
    // Bind Firestore stream to appointments list
    appointments.bindStream(fetchAppointments());
  }

  // Stream to fetch appointments in real-time
  Stream<List<Appointment>> fetchAppointments() {
    return _firestore.collection('appointments').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Appointment.fromMap(doc.data())).toList();
    });
  }

  // Create new appointment
  Future<void> createAppointment(Appointment newAppt) async {
    try {
      await _firestore.collection('appointments').doc(newAppt.id).set(newAppt.toMap());
      Get.snackbar('Success', 'Appointment created');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create appointment: $e');
    }
  }

  // Update existing appointment
  Future<void> updateAppointment(String id, Appointment updated) async {
    try {
      await _firestore.collection('appointments').doc(id).update(updated.toMap());
      Get.snackbar('Success', 'Appointment updated');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update appointment: $e');
    }
  }

  // Delete appointment
  Future<void> deleteAppointment(String id) async {
    try {
      await _firestore.collection('appointments').doc(id).delete();
      Get.snackbar('Success', 'Appointment deleted');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete appointment: $e');
    }
  }
}

// Appointment Form Dialog
class AppointmentForm extends StatelessWidget {
  final Appointment? appointment;
  final AppointmentsController controller = Get.find();

  AppointmentForm({this.appointment});

  @override
  Widget build(BuildContext context) {
    final patientNameController = TextEditingController(text: appointment?.patientName ?? '');
    final notesController = TextEditingController(text: appointment?.notes ?? '');
    final statusOptions = ['Pending', 'Confirmed', 'Cancelled'];
    RxString selectedStatus = (appointment?.status ?? 'Pending').obs;
    Rx<DateTime> selectedDate = (appointment?.date ?? DateTime.now()).obs;
    RxBool isLoading = false.obs; // Add loading state

    return AlertDialog(
      title: Text(appointment == null ? 'Create Appointment' : 'Edit Appointment'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: patientNameController,
              decoration: InputDecoration(labelText: 'Patient Name'),
              enabled: isLoading.value == false, // Disable input during loading
            ),
            SizedBox(height: 10),
            Obx(() => ListTile(
                  title: Text('Date: ${DateFormat.yMMMd().format(selectedDate.value)}'),
                  trailing: Icon(Icons.calendar_today),
                  onTap: isLoading.value
                      ? null
                      : () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate.value,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 365)),
                          );
                          if (picked != null) selectedDate.value = picked;
                        },
                )),
            SizedBox(height: 10),
            Obx(() => DropdownButtonFormField<String>(
                  value: selectedStatus.value,
                  decoration: InputDecoration(labelText: 'Status'),
                  items: statusOptions
                      .map((status) => DropdownMenuItem(value: status, child: Text(status)))
                      .toList(),
                  onChanged: isLoading.value ? null : (value) => selectedStatus.value = value!,
                )),
            SizedBox(height: 10),
            TextField(
              controller: notesController,
              decoration: InputDecoration(labelText: 'Notes (Optional)'),
              maxLines: 3,
              enabled: isLoading.value == false,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: isLoading.value ? null : () => Get.back(),
          child: Text('Cancel'),
        ),
        Obx(() => TextButton(
              onPressed: isLoading.value
                  ? null
                  : () async {
                      if (patientNameController.text.trim().isEmpty) {
                        Get.snackbar('Error', 'Patient name is required');
                        return;
                      }

                      isLoading.value = true; // Start loading
                      final newAppt = Appointment(
                        id: appointment?.id ?? controller.uuid.v4(),
                        patientName: patientNameController.text.trim(),
                        date: selectedDate.value,
                        status: selectedStatus.value,
                        notes: notesController.text.trim().isEmpty ? null : notesController.text.trim(),
                      );

                      try {
                        if (appointment == null) {
                          await controller.createAppointment(newAppt);
                        } else {
                          await controller.updateAppointment(appointment!.id, newAppt);
                        }
                        Get.back(); // Close dialog on success
                      } catch (e) {
                        Get.snackbar('Error', 'Operation failed: $e');
                      } finally {
                        isLoading.value = false; // Stop loading
                      }
                    },
              child: isLoading.value
                  ? CircularProgressIndicator()
                  : Text(appointment == null ? 'Create' : 'Update'),
            )),
      ],
    );
  }
}
// Appointments Screen
class AppointmentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentsController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => controller.appointments.isEmpty
          ? Center(child: Text('No appointments found'))
          : ListView.builder(
              itemCount: controller.appointments.length,
              itemBuilder: (context, index) {
                final appt = controller.appointments[index];
                return ListTile(
                  title: Text(appt.patientName),
                  subtitle: Text(
                    '${DateFormat.yMMMd().format(appt.date)} • ${appt.status}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Chip(
                        label: Text(appt.status),
                        backgroundColor: appt.status == 'Confirmed'
                            ? Colors.green.withOpacity(0.2)
                            : appt.status == 'Pending'
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.red.withOpacity(0.2),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Get.dialog(AppointmentForm(appointment: appt));
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Get.defaultDialog(
                            title: 'Confirm Delete',
                            middleText: 'Are you sure you want to delete this appointment?',
                            onConfirm: () async {
                              await controller.deleteAppointment(appt.id);
                              Get.back();
                            },
                            onCancel: () => Get.back(),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF26A69A),
        child: Icon(Icons.add),
        onPressed: () => Get.dialog(AppointmentForm()),
      ),
    );
  }
}