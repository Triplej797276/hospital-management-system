import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/auth_controller.dart';
import 'package:hsmproject/controllers/bed_controller.dart';
import 'package:hsmproject/controllers/patients/patient_controller.dart';
import 'package:hsmproject/screens/accountant/accountant_bills_screen.dart';
import 'package:hsmproject/screens/accountant/accountant_invoices_screen.dart';
import 'package:hsmproject/screens/accountant/accountant_payments_screen.dart';
import 'package:hsmproject/screens/accountant/accountant_payrolls_screen.dart';
import 'package:hsmproject/screens/accountant/accountants_screen.dart';
import 'package:hsmproject/screens/auth_wrapper.dart';
import 'package:hsmproject/screens/case_manager/add_casemanager_screen.dart';
import 'package:hsmproject/screens/case_manager/casemanager_loginscreen.dart';
import 'package:hsmproject/screens/case_manager/case_manager_dashboard_screen.dart';
import 'package:hsmproject/screens/case_manager/screens/ambulance_management_screen.dart';
import 'package:hsmproject/screens/case_manager/screens/patient_admissions_screen.dart';
import 'package:hsmproject/screens/dr_screen/admission.dart';
import 'package:hsmproject/screens/dr_screen/appointment.dart';
import 'package:hsmproject/screens/dr_screen/bed.dart';
import 'package:hsmproject/screens/dr_screen/doctor_profile.dart';
import 'package:hsmproject/screens/dr_screen/document.dart';
import 'package:hsmproject/screens/dr_screen/notice.dart';
import 'package:hsmproject/screens/dr_screen/payroll.dart';
import 'package:hsmproject/screens/dr_screen/prescription.dart';
import 'package:hsmproject/screens/dr_screen/profile.dart';
import 'package:hsmproject/screens/dr_screen/report.dart';
import 'package:hsmproject/screens/dr_screen/schedule.dart';
import 'package:hsmproject/screens/dr_screen/setting.dart';
import 'package:hsmproject/screens/doctor/dashboard_screen.dart';
import 'package:hsmproject/screens/doctor/doctor_login_screen.dart';
import 'package:hsmproject/screens/accountant/accountant_dashboard_screen.dart';
import 'package:hsmproject/screens/admin/accountant_list_screen.dart';
import 'package:hsmproject/screens/accountant/accountant_login_screen.dart';
import 'package:hsmproject/screens/home_screen.dart';
import 'package:hsmproject/screens/laboratorist/add_laboratorist_screen.dart';

import 'package:hsmproject/screens/laboratorist/laboratorist_dashboard_screen.dart';
import 'package:hsmproject/screens/laboratorist/laboratorist_login_screen.dart';
import 'package:hsmproject/screens/laboratorist/laboratorist_payrolls_screen.dart';

import 'package:hsmproject/screens/login_screen.dart';
import 'package:hsmproject/screens/nurse/nurse_dahboard_screen/bed_allocation_screen.dart';
import 'package:hsmproject/screens/nurse/nurse_dahboard_screen/bed_management_screen.dart';
import 'package:hsmproject/screens/nurse/nurse_dahboard_screen/notices_screen.dart';
import 'package:hsmproject/screens/nurse/nurse_dahboard_screen/payrolls_screen.dart';
import 'package:hsmproject/screens/nurse/nurse_dahboard_screen/patient_list_screen.dart';
import 'package:hsmproject/screens/nurse/nurse_dahboard_screen/reports_screen.dart';
import 'package:hsmproject/screens/nurse/nurse_dashboard_screen.dart';
import 'package:hsmproject/screens/nurse/nurse_login_screen.dart';
import 'package:hsmproject/screens/patient/add_patient_screen.dart';
import 'package:hsmproject/screens/patient/patient_dashboard_screen.dart';
import 'package:hsmproject/screens/patient/patient_login_screen.dart';
import 'package:hsmproject/screens/patient/patient_screen/prescription_details_screen.dart';
import 'package:hsmproject/screens/pharmacist/add_pharmacist_screen.dart';
import 'package:hsmproject/screens/pharmacist/pharmacist_dashboard_screen.dart';
import 'package:hsmproject/screens/pharmacist/pharmacist_login_screen.dart';
import 'package:hsmproject/screens/pharmacist/pharmacist_screen/medicine_bills_screen.dart';
import 'package:hsmproject/screens/pharmacist/pharmacist_screen/medicine_categories_screen.dart';
import 'package:hsmproject/screens/pharmacist/pharmacist_screen/medicines_screen.dart';
import 'package:hsmproject/screens/pharmacist/pharmacist_screen/notices_screen.dart';
import 'package:hsmproject/screens/pharmacist/pharmacist_screen/profile_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_dashboard_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_login_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/ambulance_services_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/appointment_management_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/beds_services_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/blood_bank_inventory_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/emergency_services_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/insurance_services_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/laboratory_services_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/mail_service_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/notice_board_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/packages_services_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/patient_cases_screen.dart';
import 'package:hsmproject/screens/admin/patient_list_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/payroll_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/profile_settings_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/requested_appointments_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_screen/services_management_screen.dart';
import 'package:hsmproject/screens/role_selection_screen.dart';
import 'firebase_options.dart';
import 'screens/laboratorist/laboratorisst_reports_screen.dart';
import 'screens/laboratorist/laboratorist_notices_screen.dart';
import 'screens/laboratorist/laboratorst_blood_bank_screen.dart';
import 'screens/patient/patient_screen/book_appointment_screen.dart';
import 'screens/patient/patient_screen/create_document_screen.dart';
import 'screens/patient/patient_screen/doctor_details_screen.dart';
import 'screens/patient/patient_screen/document_details_screen.dart';
import 'screens/patient/patient_screen/invoice_details_screen.dart';
import 'screens/receptionist/receptionist_screen/pharmacists_services_screen.dart';
import 'screens/receptionist/receptionist_screen/receptionist_patients_screen.dart';


