import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RequestedAppointmentsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var requestedAppointments = <Map<String, dynamic>>[].obs;
  var doctors = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
    fetchRequestedAppointments();
  }

  /// Fetch all doctors for dropdown
  Future<void> fetchDoctors() async {
    try {
      final snapshot = await _firestore.collection('doctors').get();
      doctors.value = snapshot.docs.map((doc) {
        return {"id": doc.id, "name": doc["name"]};
      }).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch doctors: $e");
    }
  }

  /// Fetch all requested appointments
  Future<void> fetchRequestedAppointments() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore.collection('requestedAppointments').get();
      requestedAppointments.value = snapshot.docs.map((doc) {
        return {"id": doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch requested appointments: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Add requested appointment
  Future<void> addRequestedAppointment(Map<String, dynamic> data) async {
    try {
      await _firestore.collection('requestedAppointments').add(data);
      await fetchRequestedAppointments();
      Get.snackbar("Success", "Requested appointment submitted");
    } catch (e) {
      Get.snackbar("Error", "Failed to submit request: $e");
    }
  }

  /// Update appointment status
  Future<void> updateStatus(String id, String status) async {
    try {
      await _firestore.collection('requestedAppointments').doc(id).update({"status": status});
      await fetchRequestedAppointments();
      Get.snackbar("Updated", "Appointment status updated");
    } catch (e) {
      Get.snackbar("Error", "Failed to update status: $e");
    }
  }
}
