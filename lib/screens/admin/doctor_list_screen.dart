import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/doctors/add_doctor_controller.dart';
import '../doctor/add_doctor_screen.dart';

class DoctorListScreen extends StatelessWidget {
  const DoctorListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DoctorController controller = Get.put(DoctorController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Doctors List'),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 4,
      ),
      body: Obx(() {
        final doctors = controller.doctors;

        if (doctors.isEmpty) {
          return const Center(
            child: Text(
              'No doctors found',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Counter at the top
            Container(
              width: double.infinity,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Text(
                "Total Doctors: ${doctors.length}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),

            // 🔹 DataTable
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 16,
                    dataRowHeight: 60,
                    headingRowHeight: 56,
                    headingRowColor: MaterialStateProperty.all(
                        Theme.of(context).primaryColor.withOpacity(0.1)),
                    border: TableBorder.all(
                      color: Colors.grey.shade300,
                      width: 1,
                    ),
                    columns: const [
                      DataColumn(
                          label: Text('Name',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(
                          label: Text('Specialization',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(
                          label: Text('Department',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(
                          label: Text('Qualifications',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(
                          label: Text('Experience',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(
                          label: Text('Contact',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(
                          label: Text('Email',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                      DataColumn(
                          label: Text('Availability',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14))),
                    ],
                    rows: doctors.asMap().entries.map((entry) {
                      final index = entry.key;
                      final doctor = entry.value;
                      return DataRow(
                        color: MaterialStateProperty.all(
                          index % 2 == 0 ? Colors.white : Colors.grey.shade50,
                        ),
                        cells: [
                          DataCell(Text(doctor['name'] ?? 'Unknown',
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w500))),
                          DataCell(Text(doctor['specialization'] ?? 'N/A',
                              style: const TextStyle(fontSize: 12))),
                          DataCell(Text(doctor['department'] ?? 'N/A',
                              style: const TextStyle(fontSize: 12))),
                          DataCell(Text(doctor['qualifications'] ?? 'N/A',
                              style: const TextStyle(fontSize: 12))),
                          DataCell(Text('${doctor['experience'] ?? 0} years',
                              style: const TextStyle(fontSize: 12))),
                          DataCell(Text(doctor['contact'] ?? 'N/A',
                              style: const TextStyle(fontSize: 12))),
                          DataCell(Text(doctor['email'] ?? 'N/A',
                              style: const TextStyle(fontSize: 12))),
                          DataCell(Text(doctor['availability'] ?? 'N/A',
                              style: const TextStyle(fontSize: 12))),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddDoctorScreen()),
        tooltip: 'Add Doctor',
        backgroundColor: Theme.of(context).primaryColor,
        child: const Icon(Icons.person_add, color: Colors.white),
      ),
    );
  }
}
