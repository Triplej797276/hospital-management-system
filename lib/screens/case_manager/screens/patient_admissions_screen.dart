import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/case_manager/patient_admissions_controller.dart';


class PatientAdmissionsScreen extends StatefulWidget {
  const PatientAdmissionsScreen({super.key});

  @override
  State<PatientAdmissionsScreen> createState() => _PatientAdmissionsScreenState();
}

class _PatientAdmissionsScreenState extends State<PatientAdmissionsScreen> {
  final controller = Get.put(PatientAdmissionsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Admissions',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue[50]!, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Manage Patient Admissions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => AddPatientDialog(),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Admit New Patient',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Recent Admissions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                Obx(() => Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          columns: const [
                            DataColumn(label: Text('Patient Name')),
                            DataColumn(label: Text('Admission Date')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: controller.patients.map((patient) => DataRow(
                            cells: [
                              DataCell(Text(patient['name'] ?? 'Unknown')),
                              DataCell(Text(patient['admissionDate'] ?? 'N/A')),
                              DataCell(IconButton(
                                icon: const Icon(Icons.info, color: Colors.blue),
                                onPressed: () {
                                  controller.showPatientDetails(
                                    patient['name'] ?? 'Unknown',
                                    patient['id'] ?? 'Unknown',
                                  );
                                },
                              )),
                            ],
                          )).toList(),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddPatientDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  AddPatientDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PatientAdmissionsController>();

    return AlertDialog(
      title: const Text('Admit New Patient'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Patient Name'),
          ),
          TextField(
            controller: dateController,
            decoration: const InputDecoration(labelText: 'Admission Date (DD/MM/YYYY)'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            if (nameController.text.isNotEmpty && dateController.text.isNotEmpty) {
              controller.addPatient(nameController.text, dateController.text);
              Get.back();
            } else {
              Get.snackbar(
                'Error',
                'Please fill all fields',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.red,
                colorText: Colors.white,
              );
            }
          },
          child: const Text('Admit'),
        ),
      ],
    );
  }
}