import 'package:get/get.dart';

// Notice Model
class Notice {
  String id;
  String title;
  String content;
  DateTime date;

  Notice({required this.id, required this.title, required this.content, required this.date});
}

// Notices Controller
class NoticesController extends GetxController {
  RxList<Notice> notices = RxList<Notice>([]);

  @override
  void onInit() {
    super.onInit();
    fetchNotices();
  }

  void fetchNotices() {
    // Mock data
    notices.addAll([
      Notice(id: '1', title: 'Policy Update', content: 'New guidelines', date: DateTime.now()),
      Notice(id: '2', title: 'Meeting', content: 'Tomorrow at 10', date: DateTime.now()),
    ]);
  }

  void addNotice(Notice newNotice) {
    notices.add(newNotice);
    notices.refresh();
  }

  void updateNotice(String id, String title, String content) {
    int index = notices.indexWhere((notice) => notice.id == id);
    if (index != -1) {
      notices[index] = Notice(
        id: id,
        title: title,
        content: content,
        date: notices[index].date,
      );
      notices.refresh();
    }
  }

  void deleteNotice(String id) {
    notices.removeWhere((notice) => notice.id == id);
    notices.refresh();
  }
}