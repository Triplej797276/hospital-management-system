import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/receptionists/appointment_management_controller.dart';

class AppointmentListScreen extends StatelessWidget {
  AppointmentListScreen({super.key});

  final AppointmentController controller = Get.put(AppointmentController());

  final TextEditingController patientNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController departmentController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  DateTime? selectedDate;

  final RxBool showForm = false.obs;

  Color getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Appointments"),
        backgroundColor: Colors.teal,
      ),
      body: Column(
        children: [
          const SizedBox(height: 12),
          Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () => showForm.value = !showForm.value,
                child: Text(
                  showForm.value ? "Hide Form" : "Add New Appointment",
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              )),
          const SizedBox(height: 10),

          // Appointment Form
          Obx(() {
            if (!showForm.value) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                shadowColor: Colors.teal.withOpacity(0.5),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: patientNameController,
                        decoration: const InputDecoration(
                          labelText: "Patient Name",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.person),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: emailController,
                        decoration: const InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.email),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        return DropdownButtonFormField<String>(
                          value: departmentController.text.isNotEmpty
                              ? departmentController.text
                              : null,
                          decoration: const InputDecoration(
                            labelText: "Department",
                            border: OutlineInputBorder(),
                            prefixIcon: Icon(Icons.apartment),
                          ),
                          items: controller.departments
                              .map((dept) => DropdownMenuItem(
                                    value: dept,
                                    child: Text(dept),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            if (value != null) {
                              departmentController.text = value;
                            }
                          },
                        );
                      }),
                      const SizedBox(height: 10),
                      TextField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          labelText: "Phone Number",
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.calendar_today),
                        label: const Text("Pick Appointment Date"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2024),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) {
                            selectedDate = picked;
                            Get.snackbar(
                              "Date Selected",
                              "${picked.day}-${picked.month}-${picked.year}",
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.teal,
                              colorText: Colors.white,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 10),
                      Obx(() => ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            onPressed: controller.isLoading.value
                                ? null
                                : () {
                                    if (selectedDate == null) {
                                      Get.snackbar("Error",
                                          "Please pick an appointment date",
                                          snackPosition: SnackPosition.BOTTOM);
                                      return;
                                    }
                                    controller.addAppointment(
                                      patientName:
                                          patientNameController.text.trim(),
                                      email: emailController.text.trim(),
                                      department:
                                          departmentController.text.trim(),
                                      phoneNumber: phoneController.text.trim(),
                                      appointmentDate: selectedDate!,
                                      createdBy: '',
                                    );
                                    patientNameController.clear();
                                    emailController.clear();
                                    departmentController.clear();
                                    phoneController.clear();
                                    selectedDate = null;
                                    showForm.value = false;
                                  },
                            child: controller.isLoading.value
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text(
                                    "Add Appointment",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                          )),
                    ],
                  ),
                ),
              ),
            );
          }),

          const Divider(),

          // Appointment List
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
              if (controller.appointments.isEmpty) {
                return const Center(child: Text("No appointments found"));
              }

              return ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                itemCount: controller.appointments.length,
                itemBuilder: (context, index) {
                  final appt = controller.appointments[index];
                  final apptDate = appt['appointmentDate'] is Timestamp
                      ? (appt['appointmentDate'] as Timestamp).toDate()
                      : DateTime.tryParse(
                          appt['appointmentDate'].toString());
                  String currentStatus = appt['status'] ?? 'Pending';

                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    margin: const EdgeInsets.symmetric(vertical: 6),
                    shadowColor: Colors.teal.withOpacity(0.3),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.person, color: Colors.teal),
                              const SizedBox(width: 8),
                              Text(
                                appt['patientName'] ?? 'No Name',
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getStatusColor(currentStatus),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  currentStatus,
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.email, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(appt['email'] ?? ''),
                              const SizedBox(width: 16),
                              const Icon(Icons.phone, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(appt['phoneNumber'] ?? ''),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(Icons.apartment, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(appt['department'] ?? ''),
                              const SizedBox(width: 16),
                              const Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                              const SizedBox(width: 4),
                              Text(apptDate != null
                                  ? "${apptDate.day}-${apptDate.month}-${apptDate.year}"
                                  : 'Not set'),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Text("Change Status: "),
                              const SizedBox(width: 8),
                              DropdownButton<String>(
                                value: currentStatus,
                                items: controller.statusOptions
                                    .map((status) => DropdownMenuItem(
                                          value: status,
                                          child: Text(status),
                                        ))
                                    .toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    controller.updateStatus(appt['id'], value);
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
