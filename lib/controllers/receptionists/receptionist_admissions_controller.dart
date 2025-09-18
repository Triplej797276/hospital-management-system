import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ReceptionistAdmissionsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var admissions = <Map<String, dynamic>>[].obs;
  var doctors = <Map<String, dynamic>>[].obs; // ✅ Doctors list
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdmissions();
    fetchDoctors(); // ✅ load doctors when controller initializes
  }

  /// ✅ Fetch all admissions
  Future<void> fetchAdmissions() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('admissions').get();
      admissions.value = snapshot.docs.map((doc) {
        return {"id": doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch admissions: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// ✅ Fetch all doctors
  Future<void> fetchDoctors() async {
    try {
      final snapshot = await _firestore.collection('doctors').get();
      doctors.value = snapshot.docs.map((doc) {
        return {"id": doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch doctors: $e");
    }
  }

  /// ✅ Add admission
  Future<void> addAdmission(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('admissions').add(data);
      await fetchAdmissions();
      Get.snackbar("Success", "Patient admitted successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add admission: $e");
    }
  }

  /// ✅ Delete admission
  Future<void> deleteAdmission(String id) async {
    try {
      await _firestore.collection('admissions').doc(id).delete();
      await fetchAdmissions();
      Get.snackbar("Deleted", "Admission record removed");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete admission: $e");
    }
  }
}
