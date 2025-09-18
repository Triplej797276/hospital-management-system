import 'package:get/get.dart';

// Report Model
class Report {
  String id;
  String title;
  String content;
  DateTime date;

  Report({required this.id, required this.title, required this.content, required this.date});
}

// Reports Controller
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
      Report(id: '1', title: 'Monthly Stats', content: 'Patients: 100', date: DateTime.now()),
    ]);
  }

  void createReport(Report newReport) {
    reports.add(newReport);
  }

  void updateReport(String id, String title, String content) {
    final index = reports.indexWhere((report) => report.id == id);
    if (index != -1) {
      reports[index] = Report(
        id: id,
        title: title,
        content: content,
        date: DateTime.now(),
      );
    }
  }

  void deleteReport(String id) {
    reports.removeWhere((report) => report.id == id);
  }
}