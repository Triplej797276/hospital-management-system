import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class DoctorController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  RxList<Map<String, dynamic>> doctors = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDoctors();
  }

  void fetchDoctors() {
    _firestore.collection('doctors').snapshots().listen((snapshot) {
      doctors.value = snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    });
  }

  Future<void> addDoctor(Map<String, dynamic> doctorData) async {
    await _firestore.collection('doctors').add(doctorData);
  }
}
