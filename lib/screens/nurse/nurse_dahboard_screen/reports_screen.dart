import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hsmproject/controllers/auth_controller.dart';

class NurseReportsScreen extends StatelessWidget {
  const NurseReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              const Color(0xFF0077B6).withOpacity(0.1),
              Colors.white,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'All Patient Reports',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF023E8A),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: _firestore.collection('lab_reports').orderBy('created_at', descending: true).snapshots(),
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

                    // Get reports from lab_reports collection
                    List<Map<String, dynamic>> allReports = [];
                    for (var doc in snapshot.data!.docs) {
                      final data = doc.data() as Map<String, dynamic>;
                      data['doc_id'] = doc.id;
                      data['collection'] = 'lab_reports';
                      allReports.add(data);
                    }

                    return ListView.builder(
                      itemCount: allReports.length,
                      itemBuilder: (context, index) {
                        final report = allReports[index];
                        final patientName = report['patient_name']?.toString() ?? 'Unknown';
                        final reportType = report['test_type']?.toString() ?? 'Unknown';
                        final createdAt = (report['created_at'] as Timestamp?)?.toDate();
                        final source = 'Lab Report';

                        return _buildReportCard(
                          title: 'Patient: $patientName - $reportType',
                          date: createdAt != null ? createdAt.toString().split(' ')[0] : 'Unknown',
                          source: source,
                          data: report,
                          context: context,  // Pass context to avoid access issues
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
    );
  }

  Widget _buildReportCard({
    required String title,
    required String date,
    required String source,
    required Map<String, dynamic> data,
    required BuildContext context,  
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(
          Icons.science,
          color: Color(0xFF0077B6),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('Generated: $date ($source)'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          _viewReportDetails(context, data, source);
        },
      ),
    );
  }

  void _viewReportDetails(BuildContext context, Map<String, dynamic> data, String source) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$source Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Patient Name', data['patient_name'] ?? 'N/A'),
              _buildDetailRow('Test Type', data['test_type'] ?? 'N/A'),
              _buildDetailRow('Lab Technician', data['lab_technician'] ?? 'N/A'),
              _buildDetailRow('Results', data['results'] ?? 'N/A'),
              if (data['created_at'] != null)
                _buildDetailRow('Date', (data['created_at'] as Timestamp).toDate().toString().split(' ')[0]),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.w500, color: Color(0xFF0077B6)),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}