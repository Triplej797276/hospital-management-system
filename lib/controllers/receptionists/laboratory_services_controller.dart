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
    _firestore.collection('laboratorists').orderBy('createdAt', descending: true).snapshots().listen((snapshot) {
      print("Fetched ${snapshot.docs.length} laboratorists");
      laboratorists.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? 'Unknown',
          'email': doc['email'] ?? '',
          'contact': doc['contact'] ?? '',
          'role': doc['role'] ?? 'N/A',
          'createdAt': doc['createdAt'] != null
              ? (doc['createdAt'] as Timestamp).toDate()
              : null,
        };
      }).toList();
    });
  }
}
