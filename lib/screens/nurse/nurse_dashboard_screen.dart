import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/auth_controller.dart';

class NurseDashboardScreen extends StatelessWidget {
  const NurseDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nurse Dashboard'),
        backgroundColor: const Color(0xFF0077B6), // Professional blue color
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authController.signOut();
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                color: Color(0xFF0077B6),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text(
                    'Nurse Portal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Welcome, Nurse',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.people, color: Color(0xFF0077B6)),
              title: const Text('All Patients'),
              onTap: () {
                Get.toNamed('/nurse/patientList');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bed, color: Color(0xFF0077B6)),
              title: const Text('Manage Beds'),
              onTap: () {
                Get.toNamed('/nurse/bedManagement');
              },
            ),
            ListTile(
              leading: const Icon(Icons.assignment_turned_in, color: Color(0xFF0077B6)),
              title: const Text('Allocate Beds'),
              onTap: () {
                Get.toNamed('/nurse/bedAllocation');
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart, color: Color(0xFF0077B6)),
              title: const Text('Reports'),
              onTap: () {
                Get.toNamed('/nurse/reports');
              },
            ),
            ListTile(
              leading: const Icon(Icons.account_balance_wallet, color: Color(0xFF0077B6)),
              title: const Text('Payrolls'),
              onTap: () {
                Get.toNamed('/nurse/reports');
              },
            ),
            ListTile(
              leading: const Icon(Icons.announcement, color: Color(0xFF0077B6)),
              title: const Text('Latest Notice'),
              onTap: () {
                Get.toNamed('/nurse/notices');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Nurse!',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A), // Darker blue for contrast
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Assigned Tasks',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  _buildTaskCard(
                    icon: Icons.favorite,
                    title: 'Check Patient Vitals - Room 101',
                    subtitle: 'Due: 10:00 AM',
                  ),
                  _buildTaskCard(
                    icon: Icons.medical_services,
                    title: 'Administer Medication - Room 102',
                    subtitle: 'Due: 11:00 AM',
                  ),
                  _buildTaskCard(
                    icon: Icons.description,
                    title: 'Update Patient Chart - Room 103',
                    subtitle: 'Due: 12:00 PM',
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 2,
                ),
                onPressed: () {
                  Get.toNamed('/patientList');
                },
                child: const Text(
                  'View Patient List',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTaskCard({required IconData icon, required String title, required String subtitle}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: Icon(icon, color: const Color(0xFF0077B6)),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      ),
    );
  }
}