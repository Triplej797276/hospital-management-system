import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:hsmproject/controllers/auth_controller.dart';

import '../../../controllers/nurse/nurse_bed_management_controller.dart';

class NurseBedManagementScreen extends StatelessWidget {
  const NurseBedManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final NurseBedManagementController bedController =
        Get.put(NurseBedManagementController());
    final TextEditingController bedNumberController = TextEditingController();
    final TextEditingController bedTypeController = TextEditingController();
    final TextEditingController wardController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Beds'),
        backgroundColor: const Color(0xFF0077B6),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authController.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Bed Management',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      TextField(
                        controller: bedNumberController,
                        decoration: const InputDecoration(
                          labelText: 'New Bed Number',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: bedTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Bed Type (e.g., ICU, General)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: wardController,
                        decoration: const InputDecoration(
                          labelText: 'Ward (e.g., ICU, General Ward)',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B6),
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (bedNumberController.text.isNotEmpty &&
                        bedTypeController.text.isNotEmpty &&
                        wardController.text.isNotEmpty) {
                      bedController.addBed(
                        bedNumberController.text,
                        bedTypeController.text,
                        wardController.text,
                      );
                      bedNumberController.clear();
                      bedTypeController.clear();
                      wardController.clear();
                    } else {
                      Get.snackbar('Error', 'Please fill all fields',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white);
                    }
                  },
                  child: const Text('Add Bed'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(
                () => SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(
                            label: Text('Bed Number',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Status',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Patient',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Bed Type',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Ward',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Last Cleaned',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                        DataColumn(
                            label: Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.bold))),
                      ],
                      rows: bedController.beds.map((bed) {
                        final lastCleaned = bed.lastCleaned != null
                            ? DateFormat('yyyy-MM-dd HH:mm')
                                .format(bed.lastCleaned!.toDate())
                            : 'Not cleaned';
                        return DataRow(cells: [
                          DataCell(Text(bed.bedNumber)),
                          DataCell(Text(bed.status)),
                          DataCell(Text(bed.patient)),
                          DataCell(Text(bed.bedType)),
                          DataCell(Text(bed.ward)),
                          DataCell(Text(lastCleaned)),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.cleaning_services,
                                      color: Colors.green),
                                  onPressed: () {
                                    bedController.markBedAsCleaned(bed.id);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () {
                                    _showUpdateDialog(context, bed, bedController);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    bedController.deleteBed(bed.id);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0077B6),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  Get.toNamed('/allocateBed');
                },
                child: const Text(
                  'Allocate Bed',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(
      BuildContext context, Bed bed, NurseBedManagementController controller) {
    final TextEditingController patientController =
        TextEditingController(text: bed.patient);
    final TextEditingController bedTypeController =
        TextEditingController(text: bed.bedType);
    final TextEditingController wardController =
        TextEditingController(text: bed.ward);
    String status = bed.status;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update ${bed.bedNumber}'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: patientController,
                decoration: const InputDecoration(labelText: 'Patient Name'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: bedTypeController,
                decoration:
                    const InputDecoration(labelText: 'Bed Type (e.g., ICU, General)'),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: wardController,
                decoration:
                    const InputDecoration(labelText: 'Ward (e.g., ICU, General Ward)'),
              ),
              const SizedBox(height: 10),
              DropdownButton<String>(
                value: status,
                items: ['Available', 'Occupied']
                    .map((status) => DropdownMenuItem(
                          value: status,
                          child: Text(status),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    status = value;
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              controller.updateBed(Bed(
                id: bed.id,
                bedNumber: bed.bedNumber,
                status: status,
                patient: patientController.text.isEmpty
                    ? 'None'
                    : patientController.text,
                bedType: bedTypeController.text.isEmpty
                    ? bed.bedType
                    : bedTypeController.text,
                ward: wardController.text.isEmpty ? bed.ward : wardController.text,
                lastCleaned: bed.lastCleaned,
              ));
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}