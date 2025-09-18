import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/doctors/dashboard_controller.dart';
import 'package:hsmproject/controllers/auth_controller.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> menuItems = const [
    {'title': 'Appointments', 'route': '/appointment', 'icon': Icons.calendar_today},
    {'title': 'Patient Admissions', 'route': '/admission', 'icon': Icons.person_add}, 
    {'title': 'Bed Management', 'route': '/bed', 'icon': Icons.bed},
    {'title': 'Prescriptions', 'route': '/prescription', 'icon': Icons.description},
    {'title': 'Reports', 'route': '/report', 'icon': Icons.bar_chart},
    {'title': 'Payroll Data', 'route': '/payroll', 'icon': Icons.account_balance_wallet},
    {'title': 'Schedules', 'route': '/schedule', 'icon': Icons.schedule},
    {'title': 'Documents', 'route': '/document', 'icon': Icons.document_scanner},
  ];

  // Professional Colors
  final Color primaryColor = const Color(0xFF1E3A8A);
  final Color accentColor = const Color(0xFF2563EB);
  final Color backgroundColor = const Color(0xFFF5F5F5);
  final Color tileGradientStart = Colors.white;
  final Color tileGradientEnd = const Color(0xFFE0E7FF);

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final dashboardController = Get.put(DashboardController());

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white, size: 28),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: const Text(
          'Doctor Dashboard',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: primaryColor,
        actions: [
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
                    'Doctor Menu',
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
                leading: Icon(item['icon'], color: primaryColor),
                title: Text(
                  item['title'],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Roboto',
                    color: Color(0xFF212121),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Get.toNamed(item['route']);
                },
                hoverColor: tileGradientEnd,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              );
            }).toList(),
            ListTile(
              leading: Icon(Icons.person, color: primaryColor),
              title: const Text('Profile', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF212121))),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/profile');
              },
              hoverColor: tileGradientEnd,
            ),
            ListTile(
              leading: Icon(Icons.settings, color: primaryColor),
              title: const Text('Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF212121))),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/settings');
              },
              hoverColor: tileGradientEnd,
            ),
          ],
        ),
        backgroundColor: backgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, tileGradientEnd],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  final doctorName = authController.user.value?.name ?? 'Doctor';
                  return Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [primaryColor, accentColor],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 6,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome, $doctorName!',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Stay updated and manage your tasks efficiently.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: menuItems.map((item) {
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => Get.toNamed(item['route']),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [tileGradientStart, tileGradientEnd],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(item['icon'], size: 32, color: primaryColor),
                              const SizedBox(height: 8),
                              Text(
                                item['title'],
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Color(0xFF212121)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: dashboardController.currentIndex.value,
          onTap: dashboardController.changeTabIndex,
          selectedItemColor: primaryColor,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          backgroundColor: backgroundColor,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Dashboard'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
          ],
        ),
      ),
    );
  }
}

extension on User? {
  get name => null;
}
