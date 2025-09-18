import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/doctors/appointments_controller.dart';

class AppointmentListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentsController());

    Color getStatusColor(String status) {
      switch (status) {
        case 'Completed':
          return Colors.green;
        case 'Cancelled':
          return Colors.red;
        default:
          return Colors.orange;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Appointments'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() {
        if (controller.appointments.isEmpty) {
          return Center(child: Text('No appointments found'));
        }

        // Group appointments by date
        Map<String, List<Map<String, dynamic>>> groupedAppointments = {};
        for (var appt in controller.appointments) {
          final appointmentDate = appt['appointmentDate'] is Timestamp
              ? (appt['appointmentDate'] as Timestamp).toDate()
              : DateTime.tryParse(appt['appointmentDate'].toString()) ?? DateTime.now();
          final dateKey = DateFormat('yyyy-MM-dd').format(appointmentDate);

          groupedAppointments.putIfAbsent(dateKey, () => []).add(appt);
        }

        final sortedDates = groupedAppointments.keys.toList()..sort();

        return ListView.builder(
          padding: EdgeInsets.all(12),
          itemCount: sortedDates.length,
          itemBuilder: (context, index) {
            final date = sortedDates[index];
            final appts = groupedAppointments[date]!;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 3,
              child: ExpansionTile(
                title: Text(
                  DateFormat('EEEE, MMM d, yyyy')
                      .format(DateTime.parse(date)),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                children: appts.map((appt) {
                  final appointmentDate = appt['appointmentDate'] is Timestamp
                      ? (appt['appointmentDate'] as Timestamp).toDate()
                      : DateTime.tryParse(appt['appointmentDate'].toString()) ?? DateTime.now();
                  final createdAt = appt['createdAt'] is Timestamp
                      ? (appt['createdAt'] as Timestamp).toDate()
                      : null;

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Patient: ${appt['patientName'] ?? ''}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 2),
                        Text("Email: ${appt['email'] ?? ''}"),
                        Text("Phone: ${appt['phoneNumber'] ?? ''}"),
                        Text("Department: ${appt['department'] ?? ''}"),
                        Text(
                            "Appointment: ${DateFormat('hh:mm a, MMM d').format(appointmentDate)}"),
                        if (createdAt != null)
                          Text(
                              "Created At: ${DateFormat('hh:mm a, MMM d').format(createdAt)}"),
                        if (appt['notes'] != null)
                          Text("Notes: ${appt['notes']}"),
                        SizedBox(height: 4),
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color:
                                getStatusColor(appt['status'] ?? 'Pending'),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            appt['status'] ?? 'Pending',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        Divider(),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      }),
    );
  }
}
