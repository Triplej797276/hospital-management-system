import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class AppointmentManagementController extends GetxController {
  RxList<Map<String, dynamic>> appointments = RxList<Map<String, dynamic>>([]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    appointments.bindStream(fetchAppointments());
  }

  Stream<List<Map<String, dynamic>>> fetchAppointments() {
    return _firestore
        .collection('appointments')
        .orderBy('appointmentDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id;

              // Ensure appointmentDate and createdAt are Timestamp
              if (data['appointmentDate'] == null) {
                data['appointmentDate'] = Timestamp.now();
              }
              if (data['createdAt'] == null) {
                data['createdAt'] = null;
              }
              return data;
            }).toList());
  }
}
