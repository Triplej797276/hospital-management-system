import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AppointmentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var appointments = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;

  final List<String> statusOptions = ['Pending', 'Completed', 'Cancelled'];
  var departments = <String>[].obs; // departments list

  @override
  void onInit() {
    super.onInit();
    fetchAppointments();
    fetchDepartments(); // fetch department collection
  }

  /// Fetch all appointments
  Future<void> fetchAppointments() async {
    try {
      isLoading.value = true;
      final snapshot = await _firestore
          .collection('appointments')
          .orderBy('appointmentDate', descending: true)
          .get();

      appointments.value =
          snapshot.docs.map((doc) => {'id': doc.id, ...doc.data()}).toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to load appointments: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch departments from Firestore
  Future<void> fetchDepartments() async {
    try {
      final snapshot = await _firestore.collection('departments').get();
      departments.value = snapshot.docs
          .map((doc) => doc['name'].toString()) // assuming 'name' field
          .toList();
    } catch (e) {
      Get.snackbar("Error", "Failed to load departments: $e");
    }
  }

  /// Add new appointment
  Future<void> addAppointment({
    required String patientName,
    required String email,
    required String department,
    required String phoneNumber,
    required DateTime appointmentDate,
    required String createdBy,
  }) async {
    if (patientName.isEmpty ||
        email.isEmpty ||
        department.isEmpty ||
        phoneNumber.isEmpty) {
      Get.snackbar("Error", "Please enter all fields");
      return;
    }

    try {
      final docRef = await _firestore.collection('appointments').add({
        'patientName': patientName,
        'email': email,
        'department': department,
        'phoneNumber': phoneNumber,
        'appointmentDate': appointmentDate,
        'status': 'Pending',
        'createdBy': createdBy,
        'createdAt': FieldValue.serverTimestamp(),
      });

      // Add to local list
      appointments.add({
        'id': docRef.id,
        'patientName': patientName,
        'email': email,
        'department': department,
        'phoneNumber': phoneNumber,
        'appointmentDate': appointmentDate,
        'status': 'Pending',
      });

      Get.snackbar("Success", "Appointment added successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add appointment: $e");
    }
  }

  /// Update appointment status
  Future<void> updateStatus(String docId, String status) async {
    try {
      await _firestore.collection('appointments').doc(docId).update({
        'status': status,
      });

      final index = appointments.indexWhere((element) => element['id'] == docId);
      if (index != -1) {
        appointments[index]['status'] = status;
        appointments.refresh();
      }

      Get.snackbar("Success", "Status updated to $status");
    } catch (e) {
      Get.snackbar("Error", "Failed to update status: $e");
    }
  }
}
