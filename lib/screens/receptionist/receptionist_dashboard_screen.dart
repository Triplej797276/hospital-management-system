import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';

class ReceptionistDashboardScreen extends StatelessWidget {
  const ReceptionistDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Colors.blueAccent;
    final backgroundColor = Colors.blue[50];

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Receptionist Dashboard'),
        backgroundColor: primaryColor,
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
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Get.offAllNamed('/login');
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: primaryColor),
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
            _drawerItem(Icons.calendar_today, 'Appointments', '/receptionist/appointments'),
            _drawerItem(Icons.pending_actions, 'Requested Appointments', '/receptionist/requested_appointments'),
            _drawerItem(Icons.people, 'Patients', '/receptionist/patients'),
            _drawerItem(Icons.email, 'Mail Service', '/receptionist/mail_service'),
            _drawerItem(Icons.medical_services, 'Patient Cases', '/receptionist/patient_cases'),
            _drawerItem(Icons.local_hospital, 'Services', '/receptionist/services'),
            _drawerItem(Icons.announcement, 'Notice Board', '/receptionist/notice_board'),
            _drawerItem(Icons.person, 'Profile/Settings', '/receptionist/profile_settings'),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome, Receptionist!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Manage your tasks efficiently',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                  fontFamily: 'Roboto',
                ),
              ),
              const SizedBox(height: 20),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildFunctionalityCard(
                    title: 'Appointments',
                    icon: Icons.calendar_today,
                    color: primaryColor,
                    onPressed: () {
                      Get.toNamed('/receptionist/appointments');
                    },
                  ),
                  _buildFunctionalityCard(
                    title: 'Requested Appointments',
                    icon: Icons.pending_actions,
                    color: primaryColor,
                    onPressed: () {
                      Get.toNamed('/receptionist/requested_appointments');
                    },
                  ),
                  _buildFunctionalityCard(
                    title: 'Patients',
                    icon: Icons.people,
                    color: primaryColor,
                    onPressed: () {
                      Get.toNamed('/receptionist/patients');
                    },
                  ),
                  _buildFunctionalityCard(
                    title: 'Mail Service',
                    icon: Icons.email,
                    color: primaryColor,
                    onPressed: () {
                      Get.toNamed('/receptionist/mail_service');
                    },
                  ),
                  _buildFunctionalityCard(
                    title: 'Patient Cases',
                    icon: Icons.medical_services,
                    color: primaryColor,
                    onPressed: () {
                      Get.toNamed('/receptionist/patient_cases');
                    },
                  ),
                  _buildFunctionalityCard(
                    title: 'Services',
                    icon: Icons.local_hospital,
                    color: primaryColor,
                    onPressed: () {
                      Get.toNamed('/receptionist/services');
                    },
                  ),
                  _buildFunctionalityCard(
                    title: 'Notice Board',
                    icon: Icons.announcement,
                    color: primaryColor,
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

  Widget _buildFunctionalityCard({
    required String title,
    required IconData icon,
    required Color color,
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
            Icon(icon, size: 40, color: color),
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
      ).animate().scale(duration: 200.ms, curve: Curves.easeInOut),
    );
  }

  ListTile _drawerItem(IconData icon, String title, String route) {
    return ListTile(
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(title),
      onTap: () {
        Get.back();
        Get.toNamed(route);
      },
    );
  }
}
