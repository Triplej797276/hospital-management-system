import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

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
      print('Error updating admission: $e');
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

class AdmissionsScreen extends StatelessWidget {
  const AdmissionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdmissionsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Admissions', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF26A69A),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26A69A), Color(0xFF00796B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        elevation: 4,
      ),
      body: Obx(() => controller.admissions.isEmpty
          ? const Center(
              child: Text(
                'No admissions found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : SingleChildScrollView(
              scrollDirection: Axis.horizontal, // Allow horizontal scrolling for wide tables
              child: DataTable(
                columns: const [
                  DataColumn(
                    label: Text(
                      'Patient Name',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Admission Date',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Ward',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
                    ),
                  ),
                  DataColumn(
                    label: Text(
                      'Actions',
                      style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00796B)),
                    ),
                  ),
                ],
                rows: controller.admissions.map((admission) {
                  return DataRow(
                    cells: [
                      DataCell(Text(admission.patientName, style: const TextStyle(fontSize: 16))),
                      DataCell(Text(
                          DateFormat('yyyy-MM-dd').format(admission.admissionDate),
                          style: const TextStyle(fontSize: 16))),
                      DataCell(Text(admission.ward, style: const TextStyle(fontSize: 16))),
                      DataCell(
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => _showEditDialog(context, controller, admission),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.deleteAdmission(admission.id),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }).toList(),
                dataRowHeight: 60, // Adjust row height for better readability
                headingRowHeight: 50,
                columnSpacing: 20, // Adjust spacing between columns
                dividerThickness: 1, // Add divider lines between rows
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(color: Colors.grey[300]!),
                    bottom: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
            )),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF26A69A),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () => _showAddDialog(context, controller),
      ),
    );
  }

  // Dialog for adding a new admission
  void _showAddDialog(BuildContext context, AdmissionsController controller) {
    final patientNameController = TextEditingController();
    final wardController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Admission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: patientNameController,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            TextField(
              controller: wardController,
              decoration: const InputDecoration(labelText: 'Ward'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (patientNameController.text.isNotEmpty && wardController.text.isNotEmpty) {
                controller.createAdmission(
                  Admission(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    patientName: patientNameController.text,
                    admissionDate: DateTime.now(),
                    ward: wardController.text,
                  ),
                );
                Navigator.pop(context);
              } else {
                Get.snackbar('Error', 'Please fill all fields');
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Dialog for editing an existing admission
  void _showEditDialog(BuildContext context, AdmissionsController controller, Admission admission) {
    final patientNameController = TextEditingController(text: admission.patientName);
    final wardController = TextEditingController(text: admission.ward);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Admission'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: patientNameController,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            TextField(
              controller: wardController,
              decoration: const InputDecoration(labelText: 'Ward'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (patientNameController.text.isNotEmpty && wardController.text.isNotEmpty) {
                controller.updateAdmission(
                  admission.id,
                  Admission(
                    id: admission.id,
                    patientName: patientNameController.text,
                    admissionDate: admission.admissionDate,
                    ward: wardController.text,
                  ),
                );
                Navigator.pop(context);
              } else {
                Get.snackbar('Error', 'Please fill all fields');
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(GetMaterialApp(
    title: 'Admissions App',
    theme: ThemeData(
      primarySwatch: Colors.teal,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const AdmissionsScreen(),
  ));
}