import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/screens/notice/notice_screen.dart';
import 'package:hsmproject/screens/admin/patient_list_screen.dart';
import '../controllers/auth_controller.dart';
import 'admin/doctor_list_screen.dart';
import 'admin/nurse_list_screen.dart';
import 'admin/receptionist_list_screen.dart';
import 'admin/laboratorist_list_screen.dart';
import 'admin/pharmacist_list_screen.dart';
import 'admin/accountant_list_screen.dart';
import 'admin/department_list_screen.dart';
import 'admin/appointment_list_screen.dart';
import 'admin/doctor_schedule_list_screen.dart';
import 'admin/payroll_list_screen.dart';
import 'admin/bed_list_screen.dart';
import 'admin/bed_allotment_list_screen.dart';
import 'admin/blood_bank_screen.dart';
import 'admin/blood_donor_list_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  final List<Map<String, dynamic>> menuItems = [
    {'title': 'Doctors', 'screen': () => DoctorListScreen(), 'icon': Icons.medical_services},
    {'title': 'Patients', 'screen': () => AdmissionListScreen(), 'icon': Icons.person},
    {'title': 'Nurses', 'screen': () => NurseListScreen(), 'icon': Icons.local_hospital},
    {'title': 'Receptionists', 'screen': () => ReceptionistListScreen(), 'icon': Icons.support_agent},
    {'title': 'Laboratorists', 'screen': () => LaboratoristListScreen(), 'icon': Icons.science},
    {'title': 'Pharmacists', 'screen': () => PharmacistListScreen(), 'icon': Icons.medication},
    {'title': 'Accountants', 'screen': () => AccountantListScreen(), 'icon': Icons.account_balance},
    {'title': 'Departments', 'screen': () => DepartmentListScreen(), 'icon': Icons.business},
    {'title': 'Appointments', 'screen': () => AppointmentListScreen(), 'icon': Icons.calendar_today},
    {'title': 'Doctor Schedules', 'screen': () => DoctorScheduleListScreen(), 'icon': Icons.schedule},
    {'title': 'Payrolls', 'screen': () => AdminPayrollListScreen(), 'icon': Icons.payment},
    {'title': 'Beds Management', 'screen': () => BedListScreen(), 'icon': Icons.bed},
    {'title': 'Beds Allotments', 'screen': () => BedAllotmentListScreen(), 'icon': Icons.airline_seat_flat},
    {'title': 'Blood Bank', 'screen': () => BloodBankScreen(), 'icon': Icons.bloodtype},
    {'title': 'Blood Donors', 'screen': () => BloodDonorListScreen(), 'icon': Icons.volunteer_activism},
    {'title': 'Notice Board', 'screen': () => NoticeScreen(), 'icon': Icons.announcement},
  ];

  // New professional color theme
  final Color primaryColor = const Color(0xFF1E3A8A); // Deep Blue
  final Color accentColor = const Color(0xFF2563EB);  // Bright Blue Accent
  final Color backgroundColor = const Color(0xFFF5F5F5); // Light Gray
  final Color tileGradientStart = Colors.white;
  final Color tileGradientEnd = const Color(0xFFE0E7FF); // Soft Blue

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white, size: 28),
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
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [primaryColor, accentColor],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Admin',
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
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [primaryColor, accentColor],
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
                    ),
                  ),
                  const SizedBox(height: 6),
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
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: menuItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'], color: primaryColor),
                    title: Text(
                      item['title'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Get.to(item['screen']);
                    },
                    hoverColor: tileGradientEnd,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: menuItems.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final item = menuItems[index];
            return TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: Duration(milliseconds: 500 + index * 100),
              curve: Curves.easeOut,
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Opacity(opacity: value, child: child),
                );
              },
              child: GestureDetector(
                onTap: () => Get.to(item['screen']),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [tileGradientStart, tileGradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(item['icon'], size: 40, color: primaryColor),
                      const SizedBox(height: 8),
                      Text(
                        item['title'],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: primaryColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
