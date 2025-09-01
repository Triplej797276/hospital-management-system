import 'package:flutter/material.dart';

class RequestedAppointmentsScreen extends StatelessWidget {
  const RequestedAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Requested Appointments'),
        backgroundColor: Colors.teal[300],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
      ),
      body: const Center(
        child: Text(
          'Requested Appointments Screen',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.teal,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }
}