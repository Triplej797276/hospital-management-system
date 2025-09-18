import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountsController extends GetxController {
  var accounts = <Map<String, dynamic>>[].obs; // Observable list of accounts
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAccounts();
  }

  /// Fetch all accounts from Firestore
  Future<void> fetchAccounts() async {
    final snapshot = await _firestore.collection('accounts').get();
    accounts.assignAll(snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Store document ID for update/delete
      return data;
    }).toList());
  }

  /// Create a new account
  Future<void> createAccount({
    required String accountName,
    required String accountType,
    required double balance,
  }) async {
    final account = {
      'accountName': accountName,
      'accountType': accountType,
      'balance': balance,
      'createdAt': Timestamp.now(),
    };

    final docRef = await _firestore.collection('accounts').add(account);
    account['id'] = docRef.id;
    accounts.add(account);

    Get.snackbar('Success', 'Account created successfully');
  }

  /// Update an existing account
  Future<void> updateAccount(
      String accountId, String accountName, String accountType, double balance) async {
    final account = {
      'accountName': accountName,
      'accountType': accountType,
      'balance': balance,
      'updatedAt': Timestamp.now(),
    };

    await _firestore.collection('accounts').doc(accountId).update(account);

    // Update locally
    final index = accounts.indexWhere((acc) => acc['id'] == accountId);
    if (index != -1) {
      accounts[index] = {...accounts[index], ...account};
      accounts.refresh(); // Refresh observable list
    }

    Get.snackbar('Success', 'Account updated successfully');
  }

  /// Delete an account
  Future<void> deleteAccount(String accountId) async {
    await _firestore.collection('accounts').doc(accountId).delete();

    // Remove from local list
    accounts.removeWhere((acc) => acc['id'] == accountId);
    Get.snackbar('Success', 'Account deleted successfully');
  }
}
