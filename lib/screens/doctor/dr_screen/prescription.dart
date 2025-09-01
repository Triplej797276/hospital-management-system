import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Prescription Model
class Prescription {
  String id;
  String patientName;
  List<String> medications;
  DateTime date;

  Prescription({
    required this.id,
    required this.patientName,
    required this.medications,
    required this.date,
  });
}

// Prescriptions Controller
class PrescriptionsController extends GetxController {
  RxList<Prescription> prescriptions = RxList<Prescription>([]);

  @override
  void onInit() {
    super.onInit();
    fetchPrescriptions();
  }

  void fetchPrescriptions() {
    // Mock data
    prescriptions.addAll([
      Prescription(
        id: '1',
        patientName: 'Bob',
        medications: ['Aspirin'],
        date: DateTime.now(),
      ),
    ]);
  }

  void createPrescription(Prescription newRx) {
    prescriptions.add(newRx);
  }

  void updatePrescription(String id, Prescription updatedRx) {
    final index = prescriptions.indexWhere((rx) => rx.id == id);
    if (index != -1) {
      prescriptions[index] = updatedRx;
    }
  }

  void deletePrescription(String id) {
    prescriptions.removeWhere((rx) => rx.id == id);
  }
}

// Prescriptions Screen
class PrescriptionsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PrescriptionsController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Prescriptions'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => ListView.builder(
            itemCount: controller.prescriptions.length,
            itemBuilder: (context, index) {
              final rx = controller.prescriptions[index];
              return ListTile(
                title: Text(rx.patientName),
                subtitle: Text('${rx.medications.join(', ')} | Date: ${rx.date.toString()}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        // Update with mock data for simplicity
                        controller.updatePrescription(
                          rx.id,
                          Prescription(
                            id: rx.id,
                            patientName: '${rx.patientName} Edited',
                            medications: rx.medications..add('Ibuprofen'),
                            date: rx.date,
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => controller.deletePrescription(rx.id),
                    ),
                  ],
                ),
              );
            },
          )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Color(0xFF26A69A),
        onPressed: () => controller.createPrescription(
          Prescription(
            id: '${controller.prescriptions.length + 1}',
            patientName: 'New Patient',
            medications: ['Medicine'],
            date: DateTime.now(),
          ),
        ),
      ),
    );
  }
}

// Main App
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Prescriptions App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
      ),
      home: PrescriptionsScreen(),
    );
  }
}