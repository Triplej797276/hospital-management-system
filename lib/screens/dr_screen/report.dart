import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctors/reports_controller.dart';
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