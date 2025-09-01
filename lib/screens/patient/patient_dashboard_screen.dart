import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class PatientDashboardController extends GetxController {
  var selectedIndex = 0.obs;
  final user = FirebaseAuth.instance.currentUser;

  void changeSection(int index) {
    selectedIndex.value = index;
    FirebaseAnalytics.instance.logEvent(
      name: 'section_changed',
      parameters: {'section_index': index, 'patient_id': user!.uid},
    );
  }
}

class PatientDashboardScreen extends StatelessWidget {
  final controller = Get.put(PatientDashboardController());

  PatientDashboardScreen({super.key});

  // List of section widgets
  List<Widget> _getSectionWidgets(DocumentSnapshot patientData) => [
        ProfileSection(patientData: patientData)
            .animate()
            .fadeIn(duration: 500.ms),
        AppointmentsSection().animate().slideY(begin: 0.2, end: 0, duration: 500.ms),
        PrescriptionsSection().animate().slideY(begin: 0.2, end: 0, duration: 500.ms),
        DoctorDetailsSection().animate().slideY(begin: 0.2, end: 0, duration: 500.ms),
        AdminOperationHistorySection()
            .animate()
            .slideY(begin: 0.2, end: 0, duration: 500.ms),
        InvoicesSection().animate().slideY(begin: 0.2, end: 0, duration: 500.ms),
        DocumentsSection().animate().slideY(begin: 0.2, end: 0, duration: 500.ms),
        NoticesSection().animate().slideY(begin: 0.2, end: 0, duration: 500.ms),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Patient Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed('/login');
                Get.snackbar('Success', 'Logged out successfully');
                FirebaseAnalytics.instance.logEvent(name: 'logout', parameters: {'patient_id': controller.user!.uid});
              } catch (e) {
                Get.snackbar('Error', 'Failed to log out');
              }
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.teal.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, size: 40, color: Colors.teal),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Patient Dashboard',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                  Text(
                    controller.user?.email ?? 'Guest',
                    style: TextStyle(color: Colors.white70, fontSize: 16),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.person, color: controller.selectedIndex.value == 0 ? Colors.teal : Colors.grey),
              title: Text('Profile', style: TextStyle(color: controller.selectedIndex.value == 0 ? Colors.teal : Colors.black)),
              selected: controller.selectedIndex.value == 0,
              onTap: () {
                controller.changeSection(0);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today, color: controller.selectedIndex.value == 1 ? Colors.teal : Colors.grey),
              title: Text('Appointments', style: TextStyle(color: controller.selectedIndex.value == 1 ? Colors.teal : Colors.black)),
              selected: controller.selectedIndex.value == 1,
              onTap: () {
                controller.changeSection(1);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.medical_services, color: controller.selectedIndex.value == 2 ? Colors.teal : Colors.grey),
              title: Text('Prescriptions', style: TextStyle(color: controller.selectedIndex.value == 2 ? Colors.teal : Colors.black)),
              selected: controller.selectedIndex.value == 2,
              onTap: () {
                controller.changeSection(2);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add_alt_1, color: controller.selectedIndex.value == 3 ? Colors.teal : Colors.grey),
              title: Text('Doctor Details', style: TextStyle(color: controller.selectedIndex.value == 3 ? Colors.teal : Colors.black)),
              selected: controller.selectedIndex.value == 3,
              onTap: () {
                controller.changeSection(3);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.history, color: controller.selectedIndex.value == 4 ? Colors.teal : Colors.grey),
              title: Text('Operation History', style: TextStyle(color: controller.selectedIndex.value == 4 ? Colors.teal : Colors.black)),
              selected: controller.selectedIndex.value == 4,
              onTap: () {
                controller.changeSection(4);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.receipt, color: controller.selectedIndex.value == 5 ? Colors.teal : Colors.grey),
              title: Text('Invoices & Bills', style: TextStyle(color: controller.selectedIndex.value == 5 ? Colors.teal : Colors.black)),
              selected: controller.selectedIndex.value == 5,
              onTap: () {
                controller.changeSection(5);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.description, color: controller.selectedIndex.value == 6 ? Colors.teal : Colors.grey),
              title: Text('Documents', style: TextStyle(color: controller.selectedIndex.value == 6 ? Colors.teal : Colors.black)),
              selected: controller.selectedIndex.value == 6,
              onTap: () {
                controller.changeSection(6);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.notification_important, color: controller.selectedIndex.value == 7 ? Colors.teal : Colors.grey),
              title: Text('Latest Notice', style: TextStyle(color: controller.selectedIndex.value == 7 ? Colors.teal : Colors.black)),
              selected: controller.selectedIndex.value == 7,
              onTap: () {
                controller.changeSection(7);
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                Get.offAllNamed('/login');
                Get.snackbar('Success', 'Logged out successfully');
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeSection,
          selectedItemColor: Colors.teal,
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.calendar_today), label: 'Appointments'),
            BottomNavigationBarItem(icon: Icon(Icons.medical_services), label: 'Prescriptions'),
            BottomNavigationBarItem(icon: Icon(Icons.description), label: 'Documents'),
          ],
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: FirebaseFirestore.instance.collection('patients').doc(controller.user!.uid).get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Error loading patient data'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return const Center(child: Text('No patient data found'));
          }
          return Obx(() => SizedBox(
                height: MediaQuery.of(context).size.height,
                child: _getSectionWidgets(snapshot.data!)[controller.selectedIndex.value],
              ));
        },
      ),
    );
  }
}

