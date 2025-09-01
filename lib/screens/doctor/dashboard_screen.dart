import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../controllers/auth_controller.dart'; // Assumed to exist

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  var latestNotice = 'Fetching notices...'.obs;
  var isLoadingNotices = true.obs;
  var appointmentCount = 0.obs;
  var admissionCount = 0.obs;
  var bedCount = 0.obs;
  var prescriptionCount = 0.obs;
  var reportCount = 0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
    fetchNotices();
    requestNotificationPermission();
  }

  Future<void> requestNotificationPermission() async {
    PermissionStatus status = await Permission.notification.status;
    if (!status.isGranted) {
      status = await Permission.notification.request();
      if (status.isGranted) {
        print('Notification permission granted');
      } else {
        Get.snackbar('Permission Denied', 'Notification permission is required to receive notice updates.');
      }
    }
  }

  Future<void> fetchNotices() async {
    isLoadingNotices.value = true;
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('notices')
          .orderBy('timestamp', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var noticeData = querySnapshot.docs.first.data() as Map<String, dynamic>;
        latestNotice.value = noticeData['message'] ?? 'No notice available';
      } else {
        latestNotice.value = 'No notices available';
      }
    } catch (e) {
      print('Error fetching notices: $e');
      latestNotice.value = 'Error fetching notices: $e';
      Get.snackbar('Error', 'Failed to fetch notices: $e');
    } finally {
      isLoadingNotices.value = false;
    }
  }

  void fetchDashboardData() {
    appointmentCount.value = 12;
    admissionCount.value = 5;
    bedCount.value = 8;
    prescriptionCount.value = 20;
    reportCount.value = 15;
  }

  void changeTabIndex(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.toNamed('/dashboard');
        break;
      case 1:
        Get.toNamed('/profile');
        break;
      case 2:
        Get.toNamed('/settings');
        break;
    }
  }

  void manageAppointments() => Get.toNamed('/appointments');
  void manageAdmissions() => Get.toNamed('/admissions');
  void manageBeds() => Get.toNamed('/bed-management');
  void managePrescriptions() => Get.toNamed('/prescriptions');
  void manageReports() => Get.toNamed('/reports');
  void accessPayroll() => Get.toNamed('/payroll');
  void manageSchedules() => Get.toNamed('/schedules');
  void manageDocuments() => Get.toNamed('/documents');
  void viewNotices() => Get.toNamed('/notices');
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> menuItems = const [
    {'title': 'Appointments', 'route': '/appointments', 'icon': Icons.calendar_today},
    {'title': 'Patient Admissions', 'route': '/admissions', 'icon': Icons.person_add},
    {'title': 'Bed Management', 'route': '/bed-management', 'icon': Icons.bed},
    {'title': 'Prescriptions', 'route': '/prescriptions', 'icon': Icons.description},
    {'title': 'Reports', 'route': '/reports', 'icon': Icons.bar_chart},
    {'title': 'Payroll Data', 'route': '/payroll', 'icon': Icons.account_balance_wallet},
    {'title': 'Schedules', 'route': '/schedules', 'icon': Icons.schedule},
    {'title': 'Documents', 'route': '/documents', 'icon': Icons.document_scanner},
  ];

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final dashboardController = Get.put(DashboardController());

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white, size: 28),
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
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Center(
              child: Obx(() => Text(
                    'Doctor: ${authController.user.value?.email ?? 'Doctor'}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  )),
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
                  colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
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
                leading: Icon(item['icon'], color: const Color(0xFF26A69A)),
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
                hoverColor: const Color(0xFFE0F2F1),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              );
            }).toList(),
            ListTile(
              leading: const Icon(Icons.person, color: Color(0xFF26A69A)),
              title: const Text(
                'Profile',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  color: Color(0xFF212121),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/profile');
              },
              hoverColor: const Color(0xFFE0F2F1),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Color(0xFF26A69A)),
              title: const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Roboto',
                  color: Color(0xFF212121),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                Get.toNamed('/settings');
              },
              hoverColor: const Color(0xFFE0F2F1),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFF5F7FA),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFF5F7FA), Color(0xFFEDE7F6)],
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
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF26A69A), Color(0xFF4DB6AC)],
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
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Doctor!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Stay updated and manage your tasks efficiently.',
                       style: TextStyle(
          fontSize: 16,
          color: Colors.white70,
          fontFamily: 'Roboto',
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 24),
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.announcement, color: Color(0xFF26A69A)),
                    title: const Text(
                      'Latest Notice',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: 'Roboto',
                        color: Color(0xFF212121),
                      ),
                    ),
                    subtitle: Obx(() => dashboardController.isLoadingNotices.value
                        ? const Center(child: CircularProgressIndicator())
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                dashboardController.latestNotice.value,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontFamily: 'Roboto новые файлы',
                                  color: Color(0xFF616161),
                                ),
                              ),
                              if (dashboardController.latestNotice.value.contains('Error'))
                                TextButton(
                                  onPressed: dashboardController.fetchNotices,
                                  child: const Text('Retry'),
                                ),
                            ],
                          )),
                    onTap: () => dashboardController.viewNotices(),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 24),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 1.2,
                  children: menuItems.asMap().entries.map((entry) {
                    final item = entry.value;
                    return AnimatedDashboardTile(
                      title: item['title'],
                      icon: item['icon'],
                      onTap: () => Get.toNamed(item['route']),
                      index: entry.key,
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
          selectedItemColor: const Color(0xFF26A69A),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          backgroundColor: const Color(0xFFF5F7FA),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings),
              label: 'Settings',
            ),
          ],
        ),
      ),
    );
  }
}

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
            opacity: value,
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFFFFF), Color(0xFFE0F2F1)],
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 40,
                color: const Color(0xFF26A69A),
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF212121),
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