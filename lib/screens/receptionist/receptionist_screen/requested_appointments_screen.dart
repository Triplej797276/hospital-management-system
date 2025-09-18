import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/receptionists/requested_appointments_controller.dart';

class RequestedAppointmentsScreen extends StatelessWidget {
  const RequestedAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RequestedAppointmentsController());

    // Controllers for new request form
    final patientNameController = TextEditingController();
    String? selectedDoctor;
    String? selectedDepartment;
    final reasonController = TextEditingController();
    DateTime? selectedDate;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Requested Appointments'),
        backgroundColor: Colors.teal[300],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text("Add Request"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal[300]),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => StatefulBuilder(
                      builder: (context, setState) => AlertDialog(
                        title: const Text("New Requested Appointment"),
                        content: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextField(
                                controller: patientNameController,
                                decoration: const InputDecoration(labelText: "Patient Name"),
                              ),
                              const SizedBox(height: 10),
                              // Doctor Dropdown
                              Obx(() {
                                return DropdownButtonFormField<String>(
                                  decoration: const InputDecoration(labelText: "Preferred Doctor"),
                                  items: [
                                    for (var d in controller.doctors)
                                      DropdownMenuItem(
                                        value: d["id"],
                                        child: Text(d["name"] ?? "Unknown"),
                                      )
                                  ],
                                  onChanged: (value) => setState(() => selectedDoctor = value),
                                );
                              }),
                              const SizedBox(height: 10),
                              // Department Dropdown
                              DropdownButtonFormField<String>(
                                decoration: const InputDecoration(labelText: "Department"),
                                items: [
                                  for (var dept in ["Cardiology", "Neurology", "Orthopedics", "General"])
                                    DropdownMenuItem(value: dept, child: Text(dept))
                                ],
                                onChanged: (value) => setState(() => selectedDepartment = value),
                              ),
                              const SizedBox(height: 10),
                              // Date Picker
                              TextButton(
                                onPressed: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime.now().add(const Duration(days: 365)),
                                  );
                                  if (date != null) setState(() => selectedDate = date);
                                },
                                child: Text(selectedDate == null
                                    ? "Select Date"
                                    : selectedDate!.toLocal().toString().split(' ')[0]),
                              ),
                              TextField(
                                controller: reasonController,
                                decoration: const InputDecoration(labelText: "Reason"),
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
                                  selectedDate != null) {
                                final doctorName = controller.doctors
                                    .firstWhere((d) => d["id"] == selectedDoctor)["name"];
                                controller.addRequestedAppointment({
                                  "patientName": patientNameController.text,
                                  "preferredDoctorId": selectedDoctor,
                                  "preferredDoctor": doctorName,
                                  "preferredDepartment": selectedDepartment,
                                  "requestedDate": selectedDate,
                                  "reason": reasonController.text,
                                  "status": "Pending",
                                  "submittedAt": DateTime.now(),
                                });
                                Get.back();
                              } else {
                                Get.snackbar("Error", "Please fill all required fields");
                              }
                            },
                            child: const Text("Submit Request"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.builder(
                  itemCount: controller.requestedAppointments.length,
                  itemBuilder: (context, index) {
                    final req = controller.requestedAppointments[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: const Icon(Icons.pending_actions, color: Colors.teal),
                        title: Text(req['patientName'] ?? ''),
                        subtitle: Text(
                          "Doctor: ${req['preferredDoctor'] ?? ''} • Dept: ${req['preferredDepartment'] ?? ''}\n"
                          "Date: ${req['requestedDate'] != null ? (req['requestedDate'] as DateTime).toLocal().toString().split(' ')[0] : ''}\n"
                          "Reason: ${req['reason'] ?? ''}\nStatus: ${req['status'] ?? ''}",
                        ),
                        isThreeLine: true,
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) => controller.updateStatus(req['id'], value),
                          itemBuilder: (context) => [
                            const PopupMenuItem(value: "Approved", child: Text("Approve")),
                            const PopupMenuItem(value: "Rejected", child: Text("Reject")),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
