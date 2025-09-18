import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BedAllotmentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var bedAllotments = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchBedAllotments();
  }

  /// 🔹 Fetch all bed allotments and patient name
  void fetchBedAllotments() {
    _firestore.collection('bed_allotments').snapshots().listen((snapshot) async {
      List<Map<String, dynamic>> allotmentsWithPatient = [];

      for (var doc in snapshot.docs) {
        String? patientId = doc['patientId'];

        // Default value
        String patientName = "Unassigned";

        // 🔹 If patientId exists, fetch patient name from admissions collection
        if (patientId != null && patientId.isNotEmpty) {
          try {
            final patientDoc =
                await _firestore.collection('admissions').doc(patientId).get();
            if (patientDoc.exists) {
              patientName = patientDoc['name'] ?? "Unknown";
            }
          } catch (e) {
            patientName = "Error loading";
          }
        }

        allotmentsWithPatient.add({
          'id': doc.id,
          'bedNumber': doc['bedNumber'] ?? 'N/A',
          'ward': doc['ward'] ?? 'N/A',
          'isOccupied': doc['isOccupied'] ?? false,
          'patientId': patientId,
          'patientName': patientName,
        });
      }

      bedAllotments.value = allotmentsWithPatient;
    });
  }
}
