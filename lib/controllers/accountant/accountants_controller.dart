import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountantsController extends GetxController {
  var accountants = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAccountants();
  }

  Future<void> fetchAccountants() async {
    final snapshot = await _firestore.collection('accountants').get();
    accountants.assignAll(snapshot.docs.map((doc) => doc.data()).toList());
  }

  Future<void> createAccountant({
    required String name,
    required String email,
    required String role,
  }) async {
    final accountant = {
      'name': name,
      'email': email,
      'role': role,
      'createdAt': Timestamp.now(),
    };
    await _firestore.collection('accountants').add(accountant);
    accountants.add(accountant);
    Get.snackbar('Success', 'Accountant created successfully');
  }
}