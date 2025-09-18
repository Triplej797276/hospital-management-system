import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctors/payroll_controller.dart';
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