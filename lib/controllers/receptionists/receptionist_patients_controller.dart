import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceptionistPatientsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var patients = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPatients();
  }

  /// ✅ Fetch all patients
  Future<void> fetchPatients() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('patients').get();

      patients.value = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          ...doc.data(),
        };
      }).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch patients: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Add a new patient
  Future<void> addPatient(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('patients').add(data);
      fetchPatients();
      Get.snackbar("Success", "Patient added successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add patient: $e");
    }
  }

  /// ✅ Delete a patient
  Future<void> deletePatient(String id) async {
    try {
      await _firestore.collection('patients').doc(id).delete();
      fetchPatients();
      Get.snackbar("Deleted", "Patient removed successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete patient: $e");
    }
  }
}
