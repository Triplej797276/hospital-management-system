import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/bed_controller.dart';
import 'package:hsmproject/screens/case_manager/AddCaseManagerScreen.dart';
import 'package:hsmproject/screens/case_manager/CaseManagerLoginScreen.dart';
import 'package:hsmproject/screens/case_manager/case_manager_dashboard_screen.dart';
import 'package:hsmproject/screens/login_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_login_screen.dart';
import 'firebase_options.dart';
import 'screens/auth_wrapper.dart';
import 'screens/doctor/dr_screen/appointment.dart';
import 'screens/doctor/dr_screen/admission.dart';
import 'screens/doctor/doctor_login_screen.dart';
import 'screens/doctor/dr_screen/bed.dart';
import 'screens/doctor/dr_screen/prescription.dart';
import 'screens/doctor/dr_screen/report.dart';
import 'screens/doctor/dr_screen/payroll.dart';
import 'screens/doctor/dr_screen/schedule.dart';
import 'screens/doctor/dr_screen/document.dart';
import 'screens/doctor/dr_screen/notice.dart';
import 'screens/doctor/dr_screen/profile.dart' hide AuthController;
import 'screens/doctor/dr_screen/setting.dart';
import 'screens/doctor/dashboard_screen.dart';
import 'screens/accountant/accountant_list_screen.dart';
import 'screens/accountant/accountant_login_screen.dart';
import 'screens/accountant/accountant_dashboard_screen.dart';
import 'screens/home_screen.dart';
import 'screens/pharmacist/pharmacist_screen/medicine_bills_screen.dart';
import 'screens/pharmacist/pharmacist_screen/medicine_categories_screen.dart';
import 'screens/pharmacist/pharmacist_screen/medicines_screen.dart';
import 'screens/pharmacist/pharmacist_screen/notices_screen.dart';
import 'screens/pharmacist/pharmacist_screen/payrolls_screen.dart';
import 'screens/pharmacist/pharmacist_screen/profile_screen.dart';
import 'screens/role_selection_screen.dart';
import 'screens/receptionist/receptionist_dashboard_screen.dart';
import 'screens/receptionist/receptionist_screen/appointment_management_screen.dart';
import 'screens/receptionist/receptionist_screen/requested_appointments_screen.dart';
import 'screens/receptionist/receptionist_screen/patient_list_screen.dart';
import 'screens/receptionist/receptionist_screen/payroll_screen.dart';
import 'screens/receptionist/receptionist_screen/mail_service_screen.dart';
import 'screens/receptionist/receptionist_screen/patient_cases_screen.dart';
import 'screens/receptionist/receptionist_screen/services_management_screen.dart';
import 'screens/receptionist/receptionist_screen/notice_board_screen.dart';
import 'screens/receptionist/receptionist_screen/profile_settings_screen.dart';
import 'screens/laboratorist/laboratorist_login_screen.dart';
import 'screens/laboratorist/add_laboratorist_screen.dart';
import 'screens/laboratorist/laboratorist_dashboard_screen.dart';
import 'screens/pharmacist/pharmacist_login_screen.dart';
import 'screens/pharmacist/add_pharmacist_screen.dart';
import 'screens/pharmacist/pharmacist_dashboard_screen.dart';
import 'screens/nurse/nurse_dahboard_screen/patient_list_screen.dart';
import 'screens/nurse/nurse_dahboard_screen/bed_management_screen.dart';
import 'screens/nurse/nurse_dahboard_screen/bed_allocation_screen.dart';
import 'screens/nurse/nurse_dahboard_screen/reports_screen.dart';
import 'screens/nurse/nurse_dahboard_screen/payrolls_screen.dart';
import 'screens/nurse/nurse_dahboard_screen/notices_screen.dart';
import 'screens/nurse/nurse_login_screen.dart';
import 'screens/patient/patient_login_screen.dart';
import 'screens/patient/patient_dashboard_screen.dart';
import 'screens/patient/add_patient_screen.dart';
import 'controllers/auth_controller.dart';

