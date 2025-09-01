import 'package:flutter/material.dart';

class PatientCasesScreen extends StatelessWidget {
  const PatientCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Cases'),
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
          'Patient Cases Screen',
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