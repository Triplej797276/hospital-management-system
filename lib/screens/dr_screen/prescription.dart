import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/doctors/prescriptions_controller.dart';
import 'package:intl/intl.dart';

class PrescriptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrescriptionsController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Doctor Prescriptions', style: TextStyle(fontWeight: FontWeight.bold)),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF26A69A), Color(0xFF00796B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.prescriptions.isEmpty) {
          return Center(child: Text('No prescriptions available', style: TextStyle(fontSize: 18, color: Colors.grey[600])));
        }

        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: controller.prescriptions.length,
          itemBuilder: (context, index) {
            final rx = controller.prescriptions[index];
            return Card(
              elevation: 5,
              margin: const EdgeInsets.symmetric(vertical: 10),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [Colors.teal.shade50, Colors.white], begin: Alignment.topLeft, end: Alignment.bottomRight),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(rx.patientName, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal.shade800)),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(color: Colors.teal.shade200, borderRadius: BorderRadius.circular(12)),
                          child: Text(DateFormat('yyyy-MM-dd').format(rx.date), style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Row(children: [Icon(Icons.medical_services, color: Colors.teal), SizedBox(width: 8), Expanded(child: Text(rx.medications.join(', '), style: TextStyle(fontSize: 16)))]),
                    SizedBox(height: 8),
                    Row(children: [Icon(Icons.description, color: Colors.teal), SizedBox(width: 8), Expanded(child: Text(rx.dosageInstructions, style: TextStyle(fontSize: 16)))]),
                    SizedBox(height: 12),
                    Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                      IconButton(icon: Icon(Icons.edit, color: Colors.blue), onPressed: () => controller.editPrescription(rx)),
                      IconButton(icon: Icon(Icons.delete, color: Colors.red), onPressed: () => controller.deletePrescription(rx.id)),
                    ]),
                  ],
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color(0xFF26A69A),
        child: Icon(Icons.add, color: Colors.white),
        onPressed: () {
          controller.clearForm();
          Get.toNamed('/prescription_form');
        },
      ),
    );
  }
}

// ---------------- Prescription Form ----------------
class PrescriptionForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PrescriptionsController>();

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.editingId.value.isEmpty ? 'Add Prescription' : 'Edit Prescription')),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Color(0xFF26A69A), Color(0xFF00796B)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(controller: controller.patientNameController, decoration: InputDecoration(labelText: 'Patient Name', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), prefixIcon: Icon(Icons.person, color: Color(0xFF26A69A)))),
                SizedBox(height: 16),
                TextField(controller: controller.medicationsController, decoration: InputDecoration(labelText: 'Medications (comma-separated)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), prefixIcon: Icon(Icons.medical_services, color: Color(0xFF26A69A)))),
                SizedBox(height: 16),
                TextField(controller: controller.dosageController, decoration: InputDecoration(labelText: 'Dosage Instructions', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), prefixIcon: Icon(Icons.description, color: Color(0xFF26A69A)))),
                SizedBox(height: 16),
                TextField(
                  controller: controller.dateController,
                  decoration: InputDecoration(labelText: 'Date (yyyy-MM-dd)', border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)), prefixIcon: Icon(Icons.calendar_today, color: Color(0xFF26A69A))),
                  readOnly: true,
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: controller.dateController.text.isEmpty ? DateTime.now() : DateFormat('yyyy-MM-dd').parse(controller.dateController.text),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (date != null) controller.dateController.text = DateFormat('yyyy-MM-dd').format(date);
                  },
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => controller.createPrescription(),
                  style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF26A69A), padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                  child: Obx(() => Text(controller.editingId.value.isEmpty ? 'Add Prescription' : 'Update Prescription', style: TextStyle(fontSize: 16))),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
