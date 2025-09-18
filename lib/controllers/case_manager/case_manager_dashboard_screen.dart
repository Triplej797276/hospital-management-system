import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/pharmacist/language_controller.dart';

class CaseManagerDashboardController extends GetxController {
  final LanguageController langController = Get.find<LanguageController>();

  User? get currentUser => FirebaseAuth.instance.currentUser;

  List<String> getLatestNotices() {
    return [
      langController.getText(
        en: 'Notice: Hospital system maintenance scheduled for 01/09/2025.',
        mr: 'सूचना: हॉस्पिटल सिस्टम देखभाल 01/09/2025 ला आहे.',
        hi: 'सूचना: अस्पताल सिस्टम रखरखाव 01/09/2025 को निर्धारित।',
      ),
      langController.getText(
        en: 'Notice: New patient admission protocol effective immediately.',
        mr: 'सूचना: नवीन रुग्ण प्रवेश प्रोटोकॉल लगेच लागू.',
        hi: 'सूचना: नया मरीज प्रवेश प्रोटोकॉल तुरंत प्रभावी।',
      ),
      langController.getText(
        en: 'Notice: Ambulance training session on 02/09/2025.',
        mr: 'सूचना: 02/09/2025 रोजी अँब्युलन्स प्रशिक्षण सत्र.',
        hi: 'सूचना: 02/09/2025 को एम्बुलेंस प्रशिक्षण सत्र।',
      ),
    ];
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.offAllNamed('/case_manager_login');
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }
}
