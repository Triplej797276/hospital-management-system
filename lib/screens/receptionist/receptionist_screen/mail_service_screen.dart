import 'package:flutter/material.dart';

class MailServiceScreen extends StatelessWidget {
  const MailServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mail Service'),
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
          'Mail Service Screen',
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