import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/auth_controller.dart';
import 'package:hsmproject/controllers/bed_controller.dart';

// Define Bed model (same as in NurseBedManagementScreen)
class Bed {
  final String bedNumber;
  String status;
  String patient;
  final String bedType;

  Bed({
    required this.bedNumber,
    required this.status,
    required this.patient,
    required this.bedType,
  });

  Map<String, dynamic> toMap() => {
        'bedNumber': bedNumber,
        'status': status,
        'patient': patient,
        'bedType': bedType,
      };

  factory Bed.fromMap(Map<String, dynamic> map) => Bed(
        bedNumber: map['bedNumber'],
        status: map['status'],
        patient: map['patient'],
        bedType: map['bedType'],
      );
}

class BedAllocationScreen extends StatelessWidget {
  const BedAllocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final BedController bedController = Get.put(BedController());
    final TextEditingController patientController = TextEditingController();
    final RxString selectedBedNumber = RxString('');
    final RxBool isLoading = RxBool(false);

    // If navigated from NurseBedManagementScreen with a specific bed
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
                controller: patientController,
                decoration: InputDecoration(
                  labelText: 'Patient Name',
                  border: const OutlineInputBorder(),
                  prefixIcon: const Icon(Icons.person, color: Color(0xFF0077B6)),
                  errorText: patientController.text.isEmpty && isLoading.value
                      ? 'Patient name is required'
                      : null,
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
                    .where((bed) => bed.status == 'Available')
                    .map((bed) => DropdownMenuItem<String>(
                          value: bed.bedNumber,
                          child: Text('${bed.bedNumber} (${bed.bedType})'),
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
                          if (patientController.text.isEmpty || selectedBedNumber.value.isEmpty) {
                            Get.snackbar(
                              'Error',
                              'Please fill all fields',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                            isLoading.value = false;
                            return;
                          }

                          try {
                            await bedController.assignBed(
                              selectedBedNumber.value,
                              patientController.text,
                            );
                            Get.back();
                            Get.snackbar(
                              'Success',
                              'Bed ${selectedBedNumber.value} allocated to ${patientController.text}',
                              backgroundColor: const Color(0xFF0077B6),
                              colorText: Colors.white,
                            );
                          } catch (e) {
                            Get.snackbar(
                              'Error',
                              'Failed to allocate bed: $e',
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
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