import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class InsuranceServicesController extends GetxController {
  var insurances = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchInsurances();
  }

  void fetchInsurances() {
    FirebaseFirestore.instance.collection('insurances').snapshots().listen((snapshot) {
      insurances.value = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "companyName": doc['companyName'] ?? 'N/A',
          "policyNumber": doc['policyNumber'] ?? 'N/A',
          "coverage": doc['coverage'] ?? 'N/A',
          "expiryDate": doc['expiryDate'] ?? 'N/A',
          "status": doc['status'] ?? 'Pending',
        };
      }).toList();
    });
  }

  Future<void> addInsurance({
    required String companyName,
    required String policyNumber,
    required String coverage,
    required String expiryDate,
    required String status,
  }) async {
    await FirebaseFirestore.instance.collection('insurances').add({
      "companyName": companyName,
      "policyNumber": policyNumber,
      "coverage": coverage,
      "expiryDate": expiryDate,
      "status": status,
    });
  }

  Future<void> updateInsuranceStatus(String id, String newStatus) async {
    await FirebaseFirestore.instance.collection('insurances').doc(id).update({
      "status": newStatus,
    });
  }

  Future<void> deleteInsurance(String id) async {
    await FirebaseFirestore.instance.collection('insurances').doc(id).delete();
  }
}