// Profile Section
class ProfileSection extends StatelessWidget {
  final DocumentSnapshot patientData;
  const ProfileSection({required this.patientData, super.key});

  @override
  Widget build(BuildContext context) {
    final data = patientData.data() as Map<String, dynamic>? ?? {};
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.teal,
                child: Text(
                  data['name']?.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Welcome, ${data['name'] ?? 'User'}',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Age: ${data['age'] ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
          Text('Condition: ${data['condition'] ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
          Text('Email: ${data['email'] ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
          Text('Contact Number: ${data['contact_number'] ?? 'N/A'}', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            icon: const Icon(Icons.calendar_today),
            label: const Text('Book New Appointment'),
            onPressed: () {
              Get.toNamed('/book_appointment');
              FirebaseAnalytics.instance.logEvent(name: 'book_appointment_clicked', parameters: {'patient_id': FirebaseAuth.instance.currentUser!.uid});
            },
          ),
        ],
      ),
    );
  }
}

// Appointments Section
class AppointmentsSection extends StatelessWidget {
  final controller = Get.find<PatientDashboardController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('appointments')
          .where('patientId', isEqualTo: controller.user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading appointments'));
        }
        final appointments = snapshot.data?.docs ?? [];
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appointment = appointments[index].data() as Map<String, dynamic>;
            return Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text('Appointment with ${appointment['doctorName'] ?? 'Unknown'}'),
                  subtitle: Text('Date: ${appointment['date'] ?? 'N/A'} | Time: ${appointment['time'] ?? 'N/A'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () async {
                      try {
                        await FirebaseFirestore.instance
                            .collection('appointments')
                            .doc(appointments[index].id)
                            .delete();
                        Get.snackbar('Success', 'Appointment cancelled');
                        FirebaseAnalytics.instance.logEvent(name: 'appointment_cancelled', parameters: {'appointment_id': appointments[index].id});
                      } catch (e) {
                        Get.snackbar('Error', 'Failed to cancel appointment');
                      }
                    },
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Prescriptions Section
class PrescriptionsSection extends StatelessWidget {
  final controller = Get.find<PatientDashboardController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('prescriptions')
          .where('patientId', isEqualTo: controller.user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading prescriptions'));
        }
        final prescriptions = snapshot.data?.docs ?? [];
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: prescriptions.length,
          itemBuilder: (context, index) {
            final prescription = prescriptions[index].data() as Map<String, dynamic>;
            return Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text('Prescription from ${prescription['doctorName'] ?? 'Unknown'}'),
                  subtitle: Text('Medication: ${prescription['medication'] ?? 'N/A'}'),
                  onTap: () => Get.toNamed('/prescription_details', arguments: prescription),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Doctor Details Section
class DoctorDetailsSection extends StatelessWidget {
  final controller = Get.find<PatientDashboardController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('doctors')
          .where('patients', arrayContains: controller.user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading doctor details'));
        }
        final doctors = snapshot.data?.docs ?? [];
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: doctors.length,
          itemBuilder: (context, index) {
            final doctor = doctors[index].data() as Map<String, dynamic>;
            return Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text('Dr. ${doctor['name'] ?? 'Unknown'}'),
                  subtitle: Text('Specialty: ${doctor['specialty'] ?? 'N/A'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.info, color: Colors.teal),
                    onPressed: () => Get.toNamed('/doctor_details', arguments: doctors[index].id),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Admin Operation History Section
class AdminOperationHistorySection extends StatelessWidget {
  final controller = Get.find<PatientDashboardController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('operation_history')
          .where('patientId', isEqualTo: controller.user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading operation history'));
        }
        final operations = snapshot.data?.docs ?? [];
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: operations.length,
          itemBuilder: (context, index) {
            final operation = operations[index].data() as Map<String, dynamic>;
            return Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text('Operation: ${operation['type'] ?? 'N/A'}'),
                  subtitle: Text('Date: ${operation['date'] ?? 'System: N/A'}'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Invoices Section
class InvoicesSection extends StatelessWidget {
  final controller = Get.find<PatientDashboardController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('invoices')
          .where('patientId', isEqualTo: controller.user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading invoices'));
        }
        final invoices = snapshot.data?.docs ?? [];
        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: invoices.length,
          itemBuilder: (context, index) {
            final invoice = invoices[index].data() as Map<String, dynamic>;
            return Card(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.teal.shade50, Colors.white],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  title: Text('Invoice #${invoice['invoiceId'] ?? 'N/A'}'),
                  subtitle: Text('Amount: \$${invoice['amount'] ?? '0'} | Date: ${invoice['date'] ?? 'N/A'}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.download, color: Colors.teal),
                    onPressed: () => Get.toNamed('/invoice_details', arguments: invoice),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

// Documents Section
class DocumentsSection extends StatelessWidget {
  final controller = Get.find<PatientDashboardController>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('documents')
          .where('patientId', isEqualTo: controller.user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading documents'));
        }
        final documents = snapshot.data?.docs ?? [];
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton.icon(
                icon: const Icon(Icons.add),
                label: const Text('Create New Document'),
                onPressed: () => Get.toNamed('/create_document'),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: documents.length,
                itemBuilder: (context, index) {
                  final document = documents[index].data() as Map<String, dynamic>;
                  return Card(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.teal.shade50, Colors.white],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text(document['title'] ?? 'Untitled'),
                        subtitle: Text('Created: ${document['createdAt'] ?? 'N/A'}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.download, color: Colors.teal),
                          onPressed: () => Get.toNamed('/document_details', arguments: document),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

// Notices Section
class NoticesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('notices')
          .orderBy('createdAt', descending: true)
          .limit(1)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text('Error loading notices'));
        }
        final notices = snapshot.data?.docs ?? [];
        if (notices.isEmpty) {
          return const Center(child: Text('No notices available'));
        }
        final notice = notices[0].data() as Map<String, dynamic>;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal.shade50, Colors.white],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                title: Text(notice['title'] ?? 'No Title'),
                subtitle: Text(notice['content'] ?? 'No Content'),
                trailing: Text(notice['createdAt'] ?? 'N/A'),
              ),
            ),
          ),
        );
      },
    );
  }
}