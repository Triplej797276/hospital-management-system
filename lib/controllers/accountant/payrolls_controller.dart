import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

class PayrollsController extends GetxController {
  var payrolls = <Map<String, dynamic>>[].obs;
  var employees = <Map<String, dynamic>>[].obs;
  var selectedEmployee = Rxn<Map<String, dynamic>>();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void onInit() {
    super.onInit();
  }

  /// Fetch employees by role
  Future<void> fetchEmployeesByRole(String role) async {
    String collectionName = role.toLowerCase() + "s"; 
    final snapshot = await _firestore.collection(collectionName).get();

    employees.assignAll(snapshot.docs.map((doc) => {
          "uid": doc.id,
          ...doc.data(),
        }).toList());

    selectedEmployee.value = null;
  }

  /// Fetch all payrolls for a role (Admin/Accountant view)
  Future<void> fetchPayrollsForRole(String role) async {
    String collectionName = role.toLowerCase() + "s";
    final employeeSnapshot = await _firestore.collection(collectionName).get();

    List<Map<String, dynamic>> allPayrolls = [];

    for (var empDoc in employeeSnapshot.docs) {
      final payrollSnapshot = await _firestore
          .collection(collectionName)
          .doc(empDoc.id)
          .collection('payrolls')
          .orderBy('date', descending: true)
          .get();

      for (var doc in payrollSnapshot.docs) {
        allPayrolls.add({
          "id": doc.id,
          "employeeUid": empDoc.id,
          "role": role,
          ...doc.data(),
        });
      }
    }

    payrolls.assignAll(allPayrolls);
  }

  /// Add new payroll as subcollection under employee
  Future<void> addPayroll({
    required String role,
    required String employeeUid,
    required String employeeName,
    required double basic,
    required double allowances,
    required double deductions,
  }) async {
    final currentUser = _auth.currentUser;
    double netSalary = basic + allowances - deductions;

    final payroll = {
      'employeeName': employeeName,
      'role': role,
      'basic': basic,
      'allowances': allowances,
      'deductions': deductions,
      'netSalary': netSalary,
      'month':
          "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}",
      'status': 'unpaid',
      'createdBy': currentUser?.uid ?? 'system',
      'date': Timestamp.now(),
      'paidAt': null,
    };

    final docRef = await _firestore
        .collection(role.toLowerCase() + "s")
        .doc(employeeUid)
        .collection('payrolls')
        .add(payroll);

    payrolls.add({"id": docRef.id, "employeeUid": employeeUid, ...payroll});

    Get.snackbar('Success', 'Payroll added successfully');
  }

  /// Update payroll status
  Future<void> updatePayrollStatus(String role, String employeeUid, String payrollId, String status) async {
    await _firestore
        .collection(role.toLowerCase() + "s")
        .doc(employeeUid)
        .collection('payrolls')
        .doc(payrollId)
        .update({
      'status': status,
      'paidAt': status == 'paid' ? Timestamp.now() : null,
    });

    // Refresh payroll list
    fetchPayrollsForRole(role);
  }

  /// Generate Payslip PDF
  Future<void> generatePayslipPDF(Map<String, dynamic> payroll) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text("Payslip", style: pw.TextStyle(fontSize: 24)),
            pw.SizedBox(height: 20),
            pw.Text("Employee: ${payroll['employeeName']}"),
            pw.Text("Role: ${payroll['role']}"),
            pw.Text("Month: ${payroll['month']}"),
            pw.SizedBox(height: 10),
            pw.Text("Basic: \$${payroll['basic']}"),
            pw.Text("Allowances: \$${payroll['allowances']}"),
            pw.Text("Deductions: \$${payroll['deductions']}"),
            pw.Divider(),
            pw.Text("Net Salary: \$${payroll['netSalary']}",
                style: pw.TextStyle(fontSize: 18)),
            pw.SizedBox(height: 20),
            pw.Text("Status: ${payroll['status']}"),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
