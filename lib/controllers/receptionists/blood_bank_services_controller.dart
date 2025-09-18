import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BloodInventoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var bloodUnits = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBloodInventory();
  }

  /// 🔹 Fetch blood inventory in real-time
  void fetchBloodInventory() {
    _firestore.collection('blood_inventory').snapshots().listen((snapshot) {
      bloodUnits.value = snapshot.docs.map((doc) {
        return {
          "id": doc.id,
          "bloodGroup": doc['bloodGroup'] ?? 'N/A',
          "unitsAvailable": doc['unitsAvailable'] ?? 0,
          "status": doc['status'] ?? 'Available',
          "donorName": doc['donorName'] ?? '',
        };
      }).toList();
    });
  }

  /// 🔹 Add new blood unit
  Future<void> addBloodUnit(String bloodGroup, int unitsAvailable, String status, {String donorName = ''}) async {
    await _firestore.collection('blood_inventory').add({
      "bloodGroup": bloodGroup,
      "unitsAvailable": unitsAvailable,
      "status": status,
      "donorName": donorName,
    });
  }

  /// 🔹 Update blood unit
  Future<void> updateBloodUnit(String id, int unitsAvailable, String status) async {
    await _firestore.collection('blood_inventory').doc(id).update({
      "unitsAvailable": unitsAvailable,
      "status": status,
    });
  }

  /// 🔹 Delete blood unit
  Future<void> deleteBloodUnit(String id) async {
    await _firestore.collection('blood_inventory').doc(id).delete();
  }
}
