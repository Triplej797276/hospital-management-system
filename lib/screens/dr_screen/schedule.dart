import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/doctors/schedules_controller.dart';

class SchedulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SchedulesController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Availability'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() {
        if (controller.schedules.isEmpty) {
          return const Center(child: Text('No schedules available'));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.schedules.length,
          itemBuilder: (context, index) {
            final sched = controller.schedules[index];

            return Card(
              elevation: 3,
              margin: const EdgeInsets.symmetric(vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sched.description,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Start: ${DateFormat('yyyy-MM-dd HH:mm').format(sched.startTime)}',
                    ),
                    Text(
                      'End: ${DateFormat('yyyy-MM-dd HH:mm').format(sched.endTime)}',
                    ),
                    Text(
                      'Patient: ${sched.patientName ?? 'Not Booked'}',
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () => controller.editSchedule(sched),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.deleteSchedule(sched.id),
                        ),
                        IconButton(
                          icon: const Icon(Icons.book, color: Colors.green),
                          onPressed: () => showBookingDialog(
                              context, sched.id, controller),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          controller.clearForm();
          Get.to(() => ScheduleForm());
        },
      ),
    );
  }

  void showBookingDialog(
      BuildContext context, String scheduleId, SchedulesController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Book Appointment'),
        content: TextField(
          controller: controller.patientNameController,
          decoration: const InputDecoration(labelText: 'Patient Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (controller.patientNameController.text.isNotEmpty) {
                controller.bookAppointment(
                    scheduleId, controller.patientNameController.text);
                Navigator.pop(context);
              } else {
                Get.snackbar('Error', 'Please enter patient name');
              }
            },
            child: const Text('Book'),
          ),
        ],
      ),
    );
  }
}

class ScheduleForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<SchedulesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(controller.editingId.value.isEmpty
            ? 'Add Schedule'
            : 'Edit Schedule'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: controller.descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: controller.startTimeController,
              decoration:
                  InputDecoration(labelText: 'Start Time (yyyy-MM-dd HH:mm)'),
              readOnly: true,
              onTap: () async {
                final dateTime = await showDateTimePicker(context);
                if (dateTime != null) {
                  controller.startTimeController.text =
                      DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                }
              },
            ),
            TextField(
              controller: controller.endTimeController,
              decoration:
                  InputDecoration(labelText: 'End Time (yyyy-MM-dd HH:mm)'),
              readOnly: true,
              onTap: () async {
                final dateTime = await showDateTimePicker(context);
                if (dateTime != null) {
                  controller.endTimeController.text =
                      DateFormat('yyyy-MM-dd HH:mm').format(dateTime);
                }
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => controller.setSchedule(),
              child: Text(controller.editingId.value.isEmpty
                  ? 'Add Schedule'
                  : 'Update Schedule'),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime?> showDateTimePicker(BuildContext context) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );
    if (date == null) return null;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time == null) return null;

    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(name: '/', page: () => SchedulesScreen()),
      GetPage(name: '/schedule_form', page: () => ScheduleForm()),
    ],
  ));
}
