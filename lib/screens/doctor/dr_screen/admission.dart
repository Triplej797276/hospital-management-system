import 'package:flutter/material.dart';
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
}

class AdmissionsController extends GetxController {
  RxList<Admission> admissions = RxList<Admission>([]);

  @override
  void onInit() {
    super.onInit();
    fetchAdmissions();
  }

  void fetchAdmissions() {
    // Mock data
    admissions.addAll([
      Admission(id: '1', patientName: 'Alice', admissionDate: DateTime.now(), ward: 'ICU'),
      Admission(id: '2', patientName: 'Bob', admissionDate: DateTime.now(), ward: 'General'),
    ]);
  }

  void createAdmission(Admission newAdmission) {
    admissions.add(newAdmission);
  }

  void updateAdmission(String id, Admission updatedAdmission) {
    final index = admissions.indexWhere((admission) => admission.id == id);
    if (index != -1) {
      admissions[index] = updatedAdmission;
    }
  }

  void deleteAdmission(String id) {
    admissions.removeWhere((admission) => admission.id == id);
  }
}

class AdmissionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdmissionsController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Admissions'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.admissions.length,
            itemBuilder: (context, index) {
              final admission = controller.admissions[index];
              return ListTile(
                title: Text(admission.patientName),
                subtitle: Text(admission.admissionDate.toString()),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Simple update example: modify patient name
                        controller.updateAdmission(
                          admission.id,
                          Admission(
                            id: admission.id,
                            patientName: '${admission.patientName} (Updated)',
                            admissionDate: admission.admissionDate,
                            ward: admission.ward,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deleteAdmission(admission.id),
                    ),
                  ],
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => controller.createAdmission(
          Admission(
            id: '${controller.admissions.length + 1}',
            patientName: 'Patient ${controller.admissions.length + 1}',
            admissionDate: DateTime.now(),
            ward: 'General',
          ),
        ),
      ),
    );
  }
}