import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DoctorScheduleListScreen extends StatelessWidget {
  const DoctorScheduleListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Schedules')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('doctor_schedules').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return const Center(child: Text('Error loading schedules'));
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          final schedules = snapshot.data!.docs;
          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return ListTile(
                title: Text('Doctor ID: ${schedule['doctorId'] ?? 'Unknown'}'),
                subtitle: Text('Day: ${schedule['day'] ?? 'N/A'} | Time Slots: ${schedule['timeSlots']?.join(', ') ?? 'N/A'}'),
              );
            },
          );
        },
      ),
    );
  }
}