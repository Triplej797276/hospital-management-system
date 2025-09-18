import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PharmacistsServicesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var pharmacists = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPharmacists();
  }

  /// 🔹 Fetch all pharmacists in real-time
  void fetchPharmacists() {
    _firestore.collection('pharmacists').snapshots().listen((snapshot) {
      pharmacists.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'name': doc['name'] ?? 'Unknown',
          'email': doc['email'] ?? '',
          'phone': doc['phone'] ?? '',
          'license': doc['license'] ?? 'N/A',
        };
      }).toList();
    });
  }
}
