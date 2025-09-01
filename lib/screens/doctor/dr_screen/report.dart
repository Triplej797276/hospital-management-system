import 'package:flutter/material.dart';
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

// Reports Screen
class ReportsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ReportsController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Reports'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.reports.length,
            itemBuilder: (context, index) {
              final report = controller.reports[index];
              return ListTile(
                title: Text(report.title),
                subtitle: Text(report.content),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Show edit dialog
                        showDialog(
                          context: context,
                          builder: (context) {
                            final titleController = TextEditingController(text: report.title);
                            final contentController = TextEditingController(text: report.content);
                            return AlertDialog(
                              title: Text('Edit Report'),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: titleController,
                                    decoration: InputDecoration(labelText: 'Title'),
                                  ),
                                  TextField(
                                    controller: contentController,
                                    decoration: InputDecoration(labelText: 'Content'),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.updateReport(
                                      report.id,
                                      titleController.text,
                                      contentController.text,
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text('Save'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deleteReport(report.id),
                    ),
                  ],
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => controller.createReport(
          Report(
            id: '${controller.reports.length + 1}',
            title: 'New Report',
            content: 'Content',
            date: DateTime.now(),
          ),
        ),
      ),
    );
  }
}