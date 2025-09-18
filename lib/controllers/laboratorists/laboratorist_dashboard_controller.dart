import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/auth_controller.dart';
import 'package:hsmproject/controllers/pharmacist/language_controller.dart';

class LaboratoristDashboardController extends GetxController {
  final AuthController authController = Get.find<AuthController>();
  final LanguageController langController = Get.put(LanguageController());

  final menuItems = [
    {'key': 'manage_blood', 'icon': Icons.bloodtype, 'route': '/laboratorist/blood_bank'},
    {'key': 'view_payrolls', 'icon': Icons.account_balance_wallet, 'route': '/laboratorist/payrolls'},
    {'key': 'manage_reports', 'icon': Icons.description, 'route': '/laboratorist/reports'},
    {'key': 'latest_notices', 'icon': Icons.notifications, 'route': '/laboratorist/notices'},
  ].obs;

  void navigateTo(String route) {
    Get.toNamed(route);
  }

  Future<void> signOut() async {
    await authController.signOut();
    Get.offAllNamed('/laboratorist-login');
  }

  String getTitle(String key) {
    switch (key) {
      case 'manage_blood':
        return langController.getText(
            en: 'Manage Blood Bank', mr: 'रक्त बँक व्यवस्थापन', hi: 'ब्लड बैंक प्रबंध');
      case 'view_payrolls':
        return langController.getText(
            en: 'View Payrolls', mr: 'पेरोल पहा', hi: 'पेरोल देखें');
      case 'manage_reports':
        return langController.getText(
            en: 'Manage Reports', mr: 'अहवाल व्यवस्थापित करा', hi: 'रिपोर्ट प्रबंध');
      case 'latest_notices':
        return langController.getText(
            en: 'Latest Notices', mr: 'ताजी सूचना', hi: 'नवीन नोटिस');
      default:
        return '';
    }
  }

  String getSubtitle(String key) {
    switch (key) {
      case 'manage_blood':
        return langController.getText(
            en: 'Manage blood inventory and requests',
            mr: 'रक्ताचा साठा आणि विनंत्या व्यवस्थापित करा',
            hi: 'ब्लड इन्वेंट्री और अनुरोध प्रबंधित करें');
      case 'view_payrolls':
        return langController.getText(
            en: 'View your salary and payment details',
            mr: 'आपली पगार आणि पेमेंट तपशील पहा',
            hi: 'अपनी वेतन और भुगतान विवरण देखें');
      case 'manage_reports':
        return langController.getText(
            en: 'Generate and view lab reports',
            mr: 'लॅब अहवाल तयार करा आणि पहा',
            hi: 'लैब रिपोर्ट उत्पन्न और देखें');
      case 'latest_notices':
        return langController.getText(
            en: 'Check the latest updates and notices',
            mr: 'ताजी अद्यतने आणि सूचना पहा',
            hi: 'नवीन अपडेट और नोटिस देखें');
      default:
        return '';
    }
  }

  String getRecentNotice() {
    return langController.getText(
      en: 'Lab equipment maintenance scheduled for next week.',
      mr: 'पुढील आठवड्यासाठी प्रयोगशाळा उपकरणांची देखभाल शेड्यूल केलेली आहे.',
      hi: 'अगले सप्ताह के लिए लैब उपकरणों का रखरखाव निर्धारित है।',
    );
  }
}
