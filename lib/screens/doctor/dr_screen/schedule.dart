import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Schedule {
  String id;
  DateTime startTime;
  DateTime endTime;
  String description;

  Schedule({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.description,
  });
}

class SchedulesController extends GetxController {
  RxList<Schedule> schedules = RxList<Schedule>([]);

  @override
  void onInit() {
    super.onInit();
    fetchSchedules();
  }

  void fetchSchedules() {
    // Mock data
    schedules.addAll([
      Schedule(
        id: '1',
        startTime: DateTime.now(),
        endTime: DateTime.now().add(Duration(hours: 8)),
        description: 'Duty Shift',
      ),
    ]);
  }

  void setSchedule(Schedule newSchedule) {
    schedules.add(newSchedule);
  }
}

class SchedulesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SchedulesController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Schedules'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => ListView.builder(
        itemCount: controller.schedules.length,
        itemBuilder: (context, index) {
          final sched = controller.schedules[index];
          return ListTile(
            title: Text(sched.description),
            subtitle: Text('${sched.startTime} to ${sched.endTime}'),
          );
        },
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => controller.setSchedule(Schedule(
          id: '${controller.schedules.length + 1}',
          startTime: DateTime.now(),
          endTime: DateTime.now().add(Duration(hours: 4)),
          description: 'New Shift',
        )),
      ),
    );
  }
}