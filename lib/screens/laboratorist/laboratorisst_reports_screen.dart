import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:printing/printing.dart';

import '../../controllers/laboratorists/laboratorist_reports_controller.dart';

class LaboratoristReportsScreen extends StatefulWidget {
  const LaboratoristReportsScreen({super.key});

  @override
  State<LaboratoristReportsScreen> createState() => _LaboratoristReportsScreenState();
}

class _LaboratoristReportsScreenState extends State<LaboratoristReportsScreen> {
  final ReportsController _controller = ReportsController();
  final TextEditingController _patientNameController = TextEditingController();
  final TextEditingController _testTypeController = TextEditingController();
  final TextEditingController _resultsController = TextEditingController();
  final TextEditingController _labTechnicianController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Reports',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Lab Reports',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Generate New Report',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Fill in the details to create a new lab report.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _patientNameController,
                        decoration: const InputDecoration(
                          labelText: 'Patient Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _testTypeController,
                        decoration: const InputDecoration(
                          labelText: 'Test Type',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _labTechnicianController,
                        decoration: const InputDecoration(
                          labelText: 'Lab Technician Name',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _resultsController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Results',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _generateAndSaveReport,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Save Report'),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: _generatePdf,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.teal.shade600,
                                foregroundColor: Colors.white,
                              ),
                              icon: const Icon(Icons.picture_as_pdf),
                              label: const Text('Generate PDF'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Existing Reports',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _controller.getReportsStream(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Center(child: Text('No reports available.'));
                              }
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final doc = snapshot.data!.docs[index];
                                  final data = doc.data() as Map<String, dynamic>;
                                  final patientName = data['patient_name']?.toString() ?? 'Unknown';
                                  final testType = data['test_type']?.toString() ?? 'Unknown';
                                  final labTechnician = data['lab_technician']?.toString() ?? 'Unknown';
                                  final createdAt = (data['created_at'] as Timestamp?)?.toDate();
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    child: ListTile(
                                      title: Text('Patient: $patientName'),
                                      subtitle: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Test: $testType'),
                                          Text('Technician: $labTechnician'),
                                          if (createdAt != null)
                                            Text(
                                              'Date: ${createdAt.toString().split(' ')[0]}',
                                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                    color: Colors.grey,
                                                  ),
                                            ),
                                        ],
                                      ),
                                      trailing: PopupMenuButton(
                                        onSelected: (value) {
                                          if (value == 'pdf') {
                                            _generatePdfForReport(doc.id, data);
                                          } else if (value == 'delete') {
                                            _deleteReport(doc.id);
                                          }
                                        },
                                        itemBuilder: (context) => [
                                          const PopupMenuItem(
                                              value: 'pdf',
                                              child: Row(children: [
                                                Icon(Icons.picture_as_pdf),
                                                SizedBox(width: 10),
                                                Text('Generate PDF')
                                              ])),
                                          const PopupMenuItem(
                                              value: 'delete',
                                              child: Row(children: [
                                                Icon(Icons.delete, color: Colors.red),
                                                SizedBox(width: 10),
                                                Text('Delete', style: TextStyle(color: Colors.red))
                                              ])),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _generateAndSaveReport() {
    final patientName = _patientNameController.text.trim();
    final testType = _testTypeController.text.trim();
    final labTechnician = _labTechnicianController.text.trim();
    final results = _resultsController.text.trim();

    if (patientName.isEmpty || testType.isEmpty || labTechnician.isEmpty || results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields.')),
      );
      return;
    }

    final reportData = {
      'patient_name': patientName,
      'test_type': testType,
      'lab_technician': labTechnician,
      'results': results,
    };

    _controller.addReport(reportData).then((_) {
      _patientNameController.clear();
      _testTypeController.clear();
      _labTechnicianController.clear();
      _resultsController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report saved successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving report: $error')),
      );
    });
  }

  void _generatePdf() {
    final patientName = _patientNameController.text.trim();
    final testType = _testTypeController.text.trim();
    final labTechnician = _labTechnicianController.text.trim();
    final results = _resultsController.text.trim();

    if (patientName.isEmpty || testType.isEmpty || labTechnician.isEmpty || results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields to generate PDF.')),
      );
      return;
    }

    final reportData = {
      'patient_name': patientName,
      'test_type': testType,
      'lab_technician': labTechnician,
      'results': results,
      'created_at': Timestamp.now(),
    };

    _controller.generatePdf(reportData).then((pdfBytes) {
      Printing.layoutPdf(onLayout: (_) async => pdfBytes);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $error')),
      );
    });
  }

  void _generatePdfForReport(String docId, Map<String, dynamic> reportData) {
    _controller.generatePdf(reportData).then((pdfBytes) {
      Printing.layoutPdf(onLayout: (_) async => pdfBytes);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error generating PDF: $error')),
      );
    });
  }

  void _deleteReport(String docId) {
    _controller.deleteReport(docId).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Report deleted successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting report: $error')),
      );
    });
  }

  @override
  void dispose() {
    _patientNameController.dispose();
    _testTypeController.dispose();
    _labTechnicianController.dispose();
    _resultsController.dispose();
    super.dispose();
  }
}