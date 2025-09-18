import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardController extends GetxController {
  // Reactive variable for the current bottom navigation bar index
  var currentIndex = 0.obs;

  // Reactive variable for the latest notice
  var latestNotice = 'Fetching notices...'.obs;

  // Reactive variable for loading state
  var isLoadingNotices = true.obs;

  // Reactive variables for counts (e.g., for dashboard stats)
  var appointmentCount = 0.obs;
  var admissionCount = 0.obs;
  var bedCount = 0.obs;
  var prescriptionCount = 0.obs;
  var reportCount = 0.obs;

  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  get admissions => null;

  get doctors => null;

  get nurses => null;

  get receptionists => null;

  get laboratorists => null;

  get pharmacists => null;

  get accountants => null;

  get departments => null;

  get appointments => null;

  get notices => null;

  @override
  void onInit() {
    super.onInit();
    // Fetch dashboard data and notices when the controller is initialized
    fetchDashboardData();
    fetchNotices();
  }

  // Fetch notices from Firestore
  Future<void> fetchNotices() async {
    try {
      isLoadingNotices.value = true; // Set loading to true
      // Query the 'notices' collection, order by timestamp, and limit to the latest notice
      QuerySnapshot querySnapshot = await _firestore
          .collection('notices')
          .orderBy('timestamp', descending: true)
          .limit(1) // Limit to the latest notice
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        var noticeData = querySnapshot.docs.first.data() as Map<String, dynamic>?;
        latestNotice.value = noticeData?['message'] ?? 'No notice available';
      } else {
        latestNotice.value = 'No notices available';
      }
    } catch (e) {
      print('Error fetching notices: $e');
      latestNotice.value = 'Error fetching notices';
      Get.snackbar('Error', 'Failed to fetch notices: $e');
    } finally {
      isLoadingNotices.value = false; // Set loading to false
    }
  }

  // Simulate fetching dashboard data (replace with actual API calls)
  void fetchDashboardData() {
    // Mock data for demonstration; replace with real API calls
    appointmentCount.value = 12;
    admissionCount.value = 5;
    bedCount.value = 8;
    prescriptionCount.value = 20;
    reportCount.value = 15;
  }

  // Handle bottom navigation bar index changes
  void changeTabIndex(int index) {
    currentIndex.value = index;
    switch (index) {
      case 0:
        Get.toNamed('/dashboard');
        break;
      case 1:
        Get.toNamed('/profile');
        break;
      case 2:
        Get.toNamed('/settings');
        break;
    }
  }

  // Methods for handling dashboard actions (placeholders)
  void manageAppointments() => Get.toNamed('/appointments');
  void manageAdmissions() => Get.toNamed('/admissions');
  void manageBeds() => Get.toNamed('/bed-management');
  void managePrescriptions() => Get.toNamed('/prescriptions');
  void manageReports() => Get.toNamed('/reports');
  void accessPayroll() => Get.toNamed('/payroll');
  void manageSchedules() => Get.toNamed('/schedules');
  void manageDocuments() => Get.toNamed('/documents');
  void viewNotices() => Get.toNamed('/notices');
}