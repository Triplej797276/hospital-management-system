import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CaseManagerDashboardScreen extends StatelessWidget {
  const CaseManagerDashboardScreen({super.key});

  // Simulate fetching notices (replace with actual Firebase logic)
  List<String> getLatestNotices() {
    return [
      'Notice: Hospital system maintenance scheduled for 01/09/2025.',
      'Notice: New patient admission protocol effective immediately.',
      'Notice: Ambulance training session on 02/09/2025.'
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Case Manager Dashboard',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Get.offAllNamed('/case_manager_login');
              Get.snackbar(
                'Logged Out',
                'You have been logged out successfully.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Text(
                  'Welcome, ${FirebaseAuth.instance.currentUser?.email ?? 'Case Manager'}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),

                // Dashboard Actions
                const Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  children: [
                    _buildActionCard(
                      context,
                      icon: Icons.person_add,
                      title: 'Patient Admissions',
                      color: Colors.blue[700]!,
                      onTap: () {
                        Get.toNamed('/patient_admissions');
                        // Navigate to patient admissions screen
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.medical_services,
                      title: 'Patient Cases',
                      color: Colors.green[700]!,
                      onTap: () {
                        Get.toNamed('/patient_cases');
                        // Navigate to patient cases screen
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.local_hospital,
                      title: 'Ambulance Management',
                      color: Colors.red[700]!,
                      onTap: () {
                        Get.toNamed('/ambulance_management');
                        // Navigate to ambulance management screen
                      },
                    ),
                    _buildActionCard(
                      context,
                      icon: Icons.mail,
                      title: 'Mail Service',
                      color: Colors.purple[700]!,
                      onTap: () {
                        Get.toNamed('/mail_service');
                        // Navigate to mail service screen
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Latest Notices
                const Text(
                  'Latest Notices',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: getLatestNotices().length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.announcement, color: Colors.blue),
                        title: Text(
                          getLatestNotices()[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 40, color: Colors.white),
              const SizedBox(height: 10),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}