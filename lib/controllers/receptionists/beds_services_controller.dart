import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BedsServicesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var beds = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBeds();
  }

  /// 🔹 Fetch all beds in real-time
  void fetchBeds() {
    _firestore.collection('beds').snapshots().listen((snapshot) {
      beds.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'bedNumber': doc['bedNumber'] ?? '',
          'isOccupied': doc['isOccupied'] ?? false,
          'patientId': doc['patientId'] ?? '',
          'ward': doc['ward'] ?? '',
        };
      }).toList();
    });
  }
}
    