import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PharmacistController extends GetxController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var user = Rxn<User>();
  var profile = Rx<Map<String, dynamic>>({});

  @override
  void onInit() {
    super.onInit();
    fetchUser();
  }

  void fetchUser() {
    user.value = auth.currentUser;
    if (user.value != null) {
      fetchProfile(user.value!.uid);
    }
  }

  Future<void> fetchProfile(String uid) async {
    try {
      final doc = await firestore.collection('pharmacists').doc(uid).get();
      if (doc.exists) {
        profile.value = doc.data()!;
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load profile: $e');
    }
  }

  void signOut() async {
    await auth.signOut();
  }
}
