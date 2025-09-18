import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'dart:io';

class AccountantBillsController extends GetxController {
  var bills = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchBills();
  }

  Future<void> fetchBills() async {
    final snapshot = await _firestore.collection('bills').get();
    bills.assignAll(snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> createBill({
    required String patientId,
    required String patientName,
    required String admissionId,
    required DateTime admissionDate,
    required DateTime? dischargeDate,
    required String insuranceDetails,
    required List<Map<String, dynamic>> extraItems,
    required double total,
  }) async {
    final bill = {
      'patientId': patientId,
      'patientName': patientName,
      'admissionId': admissionId,
      'admissionDate': Timestamp.fromDate(admissionDate),
      'dischargeDate': dischargeDate != null ? Timestamp.fromDate(dischargeDate) : null,
      'insuranceDetails': insuranceDetails,
      'extraItems': extraItems,
      'total': total,
      'createdAt': Timestamp.now(),
    };
    await _firestore.collection('bills').add(bill);
    bills.add(bill);
    Get.snackbar('Success', 'Bill created successfully');
  }

  Future<void> exportBillAsPdf(Map<String, dynamic> bill) async {
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Center(
          child: pw.Text(
            'Bill for ${bill['patientName']}\n'
            'Admission ID: ${bill['admissionId']}\n'
            'Total: \$${bill['total']}',
            style: pw.TextStyle(fontSize: 12),
          ),
        ),
      ),
    );
    final file = File('bill_${bill['admissionId']}.pdf');
    await file.writeAsBytes(await pdf.save());
  }
}