// Placeholder screens for accountant routes
class InvoicesScreen extends StatelessWidget {
  const InvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Invoices')),
      body: const Center(child: Text('Invoices Screen')),
    );
  }
}

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Payments')),
      body: const Center(child: Text('Payments Screen')),
    );
  }
}

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      body: const Center(child: Text('Accounts Screen')),
    );
  }
}

// Placeholder screens for patient-related routes
class BookAppointmentScreen extends StatelessWidget {
  const BookAppointmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Book Appointment')),
      body: const Center(child: Text('Book Appointment Screen')),
    );
  }
}

class PrescriptionDetailsScreen extends StatelessWidget {
  const PrescriptionDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prescription = Get.arguments as Map<String, dynamic>? ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Prescription Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Doctor: ${prescription['doctorName'] ?? 'Unknown'}'),
            Text('Medication: ${prescription['medication'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorId = Get.arguments as String? ?? 'Unknown';
    return Scaffold(
      appBar: AppBar(title: const Text('Doctor Details')),
      body: Center(child: Text('Doctor ID: $doctorId')),
    );
  }
}

class InvoiceDetailsScreen extends StatelessWidget {
  const InvoiceDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invoice = Get.arguments as Map<String, dynamic>? ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Invoice Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Invoice #${invoice['invoiceId'] ?? 'N/A'}'),
            Text('Amount: \$${invoice['amount'] ?? '0'}'),
            Text('Date: ${invoice['date'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}

class CreateDocumentScreen extends StatelessWidget {
  const CreateDocumentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Document')),
      body: const Center(child: Text('Create Document Screen')),
    );
  }
}

