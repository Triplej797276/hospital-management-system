import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/screens/notice/notice_screen.dart';
import '../controllers/auth_controller.dart';
import 'dashboard_tile.dart';
import 'doctor/doctor_list_screen.dart';
import 'nurse/nurse_list_screen.dart';
import 'patient/patient_list_screen.dart';
import 'nurse/add_nurse_screen.dart';
import 'receptionist/receptionist_list_screen.dart';
import 'laboratorist/laboratorist_list_screen.dart';
import 'pharmacist/pharmacist_list_screen.dart';
import 'accountant/accountant_list_screen.dart';
import 'department/department_list_screen.dart';
import 'appointment/appointment_list_screen.dart';
import 'doctor_schedule/doctor_schedule_list_screen.dart';
import 'payroll/payroll_list_screen.dart';
import 'bed/bed_list_screen.dart';
import 'bed/bed_allotment_list_screen.dart';
import 'blood_bank/blood_bank_screen.dart';
import 'blood_bank/blood_donor_list_screen.dart';
import 'doctor/add_doctor_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Doctors', 'screen': () => DoctorListScreen(), 'icon': Icons.medical_services},
    {'title': 'Patients', 'screen': () => PatientList(), 'icon': Icons.person},
    {'title': 'Nurses', 'screen': () => NurseListScreen(), 'icon': Icons.local_hospital},
    {'title': 'Receptionists', 'screen': () => ReceptionistListScreen(), 'icon': Icons.support_agent},
    {'title': 'Laboratorists', 'screen': () => LaboratoristListScreen(), 'icon': Icons.science},
    {'title': 'Pharmacists', 'screen': () => PharmacistListScreen(), 'icon': Icons.medication},
    {'title': 'Accountants', 'screen': () => AccountantListScreen(), 'icon': Icons.account_balance},
    {'title': 'Departments', 'screen': () => DepartmentListScreen(), 'icon': Icons.business},
    {'title': 'Appointments', 'screen': () => AppointmentListScreen(), 'icon': Icons.calendar_today},
    {'title': 'Doctor Schedules', 'screen': () => DoctorScheduleListScreen(), 'icon': Icons.schedule},
    {'title': 'Payrolls', 'screen': () => PayrollListScreen(), 'icon': Icons.payment},
    {'title': 'Beds Management', 'screen': () => BedListScreen(), 'icon': Icons.bed},
    {'title': 'Beds Allotments', 'screen': () => BedAllotmentListScreen(), 'icon': Icons.airline_seat_flat},
    {'title': 'Blood Bank', 'screen': () => BloodBankScreen(), 'icon': Icons.bloodtype},
    {'title': 'Blood Donors', 'screen': () => BloodDonorListScreen(), 'icon': Icons.volunteer_activism},
    {'title': 'Notice Board', 'screen': () => NoticeScreen(), 'icon': Icons.announcement}, // Added Notice Board
  ];

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Hospital Admin Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)], // Teal gradient
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Text(
                'Admin: ${authController.user.value?.email ?? 'Admin'}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white, size: 28),
            onPressed: () => authController.signOut(),
            tooltip: 'Logout',
          ),
        ],
        elevation: 2,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)], // Matching teal gradient
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Admin Menu',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hospital Management',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            ...menuItems.map((item) {
              return ListTile(
                leading: Icon(item['icon'], color: const Color(0xFF26A69A)), // Teal icons
                title: Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    color: Color(0xFF212121), // Dark text for contrast
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.to(item['screen']);
                },
                hoverColor: const Color(0xFFE0F2F1), // Light teal hover
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              );
            }).toList(),
          ],
        ),
        backgroundColor: const Color(0xFFF5F7FA), // Light gray background
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFEDE7F6)], // Light gray to soft purple gradient
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16.0),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.2,
          children: menuItems.asMap().entries.map((entry) {
            final item = entry.value;
            return AnimatedDashboardTile(
              title: item['title'],
              icon: item['icon'],
              onTap: () => Get.to(item['screen']),
              index: entry.key,
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Custom Animated Dashboard Tile
class AnimatedDashboardTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final int index;

  const AnimatedDashboardTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 500 + (index * 100)),
      curve: Curves.easeOut,
      builder: (context, double value, child) {
        return Transform.scale(
          scale: value,
          child: Opacity(
            opacity: value, // Added fade-in effect
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [const Color(0xFFFFFFFF), const Color(0xFFE0F2F1)], // White to light teal
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1), // Softer shadow
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color(0xFF26A69A), // Teal icon color
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF212121), // Dark text for contrast
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Roboto',
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}