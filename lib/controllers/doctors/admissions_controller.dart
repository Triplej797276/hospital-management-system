import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Admission {
  String id;
  String patientName;
  DateTime admissionDate;
  String ward;

  Admission({
    required this.id,
    required this.patientName,
    required this.admissionDate,
    required this.ward,
  });

  // Convert Admission object to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'patientName': patientName,
      'admissionDate': Timestamp.fromDate(admissionDate),
      'ward': ward,
    };
  }

  // Create Admission object from Firestore map
  factory Admission.fromMap(Map<String, dynamic> map, String id) {
    return Admission(
      id: id,
      patientName: map['patientName'] ?? '',
      admissionDate: (map['admissionDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      ward: map['ward'] ?? '',
    );
  }
}

class AdmissionsController extends GetxController {
  RxList<Admission> admissions = RxList<Admission>([]);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchAdmissions();
  }

  // Fetch admissions from Firestore with real-time updates
  void fetchAdmissions() {
    _firestore.collection('patients').snapshots().listen((snapshot) {
      admissions.value = snapshot.docs
          .map((doc) => Admission.fromMap(doc.data(), doc.id))
          .toList();
    }, onError: (e) {
      Get.snackbar('Error', 'Failed to fetch admissions: $e');
      print('Error fetching admissions: $e');
    });
  }

  // Create a new admission in Firestore
  Future<void> createAdmission(Admission newAdmission) async {
    try {
      await _firestore
          .collection('patients')
          .doc(newAdmission.id)
          .set(newAdmission.toMap());
      Get.snackbar('Success', 'Admission created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create admission: $e');
      print('Error creating admission: $e');
    }
  }

  // Update an existing admission in Firestore
  Future<void> updateAdmission(String id, Admission updatedAdmission) async {
    try {
      await _firestore
          .collection('patients')
          .doc(id)
          .update(updatedAdmission.toMap());
      Get.snackbar('Success', 'Admission updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update admission: $e');
    }
  }

  // Delete an admission from Firestore
  Future<void> deleteAdmission(String id) async {
    try {
      await _firestore.collection('patients').doc(id).delete();
      Get.snackbar('Success', 'Admission deleted successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete admission: $e');
      print('Error deleting admission: $e');
    }
  }
}