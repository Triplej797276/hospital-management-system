import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';// Adjust path to your Patient model
import '../../screens/nurse/nurse_dahboard_screen/bed_allocation_screen.dart';
import '../../screens/nurse/nurse_dahboard_screen/bed_management_screen.dart';
import '../doctors/bed_management_controller.dart' hide Bed;
import 'nurse_bed_management_controller.dart';

class BedController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxList<Bed> beds = <Bed>[].obs;
  final RxList<Patient> patients = <Patient>[].obs;
  final RxList<Patient> filteredPatients = <Patient>[].obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedPriorityFilter = 'All'.obs;
  final RxString selectedEquipmentFilter = 'All'.obs;

  @override
  void onInit() {
    super.onInit();
    _fetchBeds();
    _fetchPatients();
    filteredPatients.assignAll(patients);
  }

  void _fetchBeds() {
    _firestore.collection('beds').snapshots().listen((snapshot) {
      beds.value = snapshot.docs.map((doc) => Bed.fromFirestore(doc)).toList();
    });
  }

  void _fetchPatients() {
    _firestore.collection('patients').snapshots().listen((snapshot) {
      patients.value = snapshot.docs.map((doc) => Patient.fromFirestore(doc)).toList();
      filterPatients();
    });
  }

  void filterPatients() {
    var filtered = patients;
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered
          .where((patient) =>
              patient.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList()
          .obs;
    }
    if (selectedPriorityFilter.value != 'All') {
      filtered = filtered
          .where((patient) => patient.priorityLevel == selectedPriorityFilter.value)
          .toList()
          .obs;
    }
    filteredPatients.assignAll(filtered);
  }

  Future<void> assignBed(String bedNumber, String patientName, String patientId) async {
    try {
      final bedDoc = await _firestore
          .collection('beds')
          .where('bedNumber', isEqualTo: bedNumber)
          .get();
      if (bedDoc.docs.isNotEmpty) {
        final bed = Bed.fromFirestore(bedDoc.docs.first);
        if (bed.cleaningStatus != 'Clean' ||
            bed.lastCleaned == null ||
            DateTime.now().difference(bed.lastCleaned!.toDate()).inHours > 24) {
          throw Exception('Bed must be cleaned before allocation');
        }
        await _firestore.collection('beds').doc(bed.id).update({
          'status': 'Occupied',
          'patient': patientName,
          'lastCleaned': FieldValue.serverTimestamp(),
        });
        await _firestore.collection('patients').doc(patientId).update({
          'assignedBed': bedNumber,
        });
      } else {
        throw Exception('Bed not found');
      }
    } catch (e) {
      rethrow;
    }
  }
}