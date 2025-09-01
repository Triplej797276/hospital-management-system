import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Payroll Model
class Payroll {
  String id;
  double salary;
  DateTime payDate;
  double deductions;

  Payroll({
    required this.id,
    required this.salary,
    required this.payDate,
    required this.deductions,
  });
}

// Payroll Controller
class PayrollController extends GetxController {
  RxList<Payroll> payrollData = RxList<Payroll>([]);

  @override
  void onInit() {
    super.onInit();
    fetchPayroll();
  }

  void fetchPayroll() {
    // Mock data; doctor accesses their own
    payrollData.addAll([
      Payroll(
        id: '1',
        salary: 5000.0,
        payDate: DateTime.now(),
        deductions: 200.0,
      ),
    ]);
  }
}

// Payroll Screen
class PayrollScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PayrollController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Payroll Data'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.payrollData.length,
            itemBuilder: (context, index) {
              final payroll = controller.payrollData[index];
              return ListTile(
                title: Text('Salary: \$${payroll.salary}'),
                subtitle: Text(
                    'Date: ${payroll.payDate.toString()} | Deductions: \$${payroll.deductions}'),
              );
            },
          )),
    );
  }
}

// Main App
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Payroll App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: PayrollScreen(),
    );
  }
}