import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPayrollsController extends GetxController {
  var payrolls = <Map<String, dynamic>>[].obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final List<String> roles = ['Doctor', 'Nurse', 'Pharmacist', 'Receptionist'];

  @override
  void onInit() {
    super.onInit();
    fetchAllPayrolls();
  }

  /// Fetch all payrolls for all roles
  Future<void> fetchAllPayrolls() async {
    List<Map<String, dynamic>> allPayrolls = [];

    for (String role in roles) {
      String collectionName = role.toLowerCase() + "s";

      final employeeSnapshot = await _firestore.collection(collectionName).get();

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
            "employeeName": empDoc['name'] ?? "Unknown",
            ...doc.data(),
          });
        }
      }
    }

    payrolls.assignAll(allPayrolls);
  }

  /// Update payroll status (paid/unpaid)
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

    fetchAllPayrolls();
  }
}
