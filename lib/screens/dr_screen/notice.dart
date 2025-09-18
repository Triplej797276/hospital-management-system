import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctors/notices_controller.dart';
class NoticesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NoticesController controller = Get.put(NoticesController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Notices'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.notices.length,
        itemBuilder: (context, index) {
          final notice = controller.notices[index];
          return ListTile(
            title: Text(notice.title),
            subtitle: Text(notice.content),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    // Edit dialog
                    showDialog(
                      context: context,
                      builder: (context) {
                        TextEditingController titleController = TextEditingController(text: notice.title);
                        TextEditingController contentController = TextEditingController(text: notice.content);
                        return AlertDialog(
                          title: Text('Edit Notice'),
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
                                controller.updateNotice(
                                  notice.id,
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
                  onPressed: () => controller.deleteNotice(notice.id),
                ),
              ],
            ),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Add new notice
          controller.addNotice(
            Notice(
              id: '${controller.notices.length + 1}',
              title: 'New Notice',
              content: 'Content',
              date: DateTime.now(),
            ),
          );
        },
      ),
    );
  }
}