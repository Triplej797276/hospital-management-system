import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/case_manager/ambulance_management_controller.dart';

class AmbulanceManagementScreen extends StatefulWidget {
  const AmbulanceManagementScreen({super.key});

  @override
  State<AmbulanceManagementScreen> createState() => _AmbulanceManagementScreenState();
}

class _AmbulanceManagementScreenState extends State<AmbulanceManagementScreen> {
  final controller = Get.put(AmbulanceManagementController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Ambulance Management',
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
                  'Manage Ambulances',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showAddPatientDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Add New Patient', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                    ElevatedButton(
                      onPressed: () => _showAddAmbulanceDialog(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue[700],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: const Text('Add New Ambulance', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text('Ambulance Status', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.ambulances.length,
                        itemBuilder: (context, index) {
                          final ambulance = controller.ambulances[index];
                          final ambulanceId = ambulance['id'] as String? ?? 'Unknown';
                          final vehicleNumber = ambulance['vehicleNumber'] as String? ?? 'Unknown';
                          final type = ambulance['type'] as String? ?? 'Unknown';
                          final status = ambulance['status'] as String? ?? 'Unknown';
                          return ListTile(
                            leading: const Icon(Icons.local_hospital, color: Colors.red),
                            title: Text('Ambulance $vehicleNumber'),
                            subtitle: Text('Type: $type | Status: $status'),
                            trailing: IconButton(
                              icon: const Icon(Icons.info, color: Colors.red),
                              onPressed: () {
                                Get.snackbar(
                                  'Ambulance Details',
                                  'Vehicle: $vehicleNumber | Type: $type | Status: $status',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    )),
                const SizedBox(height: 20),
                const Text('Patient List', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
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
                              offset: const Offset(0, 3)),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: controller.patients.length,
                        itemBuilder: (context, index) {
                          final patient = controller.patients[index];
                          final patientName = patient['name'] as String? ?? 'Unknown';
                          final condition = patient['condition'] as String? ?? 'Unknown';
                          final location = patient['location'] as String? ?? 'Unknown';
                          final assignedAmbulance = patient['assignedAmbulance'] as String?;
                          return ListTile(
                            leading: const Icon(Icons.person, color: Colors.blue),
                            title: Text(patientName),
                            subtitle: Text('Condition: $condition | Location: $location'),
                            trailing: assignedAmbulance == null
                                ? ElevatedButton(
                                    onPressed: () => _showAssignAmbulanceDialog(context, patient['id']),
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red[700]),
                                    child: const Text('Assign Ambulance', style: TextStyle(color: Colors.white)),
                                  )
                                : Text('Ambulance: $assignedAmbulance', style: const TextStyle(color: Colors.green)),
                          );
                        },
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Dialog to add a new patient
  void _showAddPatientDialog(BuildContext context) {
    final nameController = TextEditingController();
    final conditionController = TextEditingController();
    final locationController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Patient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Patient Name'),
            ),
            TextField(
              controller: conditionController,
              decoration: const InputDecoration(labelText: 'Condition'),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: 'Location'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  conditionController.text.isNotEmpty &&
                  locationController.text.isNotEmpty) {
                controller.addPatient(
                  nameController.text,
                  conditionController.text,
                  locationController.text,
                );
                Navigator.pop(context);
              } else {
                Get.snackbar('Error', 'Please fill all fields',
                    backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
            child: const Text('Add Patient'),
          ),
        ],
      ),
    );
  }

  // Dialog to add a new ambulance
  void _showAddAmbulanceDialog(BuildContext context) {
    final vehicleNumberController = TextEditingController();
    final typeController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Ambulance'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: vehicleNumberController,
              decoration: const InputDecoration(labelText: 'Vehicle Number'),
            ),
            TextField(
              controller: typeController,
              decoration: const InputDecoration(labelText: 'Type (e.g., Basic, Advanced)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (vehicleNumberController.text.isNotEmpty && typeController.text.isNotEmpty) {
                controller.addAmbulance(
                  vehicleNumberController.text,
                  typeController.text,
                );
                Navigator.pop(context);
              } else {
                Get.snackbar('Error', 'Please fill all fields',
                    backgroundColor: Colors.red, colorText: Colors.white);
              }
            },
            child: const Text('Add Ambulance'),
          ),
        ],
      ),
    );
  }

  // Dialog to assign an ambulance to a patient
  void _showAssignAmbulanceDialog(BuildContext context, String patientId) {
    String? selectedAmbulanceId;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Assign Ambulance'),
        content: Obx(() {
          final availableAmbulances = controller.ambulances
              .where((ambulance) => ambulance['status'] == 'Available')
              .toList();

          if (availableAmbulances.isEmpty) {
            return const Text('No available ambulances');
          }

          return DropdownButton<String>(
            hint: const Text('Select Ambulance'),
            isExpanded: true,
            value: selectedAmbulanceId,
            items: availableAmbulances.map((ambulance) {
              final ambulanceId = ambulance['id'] as String? ?? '';
              final vehicleNumber = ambulance['vehicleNumber'] as String? ?? 'Unknown';
              return DropdownMenuItem<String>(
                value: ambulanceId,
                child: Text('Ambulance $vehicleNumber'),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                selectedAmbulanceId = value;
                controller.assignAmbulance(patientId, value);
                Navigator.pop(context);
              }
            },
          );
        }),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }
}