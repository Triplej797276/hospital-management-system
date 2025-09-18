import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

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

class AuthController extends GetxController {
  var user = Rxn<Map<String, String>>();

  @override
  void onInit() {
    super.onInit();
    user.value = {
      'email': 'user@example.com',
      'name': 'John Doe',
    };
  }
}

class ProfileController extends GetxController {
  // Add profile-specific logic here if needed
}

class ReportsController extends GetxController {
  RxList<Report> reports = RxList<Report>([]);

  @override
  void onInit() {
    super.onInit();
    fetchReports();
  }

  void fetchReports() {
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

  void updateReport(String id, Report updatedReport) {
    final index = reports.indexWhere((report) => report.id == id);
    if (index != -1) {
      reports[index] = updatedReport;
    }
  }

  void deleteReport(String id) {
    reports.removeWhere((report) => report.id == id);
  }

  Stream<QuerySnapshot<Object?>>? getReportsStream() {}
}