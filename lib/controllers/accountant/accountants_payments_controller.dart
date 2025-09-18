import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountantsPaymentsController extends GetxController {
  var payments = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    final snapshot = await _firestore.collection('payments').get();
    payments.assignAll(snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> recordPayment({
    required String patientId,
    required String patientName,
    required double amount,
    required String accountType,
    required bool isAdvance,
  }) async {
    final payment = {
      'patientId': patientId,
      'patientName': patientName,
      'amount': amount,
      'accountType': accountType,
      'isAdvance': isAdvance,
      'date': Timestamp.now(),
    };
    await _firestore.collection('payments').add(payment);
    payments.add(payment);
    Get.snackbar('Success', 'Payment recorded successfully');
  }
}