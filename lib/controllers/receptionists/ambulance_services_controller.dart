import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

/// Controller to manage Ambulance Services
/// Fetches data from Firestore and provides methods to add, delete, or update ambulances
class AmbulanceServicesController extends GetxController {
  /// Reactive list of ambulances
  var ambulances = <Map<String, dynamic>>[].obs;

  /// Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAmbulances();
  }

  /// Fetches all ambulances in real-time from Firestore
  void fetchAmbulances() {
    _db.collection('ambulances').snapshots().listen((snapshot) {
      ambulances.value = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "status": doc['status'] ?? 'N/A',
          "type": doc['type'] ?? 'N/A',
          "vehicleNumber": doc['vehicleNumber'] ?? 'N/A',
        };
      }).toList();
    }, onError: (error) {
      Get.snackbar("Error", "Failed to fetch ambulances: $error");
    });
  }

  /// Adds a new ambulance to Firestore
  Future<void> addAmbulance({
    required String type,
    required String vehicleNumber,
    required String status,
  }) async {
    try {
      await _db.collection('ambulances').add({
        "type": type,
        "vehicleNumber": vehicleNumber,
        "status": status,
      });
      Get.snackbar("Success", "Ambulance added successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to add ambulance: $e");
    }
  }

  /// Deletes an ambulance from Firestore
  Future<void> deleteAmbulance(String id) async {
    try {
      await _db.collection('ambulances').doc(id).delete();
      Get.snackbar("Deleted", "Ambulance removed successfully");
    } catch (e) {
      Get.snackbar("Error", "Failed to delete ambulance: $e");
    }
  }

  /// Updates ambulance status (e.g. Available → Assigned)
  Future<void> updateAmbulanceStatus(String id, String newStatus) async {
    try {
      await _db.collection('ambulances').doc(id).update({
        "status": newStatus,
      });
      Get.snackbar("Updated", "Status updated to $newStatus");
    } catch (e) {
      Get.snackbar("Error", "Failed to update status: $e");
    }
  }
}
