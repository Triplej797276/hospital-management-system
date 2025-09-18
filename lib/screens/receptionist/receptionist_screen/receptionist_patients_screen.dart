import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/receptionists/receptionist_admissions_controller.dart';

class ReceptionistPatientsScreen extends StatelessWidget {
  const ReceptionistPatientsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final admissionController = Get.put(ReceptionistAdmissionsController());

    /// Controllers for patient details
    final patientNameController = TextEditingController();
    final patientAgeController = TextEditingController();
    final patientGenderController = TextEditingController();
    final patientPhoneController = TextEditingController();
    final patientAddressController = TextEditingController();

    /// Other controllers
    final insuranceController = TextEditingController();
    final guardianController = TextEditingController();
    final guardianPhoneController = TextEditingController();
    final reasonController = TextEditingController();

    String? selectedDepartment;
    String? selectedDoctor;
    String? selectedRoomType;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Patient Admissions"),
        backgroundColor: Colors.teal[300],
      ),
      body: Obx(() {
        if (admissionController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (admissionController.admissions.isEmpty) {
          return const Center(child: Text("No admissions yet"));
        }

        return SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            columns: const [
              DataColumn(label: Text("Patient Name")),
              DataColumn(label: Text("Age")),
              DataColumn(label: Text("Gender")),
              DataColumn(label: Text("Phone")),
              DataColumn(label: Text("Address")),
              DataColumn(label: Text("Doctor")),
              DataColumn(label: Text("Department")),
              DataColumn(label: Text("Room")),
              DataColumn(label: Text("Insurance")),
              DataColumn(label: Text("Guardian Name")),
              DataColumn(label: Text("Guardian Contact")),
              DataColumn(label: Text("Reason")),
              DataColumn(label: Text("Actions")),
            ],
            rows: [
              for (var admission in admissionController.admissions)
                DataRow(cells: [
                  DataCell(Text(admission['patientName'] ?? "")),
                  DataCell(Text(admission['patientAge'] ?? "")),
                  DataCell(Text(admission['patientGender'] ?? "")),
                  DataCell(Text(admission['patientPhone'] ?? "")),
                  DataCell(Text(admission['patientAddress'] ?? "")),
                  DataCell(Text(admission['doctorName'] ?? "")),
                  DataCell(Text(admission['department'] ?? "")),
                  DataCell(Text(admission['roomType'] ?? "")),
                  DataCell(Text(admission['insurancePolicy'] ?? "")),
                  DataCell(Text(admission['guardianName'] ?? "")),
                  DataCell(Text(admission['guardianContact'] ?? "")),
                  DataCell(Text(admission['reasonForAdmission'] ?? "")),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        admissionController.deleteAdmission(admission['id']);
                      },
                    ),
                  ),
                ]),
            ],
          ),
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal[300],
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => StatefulBuilder(
              builder: (context, setState) => AlertDialog(
                title: const Text("Add Admission"),
                content: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Patient Details",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: patientNameController,
                        decoration: const InputDecoration(labelText: "Patient Name"),
                      ),
                      TextField(
                        controller: patientAgeController,
                        decoration: const InputDecoration(labelText: "Age"),
                        keyboardType: TextInputType.number,
                      ),
                      TextField(
                        controller: patientGenderController,
                        decoration: const InputDecoration(labelText: "Gender"),
                      ),
                      TextField(
                        controller: patientPhoneController,
                        decoration: const InputDecoration(labelText: "Phone"),
                        keyboardType: TextInputType.phone,
                      ),
                      TextField(
                        controller: patientAddressController,
                        decoration: const InputDecoration(labelText: "Address"),
                      ),
                      const Divider(height: 20),

                      /// Department Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Department"),
                        items: [
                          for (var dept in ["Cardiology", "Neurology", "Orthopedics", "General"])
                            DropdownMenuItem(value: dept, child: Text(dept))
                        ],
                        onChanged: (value) => selectedDepartment = value,
                      ),

                      /// Doctor Dropdown
                      Obx(() {
                        return DropdownButtonFormField<String>(
                          decoration: const InputDecoration(labelText: "Select Doctor"),
                          items: [
                            for (var d in admissionController.doctors)
                              DropdownMenuItem(
                                value: d["id"],
                                child: Text(d["name"] ?? "Unknown"),
                              )
                          ],
                          onChanged: (value) => selectedDoctor = value,
                        );
                      }),

                      /// Room Type Dropdown
                      DropdownButtonFormField<String>(
                        decoration: const InputDecoration(labelText: "Room Type"),
                        items: [
                          for (var room in ["General Ward", "Semi-Private", "Private", "ICU"])
                            DropdownMenuItem(value: room, child: Text(room))
                        ],
                        onChanged: (value) => selectedRoomType = value,
                      ),

                      TextField(
                        controller: insuranceController,
                        decoration: const InputDecoration(labelText: "Insurance Policy"),
                      ),
                      TextField(
                        controller: guardianController,
                        decoration: const InputDecoration(labelText: "Guardian Name"),
                      ),
                      TextField(
                        controller: guardianPhoneController,
                        decoration: const InputDecoration(labelText: "Guardian Phone"),
                        keyboardType: TextInputType.phone,
                      ),
                      TextField(
                        controller: reasonController,
                        decoration: const InputDecoration(labelText: "Reason for Admission"),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text("Cancel"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[300]),
                    onPressed: () {
                      if (patientNameController.text.isNotEmpty &&
                          selectedDoctor != null &&
                          selectedDepartment != null &&
                          selectedRoomType != null) {
                        admissionController.addAdmission({
                          "patientName": patientNameController.text,
                          "patientAge": patientAgeController.text,
                          "patientGender": patientGenderController.text,
                          "patientPhone": patientPhoneController.text,
                          "patientAddress": patientAddressController.text,
                          "doctorId": selectedDoctor,
                          "doctorName": admissionController.doctors
                              .firstWhere((d) => d["id"] == selectedDoctor)["name"],
                          "department": selectedDepartment,
                          "roomType": selectedRoomType,
                          "insurancePolicy": insuranceController.text,
                          "guardianName": guardianController.text,
                          "guardianContact": guardianPhoneController.text,
                          "reasonForAdmission": reasonController.text,
                          "admissionDate": DateTime.now(),
                          "createdAt": DateTime.now(),
                        });
                        Get.back();
                      } else {
                        Get.snackbar("Error", "Please fill all required fields");
                      }
                    },
                    child: const Text("Admit"),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
