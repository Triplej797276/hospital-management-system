import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart'; // For animations

class ReceptionistDashboardScreen extends StatelessWidget {
  const ReceptionistDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Light background for professional look
      appBar: AppBar(
        title: const Text('Receptionist Dashboard'),
        backgroundColor: Colors.teal[300], // Updated to match AppointmentManagementScreen
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              Get.toNamed('/receptionist/profile_settings');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.teal[300], // Updated to match AppointmentManagementScreen
              ),
              child: const Text(
                'Receptionist Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Appointments'),
              onTap: () {
                Get.toNamed('/receptionist/appointments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.pending_actions),
              title: const Text('Requested Appointments'),
              onTap: () {
                Get.toNamed('/receptionist/requested_appointments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.people),
              title: const Text('Patients'),
              onTap: () {
                Get.toNamed('/receptionist/patients');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet),
              title: const Text('Payrolls'),
              onTap: () {
                Get.toNamed('/receptionist/payrolls');
              },
            ),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Mail Service'),
              onTap: () {
                Get.toNamed('/receptionist/mail_service');
              },
            ),
            ListTile(
              leading: const Icon(Icons.medical_services),
              title: const Text('Patient Cases'),
              onTap: () {
                Get.toNamed('/receptionist/patient_cases');
              },
            ),
            ListTile(
              leading: const Icon(Icons.local_hospital),
              title: const Text('Services'),
              onTap: () {
                Get.toNamed('/receptionist/services');
              },
            ),
            ListTile(
              leading: const Icon(Icons.announcement),
              title: const Text('Notice Board'),
              onTap: () {
                Get.toNamed('/receptionist/notice_board');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profile/Settings'),
              onTap: () {
                Get.toNamed('/receptionist/profile_settings');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Welcome, Receptionist!',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[300], // Updated to match AppointmentManagementScreen
                    fontFamily: 'Roboto',
                  ),
                ),
              ),
              const Text(
                'Manage your tasks efficiently',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 20),
              // Grid of Functionality Cards
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2, // Adjust for card size
                children: [
                  _buildFunctionalityCard(
                    context,
                    title: 'Appointments',
                    icon: Icons.calendar_today,
                    onPressed: () {
                      Get.toNamed('/receptionist/appointments');
                    },
                  ),
                  _buildFunctionalityCard(
                    context,
                    title: 'Requested Appointments',
                    icon: Icons.pending_actions,
                    onPressed: () {
                      Get.toNamed('/receptionist/requested_appointments');
                    },
                  ),
                  _buildFunctionalityCard(
                    context,
                    title: 'Patients',
                    icon: Icons.people,
                    onPressed: () {
                      Get.toNamed('/receptionist/patients');
                    },
                  ),
                  _buildFunctionalityCard(
                    context,
                    title: 'Payrolls',
                    icon: Icons.account_balance_wallet,
                    onPressed: () {
                      Get.toNamed('/receptionist/payrolls');
                    },
                  ),
                  _buildFunctionalityCard(
                    context,
                    title: 'Mail Service',
                    icon: Icons.email,
                    onPressed: () {
                      Get.toNamed('/receptionist/mail_service');
                    },
                  ),
                  _buildFunctionalityCard(
                    context,
                    title: 'Patient Cases',
                    icon: Icons.medical_services,
                    onPressed: () {
                      Get.toNamed('/receptionist/patient_cases');
                    },
                  ),
                  _buildFunctionalityCard(
                    context,
                    title: 'Services',
                    icon: Icons.local_hospital,
                    onPressed: () {
                      Get.toNamed('/receptionist/services');
                    },
                  ),
                  _buildFunctionalityCard(
                    context,
                    title: 'Notice Board',
                    icon: Icons.announcement,
                    onPressed: () {
                      Get.toNamed('/receptionist/notice_board');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFunctionalityCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: Colors.teal[300], // Updated to match AppointmentManagementScreen
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey,
                fontFamily: 'Roboto',
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ).animate().scale(duration: 200.ms, curve: Curves.easeInOut); // Subtle tap animation
  }
}