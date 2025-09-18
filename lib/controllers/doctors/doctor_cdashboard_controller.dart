import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:permission_handler/permission_handler.dart';
import '../auth_controller.dart';

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
        Get.snackbar('Success', 'Notification permission granted.', snackPosition: SnackPosition.BOTTOM);
      } else if (status.isDenied) {
        Get.snackbar('Permission Denied', 'Notification permission is required for updates. Please enable it in settings.', snackPosition: SnackPosition.BOTTOM);
      } else if (status.isPermanentlyDenied) {
        Get.snackbar('Permission Denied', 'Notification access denied permanently. Please enable it in app settings.', snackPosition: SnackPosition.BOTTOM, mainButton: TextButton(
          child: Text('Open Settings'),
          onPressed: () => openAppSettings(),
        ));
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
        var doc = querySnapshot.docs.first;
        if (doc.exists && doc.data() != null) {
          Map<String, dynamic>? data = doc.data() as Map<String, dynamic>?;
          latestNotice.value = data?['message'] ?? 'No message available';
        } else {
          latestNotice.value = 'Notice data unavailable';
        }
      } else {
        latestNotice.value = 'No notices available';
      }
    } catch (e) {
      print('Error fetching notices: $e');
      latestNotice.value = 'Error fetching notices: ${e.toString().split('\n').first}'; // Shorten error message
      Get.snackbar('Error', 'Failed to fetch notices. Tap to retry.', snackPosition: SnackPosition.BOTTOM, mainButton: TextButton(
        onPressed: fetchNotices,
        child: Text('Retry'),
      ));
    } finally {
      isLoadingNotices.value = false;
    }
  }

  void fetchDashboardData() {
    // Simulate fetching data (replace with actual Firestore calls if needed)
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

  void manageAppointments() => Get.toNamed('/appointment');
  void manageAdmissions() => Get.toNamed('/admission');
  void manageBeds() => Get.toNamed('/bed');
  void managePrescriptions() => Get.toNamed('/prescription');
  void manageReports() => Get.toNamed('/report');
  void accessPayroll() => Get.toNamed('/payroll');
  void manageSchedules() => Get.toNamed('/schedule');
  void manageDocuments() => Get.toNamed('/document');
  void viewNotices() => Get.toNamed('/notices');
}