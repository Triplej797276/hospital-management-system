import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/patients/book_appointment_controller.dart';

class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize the controller
    final BookAppointmentController controller = Get.put(BookAppointmentController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Book Appointment'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Book a New Appointment',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: controller.doctorController,
              decoration: const InputDecoration(
                labelText: 'Doctor Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.dateController,
              decoration: const InputDecoration(
                labelText: 'Date (YYYY-MM-DD)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.timeController,
              decoration: const InputDecoration(
                labelText: 'Time (HH:MM)',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.bookAppointment,
              child: const Text('Submit Appointment'),
            ),
          ],
        ),
      ),
    );
  }
}