// Bindings for controllers
class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController());
    Get.put(BedController());
    Get.put(PatientController());
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
    return GetMaterialApp(
      title: 'Hospital Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      initialBinding: AppBinding(),
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
        GetPage(name: '/laboratorist-login', page: () => const LaboratoristLoginScreen()),
        GetPage(name: '/pharmacist_login', page: () => const PharmacistLoginScreen()),
        GetPage(name: '/case_manager_login', page: () => const CaseManagerLoginScreen()),
        GetPage(name: '/dashboard', page: () => const DashboardScreen()),
        GetPage(name: '/admission', page: () => const AdmissionsScreen()),
        GetPage(name: '/bed', page: () => const BedManagementScreen()),
        GetPage(name: '/prescription', page: () =>  PrescriptionsScreen()),
        GetPage(name: '/report', page: () =>  ReportsScreen()),
        GetPage(name: '/payroll', page: () => const PayrollsScreen()),
        GetPage(name: '/schedule', page: () =>  SchedulesScreen()),
        GetPage(name: '/document', page: () =>  DocumentsScreen()),
        GetPage(name: '/notices', page: () =>  NoticesScreen()),
        GetPage(name: '/profile', page: () =>  DoctorProfileScreen()),
        GetPage(name: '/settings', page: () =>  SettingsScreen()),
        GetPage(name: '/home', page: () =>  HomeScreen()),
        GetPage(name: '/accountant-list', page: () => const AccountantListScreen()),
        GetPage(name: '/accountant_dashboard', page: () => const AccountantDashboardScreen()),
        GetPage(name: '/prescription_form', page: () =>  PrescriptionForm()),

         GetPage(name: '/accountant/invoice', page: () => const AccountantInvoicesScreen()),
         GetPage(name: '/accountant/bill', page: () => const AccountantBillsScreen()),
         GetPage(name: '/accountant/accountants', page: () => const AccountantsScreen()),
         GetPage(name: '/accountant/payrolls', page: () => const AccountantPayrollsScreen()),
         GetPage(name: '/accountant/payments', page: () => const AccountantPaymentsScreen()),
         
        GetPage(name: '/receptionist', page: () => const ReceptionistDashboardScreen()),
        GetPage(name: '/receptionist/appointments', page: () =>  AppointmentListScreen()),
        GetPage(name: '/receptionist/requested_appointments', page: () => const RequestedAppointmentsScreen()),
        GetPage(name: '/receptionist/patients', page: () => const ReceptionistPatientsScreen()),
       
        
        GetPage(name: '/receptionist/payrolls', page: () => const PayrollsScreen()),
        GetPage(name: '/receptionist/mail_service', page: () => const MailServiceScreen()),
        GetPage(name: '/receptionist/patient_cases', page: () => const PatientCasesScreen()),
        GetPage(name: '/receptionist/services', page: () => const ServicesManagementScreen()),
        GetPage(name: '/receptionist/notice_board', page: () => const ReceptionistNoticesScreen()),
        GetPage(name: '/receptionist/profile_settings', page: () => const ProfileSettingsScreen()),
        GetPage(name: '/ambulance_services', page: () => const AmbulanceServicesScreen()),
        GetPage(name: '/insurance_services', page: () => const InsuranceServicesScreen()),
        GetPage(name: '/packages_services', page: () => const PackagesServicesScreen()),
        GetPage(name: '/laboratory_services', page: () => const LaboratoryServicesScreen()),
        GetPage(name: '/pharmacy_services', page: () => const PharmacistsServicesScreen()),
       
        GetPage(name: '/emergency_services', page: () => const EmergencyServicesScreen()),
        GetPage(name: '/bloodbank_services', page: () => const BloodInventoryScreens()),
        GetPage(name: '/bed_services', page: () => const BedsServicesScreen()),
    
        // GetPage(name: '/invoices', page: () => const InvoicesScreen()),
        // GetPage(name: '/payments', page: () => const PaymentsScreen()),
        // GetPage(name: '/payrolls', page: () => const PayrollsScreen()),
        // GetPage(name: '/accounts', page: () => const AccountsScreen()),
        GetPage(name: '/appointment', page: () =>  AppointmentsDoctorScreen()),
        GetPage(name: '/patient', page: () =>  AdmissionListScreen()),
     
        // Laboratorist Routes
        GetPage(name: '/add_laboratorist', page: () => const AddLaboratoristScreen()),
        GetPage(name: '/laboratorist_dashboard', page: () => const LaboratoristDashboardScreen()),
        GetPage(name: '/laboratorist/blood_bank', page: () => const LaboratoristBloodBankScreen()),
        GetPage(name: '/laboratorist/payrolls', page: () => const LaboratoristPayrollsScreen()),
        GetPage(name: '/laboratorist/reports', page: () => const LaboratoristReportsScreen()),
        GetPage(name: '/laboratorist/notices', page: () => const LaboratoristNoticesScreen()),
   
        // Pharmacist Routes
        GetPage(name: '/add_pharmacist', page: () => const AddPharmacistScreen()),
        GetPage(name: '/pharmacist_dashboard', page: () => const PharmacistDashboardScreen()),
        GetPage(name: '/pharmacist/medicine-categories', page: () => const MedicineCategoriesScreen()),
        GetPage(name: '/pharmacist/medicines', page: () => const MedicinesScreen()),
        GetPage(name: '/pharmacist/medicine-bills', page: () => const MedicineBillsScreen()),
        GetPage(name: '/pharmacist/notices', page: () => const PharmacistNoticesScreen()),
        GetPage(name: '/pharmacist/profile', page: () => const PharmacistProfileScreen()),
        // Nurse Routes
        GetPage(name: '/nurse-dashboard', page: () => const NurseDashboardScreen()),
        GetPage(name: '/nurse/patientList', page: () => const NursePatientListScreen()),
        GetPage(name: '/nurse/bedManagement', page: () => const NurseBedManagementScreen()),
        GetPage(name: '/nurse/bedAllocation', page: () => const BedAllocationScreen()),
        GetPage(name: '/nurse/reports', page: () => const NurseReportsScreen()),
        GetPage(name: '/nurse/payrolls', page: () => const NursePayrollsScreen()),
        GetPage(name: '/nurse/notices', page: () => const NurseNoticesScreen()),
        // Patient Routes
        GetPage(name: '/patient_dashboard', page: () =>  PatientDashboardScreen()),
        GetPage(name: '/add_patient', page: () => const AddPatientScreen()),
        GetPage(name: '/book_appointment', page: () => const BookAppointmentScreen()),
        GetPage(name: '/prescription_details', page: () => const PrescriptionDetailsScreen()),
        GetPage(name: '/doctor_details', page: () => const DoctorDetailsScreen()),
        GetPage(name: '/invoice_details', page: () => const InvoiceDetailsScreen()),
        GetPage(name: '/create_document', page: () => const CreateDocumentScreen()),
        GetPage(name: '/document_details', page: () => const DocumentDetailsScreen()),
        // Case Manager Routes
        GetPage(name: '/case_manager_register', page: () => const AddCaseManagerScreen()),
        GetPage(name: '/case_manager_dashboard', page: () => const CaseManagerDashboardScreen()),
        GetPage(name: '/patient_admissions', page: () => const PatientAdmissionsScreen()),
        GetPage(name: '/patient_cases', page: () => const PatientCasesScreen()),
        GetPage(name: '/ambulance_management', page: () => const AmbulanceManagementScreen()),
        GetPage(name: '/mail_service', page: () => const MailServiceScreen()),
      ],
    );
  }
}