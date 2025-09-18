import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class EmergencyServicesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var emergencies = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEmergencies();
  }

  /// 🔹 Fetch all emergency cases in real-time
  void fetchEmergencies() {
    _firestore.collection('emergency_services').orderBy('time', descending: true).snapshots().listen((snapshot) {
      emergencies.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'patientName': doc['patientName'] ?? '',
          'emergencyType': doc['emergencyType'] ?? '',
          'status': doc['status'] ?? '',
          'time': (doc['time'] as Timestamp?)?.toDate(),
        };
      }).toList();
    });
  }

  /// 🔹 Add new emergency case
  Future<void> addEmergency(String patientName, String emergencyType, String status) async {
    await _firestore.collection('emergency_services').add({
      'patientName': patientName,
      'emergencyType': emergencyType,
      'status': status,
      'time': DateTime.now(),
    });
  }

  /// 🔹 Update status
  Future<void> updateStatus(String id, String newStatus) async {
    await _firestore.collection('emergency_services').doc(id).update({
      'status': newStatus,
    });
  }

  /// 🔹 Delete case
  Future<void> deleteEmergency(String id) async {
    await _firestore.collection('emergency_services').doc(id).delete();
  }
}
