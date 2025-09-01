import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Report model
class Report {
  String id;
  String title;
  String content;
  DateTime date;

  Report({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });
}

// AuthController (Placeholder for authentication logic)
class AuthController extends GetxController {
  var user = Rxn<Map<String, String>>(); // Mock user data

  @override
  void onInit() {
    super.onInit();
    // Mock user data
    user.value = {
      'email': 'user@example.com',
      'name': 'John Doe',
    };
  }
}

// ProfileController (Placeholder for profile-specific logic)
class ProfileController extends GetxController {
  // Add profile-specific logic here if needed
}

// ReportsController
class ReportsController extends GetxController {
  RxList<Report> reports = RxList<Report>([]);

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  void fetchReports() {
    // Mock data
    reports.addAll([
      Report(
        id: '1',
        title: 'Monthly Stats',
        content: 'Patients: 100',
        date: DateTime.now(),
      ),
    ]);
  }

  void createReport(Report newReport) {
    reports.add(newReport);
  }

  // Add methods for update and delete if needed
  void updateReport(String id, Report updatedReport) {
    final index = reports.indexWhere((report) => report.id == id);
    if (index != -1) {
      reports[index] = updatedReport;
    }
  }

  void deleteReport(String id) {
    reports.removeWhere((report) => report.id == id);
  }
}

// ProfileScreen
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    final authController = Get.put(AuthController()); // Initialize AuthController

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Email: ${authController.user.value?['email'] ?? ''}'),
                Text('Name: ${authController.user.value?['name'] ?? ''}'),
                ElevatedButton(
                  onPressed: () {
                    // Show update form
                    Get.defaultDialog(
                      title: 'Update Name',
                      content: Text('Implement form here'),
                      // Add form logic here if needed
                    );
                  },
                  child: Text('Edit Profile'),
                ),
              ],
            ),
          )),
    );
  }
}

// Main app for testing the ProfileScreen
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Profile App',
      home: ProfileScreen(),
    );
  }
}