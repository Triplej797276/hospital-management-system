import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/nurse/bed_controller.dart';
import 'package:hsmproject/controllers/auth_controller.dart';
import 'package:hsmproject/screens/nurse/nurse_dahboard_screen/bed_management_screen.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../controllers/nurse/nurse_bed_management_controller.dart';

// Assuming Bed and Patient models are imported through the controller
// If models are in a separate file, add: import 'path/to/models.dart';

class BedAllocationScreen extends StatelessWidget {
  const BedAllocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final BedController bedController = Get.put(BedController());
    final TextEditingController searchController = TextEditingController();
    final RxString selectedBedNumber = RxString('');
    final RxString selectedPatientId = RxString('');
    final RxString selectedPatientName = RxString('');
    final RxBool isLoading = RxBool(false);

    final Bed? preSelectedBed = Get.arguments as Bed?;
    if (preSelectedBed != null) {
      selectedBedNumber.value = preSelectedBed.bedNumber;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Allocate Bed'),
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
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Allocate Bed',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023E8A),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: searchController,
                decoration: InputDecoration(
                  labelText: 'Search Patient by Name',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.search, color: Color(0xFF0077B6)),
                  suffixIcon: searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            searchController.clear();
                            bedController.searchQuery.value = '';
                            bedController.filterPatients();
                          },
                        )
                      : null,
                ),
                onChanged: (value) {
                  bedController.searchQuery.value = value;
                  bedController.filterPatients();
                },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: bedController.selectedPriorityFilter.value,
                      decoration: const InputDecoration(
                        labelText: 'Patient Priority',
                        border: OutlineInputBorder(),
                      ),
                      items: ['All', 'Critical', 'Urgent', 'Stable']
                          .map((priority) => DropdownMenuItem<String>(
                                value: priority,
                                child: Text(priority),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          bedController.selectedPriorityFilter.value = value;
                          bedController.filterPatients();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      value: bedController.selectedEquipmentFilter.value,
                      decoration: const InputDecoration(
                        labelText: 'Required Equipment',
                        border: OutlineInputBorder(),
                      ),
                      items: ['All', 'Ventilator', 'Oxygen Supply', 'None']
                          .map((equipment) => DropdownMenuItem<String>(
                                value: equipment,
                                child: Text(equipment),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          bedController.selectedEquipmentFilter.value = value;
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Expanded(
                child: bedController.filteredPatients.isEmpty
                    ? const Center(child: Text('No patients found'))
                    : ListView.builder(
                        itemCount: bedController.filteredPatients.length,
                        itemBuilder: (context, index) {
                          final patient = bedController.filteredPatients[index];
                          return Card(
                            elevation: 2,
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: const Icon(Icons.person, color: Color(0xFF0077B6)),
                              title: Text(patient.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Condition: ${patient.condition}'),
                                  Text('Priority: ${patient.priorityLevel}'),
                                  Text('Notes: ${patient.medicalNotes}'),
                                  if (patient.admissionDate != null)
                                    Text(
                                      'Admitted: ${DateFormat('MMM dd, yyyy').format(patient.admissionDate!.toDate())}',
                                    ),
                                ],
                              ),
                              trailing: selectedPatientId.value == patient.patientId
                                  ? const Icon(Icons.check_circle, color: Colors.green)
                                  : null,
                              onTap: () {
                                selectedPatientId.value = patient.patientId as String;
                                selectedPatientName.value = patient.name;
                              },
                            ),
                          );
                        },
                      ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: selectedBedNumber.value.isEmpty ? null : selectedBedNumber.value,
                decoration: InputDecoration(
                  labelText: 'Select Bed',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.bed, color: Color(0xFF0077B6)),
                  errorText: selectedBedNumber.value.isEmpty && isLoading.value
                      ? 'Please select a bed'
                      : null,
                ),
                items: bedController.beds
                    .where((bed) =>
                        bed.status == 'Available' &&
                        bed.cleaningStatus == 'Clean' &&
                        bed.lastCleaned != null &&
                        DateTime.now().difference(bed.lastCleaned!.toDate()).inHours <=
                            24 &&
                        (bedController.selectedEquipmentFilter.value == 'All' ||
                            bed.equipment
                                .contains(bedController.selectedEquipmentFilter.value)))
                    .map((bed) => DropdownMenuItem<String>(
                          value: bed.bedNumber,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${bed.bedNumber} (${bed.bedType}, ${bed.ward})'),
                              Text(
                                'Priority: ${bed.priorityLevel}, Last Cleaned: ${bed.lastCleaned != null ? DateFormat('MMM dd, yyyy HH:mm').format(bed.lastCleaned!.toDate()) : 'N/A'}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                'Equipment: ${bed.equipment.join(", ")}',
                                style: const TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    selectedBedNumber.value = value;
                  }
                },
              ),
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0077B6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: isLoading.value
                      ? null
                      : () async {
                          isLoading.value = true;
                          if (selectedPatientId.value.isEmpty ||
                              selectedBedNumber.value.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please select both a patient and a bed',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                            isLoading.value = false;
                            return;
                          }

                          // Show confirmation dialog
                          bool? confirm = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirm Allocation'),
                              content: Text(
                                'Allocate bed ${selectedBedNumber.value} to ${selectedPatientName.value}?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  child: const Text('Confirm'),
                                ),
                              ],
                            ),
                          );

                          if (confirm != true) {
                            isLoading.value = false;
                            return;
                          }

                          try {
                            await bedController.assignBed(
                              selectedBedNumber.value,
                              selectedPatientName.value,
                              selectedPatientId.value,
                            );
                            Get.back();
                            Get.snackbar(
                              'Success',
                              'Bed ${selectedBedNumber.value} allocated to ${selectedPatientName.value}',
                              backgroundColor: const Color(0xFF0077B6),
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Failed to allocate bed: $e',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                              snackPosition: SnackPosition.BOTTOM,
                            );
                          } finally {
                            isLoading.value = false;
                          }
                        },
                  child: isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Allocate Bed',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}