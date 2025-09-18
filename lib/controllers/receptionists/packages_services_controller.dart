import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class PackagesServicesController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var packages = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPackages();
  }

  /// 🔹 Fetch all packages in real-time
  void fetchPackages() {
    _firestore.collection('packages').snapshots().listen((snapshot) {
      packages.value = snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          'packageName': doc['packageName'],
          'price': doc['price'],
          'duration': doc['duration'],
          'services': List<String>.from(doc['services']),
        };
      }).toList();
    });
  }

  /// 🔹 Add new package
  Future<void> addPackage(String name, int price, String duration, List<String> services) async {
    await _firestore.collection('packages').add({
      'packageName': name,
      'price': price,
      'duration': duration,
      'services': services,
    });
    Get.snackbar("Success", "Package Added Successfully");
  }

  /// 🔹 Delete package
  Future<void> deletePackage(String id) async {
    await _firestore.collection('packages').doc(id).delete();
    Get.snackbar("Deleted", "Package Removed Successfully");
  }
}
