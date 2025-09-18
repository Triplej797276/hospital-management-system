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