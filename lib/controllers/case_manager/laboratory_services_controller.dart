import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class LaboratoryServicesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var laboratorists = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchLaboratorists();
  }

  /// 🔹 Fetch all laboratorists in real-time
  void fetchLaboratorists() {
    _firestore.collection('laboratorists').snapshots().listen((snapshot) {
      laboratorists.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? 'Unknown',
          'email': doc['email'] ?? '',
          'phone': doc['phone'] ?? '',
          'specialization': doc['specialization'] ?? 'N/A',
        };
      }).toList();
    });
  }
}
