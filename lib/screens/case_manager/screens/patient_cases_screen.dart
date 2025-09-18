import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/case_manager/patient_cases_controller.dart';


class PatientCasesScreen extends StatelessWidget {
  const PatientCasesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PatientCasesController controller = Get.put(PatientCasesController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Patient Cases',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue[800],
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Get.back();
          },
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
                  'Manage Patient Cases',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                Obx(() => ElevatedButton(
                      onPressed: controller.isCreatingCase.value ? null : controller.createNewCase,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[700],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: controller.isCreatingCase.value
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text(
                              'Create New Case',
                              style: TextStyle(color: Colors.white, fontSize: 16),
                            ),
                    )),
                const SizedBox(height: 20),
                const Text(
                  'Active Cases',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                StreamBuilder(
                  stream: controller.patientCasesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Center(child: Text('Error loading cases'));
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text('No active cases found'));
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          final doc = snapshot.data!.docs[index];
                          final data = doc.data() as Map<String, dynamic>;
                          final lastUpdated = (data['lastUpdated'] as Timestamp?)
                              ?.toDate()
                              .toString()
                              .split('.')[0];

                          return ListTile(
                            leading: const Icon(Icons.medical_services, color: Colors.green),
                            title: Text(data['caseNumber'] ?? 'Unnamed Case'),
                            subtitle: Text('Last Updated: ${lastUpdated ?? 'N/A'}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.info, color: Colors.green),
                              onPressed: () {
                                Get.snackbar(
                                  'Case Details',
                                  'Details for ${data['caseNumber']} coming soon!',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}