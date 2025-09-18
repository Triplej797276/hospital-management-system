import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var isLoading = true.obs;
  var doctor = Rx<Doctor?>(null);

  @override
  void onInit() {
    super.onInit();
    fetchDoctor();
  }

  void fetchDoctor() async {
    try {
      isLoading.value = true;
      final user = _auth.currentUser;
      if (user != null) {
        final doc = await _firestore.collection('doctors').doc(user.uid).get();
        if (doc.exists) {
          doctor.value = Doctor.fromMap(doc.data()!);
        }
      }
    } finally {
      isLoading.value = false;
    }
  }
}

class Doctor {
  final String? name;
  final String? email;
  final String? phone;
  final String? specialization;

  Doctor({this.name, this.email, this.phone, this.specialization});

  factory Doctor.fromMap(Map<String, dynamic> map) {
    return Doctor(
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      specialization: map['specialization'],
    );
  }
}
