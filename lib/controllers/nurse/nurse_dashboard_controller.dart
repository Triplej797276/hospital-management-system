import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/auth_controller.dart';
import 'package:hsmproject/controllers/pharmacist/language_controller.dart';

class NurseDashboardController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final LanguageController langController = Get.put(LanguageController());

  final menuItems = [
    {'key': 'all_patients', 'icon': Icons.people, 'route': '/nurse/patientList'},
    {'key': 'manage_beds', 'icon': Icons.bed, 'route': '/nurse/bedManagement'},
    {'key': 'allocate_beds', 'icon': Icons.assignment_turned_in, 'route': '/nurse/bedAllocation'},
    {'key': 'reports', 'icon': Icons.bar_chart, 'route': '/nurse/reports'},
    {'key': 'payrolls', 'icon': Icons.account_balance_wallet, 'route': '/nurse/payrolls'},
    {'key': 'latest_notices', 'icon': Icons.announcement, 'route': '/nurse/notices'},
  ].obs;

  void navigateTo(String route) {
    Get.toNamed(route);
  }

  Future<void> signOut() async {
    await authController.signOut();
    Get.offAllNamed('/nurse-login');
  }

  String getTitle(String key) {
    switch (key) {
      case 'all_patients':
        return langController.getText(
            en: 'All Patients', mr: 'सर्व रुग्ण', hi: 'सभी मरीज');
      case 'manage_beds':
        return langController.getText(
            en: 'Manage Beds', mr: 'खाट व्यवस्थापन', hi: 'बेड प्रबंध');
      case 'allocate_beds':
        return langController.getText(
            en: 'Allocate Beds', mr: 'खाट वाटप', hi: 'बेड आवंटित करें');
      case 'reports':
        return langController.getText(
            en: 'Reports', mr: 'अहवाल', hi: 'रिपोर्ट्स');
      case 'payrolls':
        return langController.getText(
            en: 'Payrolls', mr: 'पेरोल', hi: 'पेरोल');
      case 'latest_notices':
        return langController.getText(
            en: 'Latest Notice', mr: 'अलीकडील सूचना', hi: 'नवीन नोटिस');
      default:
        return '';
    }
  }
}