class DocumentDetailsScreen extends StatelessWidget {
  const DocumentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final document = Get.arguments as Map<String, dynamic>? ?? {};
    return Scaffold(
      appBar: AppBar(title: const Text('Document Details')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Title: ${document['title'] ?? 'Untitled'}'),
            Text('Created: ${document['createdAt'] ?? 'N/A'}'),
          ],
        ),
      ),
    );
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());

    return GetMaterialApp(
      title: 'Hospital Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const AuthWrapper(),
      getPages: [
        GetPage(name: '/', page: () => const AuthWrapper()),
        GetPage(name: '/role-selection', page: () => const RoleSelectionScreen()),
        GetPage(name: '/doctor-login', page: () => const DoctorLoginScreen()),
        GetPage(name: '/admin-login', page: () => const LoginScreen()),
        GetPage(name: '/receptionist-login', page: () => const ReceptionistLoginScreen()),
        GetPage(name: '/patient-login', page: () => const PatientLoginScreen()),
        GetPage(name: '/nurse-login', page: () =>  NurseLoginScreen()),
        GetPage(name: '/accountant_login', page: () => const AccountantLoginScreen()),
        GetPage(name: '/laboratorist_login', page: () => const LaboratoristLoginScreen()),
        GetPage(name: '/pharmacist_login', page: () => const PharmacistLoginScreen()),
        GetPage(name: '/case_manager_login', page: () => const CaseManagerLoginScreen()),
        
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/appointment', page: () =>  AppointmentsScreen()),
        GetPage(name: '/admission', page: () =>  AdmissionsScreen()),
        GetPage(name: '/bed', page: () =>  BedManagementScreen()),
        GetPage(name: '/prescription', page: () =>  PrescriptionsScreen()),
        GetPage(name: '/report', page: () =>  ReportsScreen()),
        GetPage(name: '/payroll', page: () => const PayrollsScreen()),
        GetPage(name: '/schedule', page: () =>  SchedulesScreen()),
        GetPage(name: '/document', page: () =>  DocumentsScreen()),
        GetPage(name: '/notices', page: () =>  NoticesScreen()),
        GetPage(name: '/profile', page: () =>  ProfileScreen()),
        GetPage(name: '/settings', page: () =>  SettingsScreen()),
        GetPage(name: '/home', page: () =>  HomeScreen()),
        GetPage(name: '/accountant-list', page: () => const AccountantListScreen()),
        GetPage(name: '/accountant_dashboard', page: () => const AccountantDashboardScreen()),
        GetPage(name: '/receptionist', page: () => const ReceptionistDashboardScreen()),
        GetPage(name: '/receptionist/appointments', page: () => const AppointmentManagementScreen()),
        GetPage(name: '/receptionist/requested_appointments', page: () => const RequestedAppointmentsScreen()),
        GetPage(name: '/receptionist/patients', page: () => const PatientListScreen()),
        GetPage(name: '/receptionist/payrolls', page: () => const PayrollsScreen()),
        GetPage(name: '/receptionist/mail_service', page: () => const MailServiceScreen()),
        GetPage(name: '/receptionist/patient_cases', page: () => const PatientCasesScreen()),
        GetPage(name: '/receptionist/services', page: () => const ServicesManagementScreen()),
        GetPage(name: '/receptionist/notice_board', page: () => const NoticeBoardScreen()),
        GetPage(name: '/receptionist/profile_settings', page: () => const ProfileSettingsScreen()),
        GetPage(name: '/invoices', page: () => const InvoicesScreen()),
        GetPage(name: '/payments', page: () => const PaymentsScreen()),
        GetPage(name: '/payrolls', page: () => const PayrollsScreen()),
        GetPage(name: '/accounts', page: () => const AccountsScreen()),
        // Laboratorist Routes
        GetPage(name: '/add_laboratorist', page: () => const AddLaboratoristScreen()),
        GetPage(name: '/laboratorist_dashboard', page: () => const LaboratoristDashboardScreen()),
        // Pharmacist Routes
        GetPage(name: '/add_pharmacist', page: () => const AddPharmacistScreen()),
        GetPage(name: '/pharmacist_dashboard', page: () => const PharmacistDashboardScreen()),
        GetPage(name: '/pharmacist/medicine-categories', page: () => const MedicineCategoriesScreen()),
        GetPage(name: '/pharmacist/medicines', page: () => const MedicinesScreen()),
        GetPage(name: '/pharmacist/medicine-bills', page: () => const MedicineBillsScreen()),
        GetPage(name: '/pharmacist/payrolls', page: () => const PharmacistPayrollsScreen()),
        GetPage(name: '/notices', page: () => const PharmacistNoticesScreen()),
        GetPage(name: '/profile', page: () => const PharmacistProfileScreen()),
        // Nurse Routes
        GetPage(name: '/nurse/patientList', page: () => const NursePatientListScreen()),
        GetPage(name: '/nurse/bedManagement', page: () => const NurseBedManagementScreen()),
        GetPage(name: '/nurse/bedAllocation', page: () => const BedAllocationScreen()),
        GetPage(name: '/nurse/reports', page: () => const NurseReportsScreen()),
        GetPage(name: '/nurse/payrolls', page: () => const NursePayrollsScreen()),
        GetPage(name: '/nurse/notices', page: () => const NurseNoticesScreen()),
        // Patient Routes
        GetPage(name: '/patient_dashboard', page: () =>  PatientDashboardScreen()),
        GetPage(name: '/add_patient', page: () => const AddPatientScreen()),
        // Added Patient Routes
        GetPage(name: '/book_appointment', page: () => const BookAppointmentScreen()),
        GetPage(name: '/prescription_details', page: () => const PrescriptionDetailsScreen()),
        GetPage(name: '/doctor_details', page: () => const DoctorDetailsScreen()),
        GetPage(name: '/invoice_details', page: () => const InvoiceDetailsScreen()),
        GetPage(name: '/create_document', page: () => const CreateDocumentScreen()),
        GetPage(name: '/document_details', page: () => const DocumentDetailsScreen()),

        //case manager
     GetPage(name: '/case_manager_register', page: () => const AddCaseManagerScreen()),
     GetPage(name: '/case_manager_dashboard', page: () => const CaseManagerDashboardScreen()),

      ],
    );
  }
}