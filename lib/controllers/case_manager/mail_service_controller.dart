import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MailServiceController extends GetxController {
  // Observable list for recent mails
  var recentMails = <Map<String, dynamic>>[
    {'id': '1', 'title': 'Mail 1', 'sentDate': '01/09/2025'},
    {'id': '2', 'title': 'Mail 2', 'sentDate': '01/09/2025'},
    {'id': '3', 'title': 'Mail 3', 'sentDate': '01/09/2025'},
  ].obs;

  // Simulate sending a new mail
  void sendMail() {
    Get.snackbar(
      'Send Mail',
      'Feature to send a new mail coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.purple,
      colorText: Colors.white,
    );
  }

  // Simulate fetching mail details
  void showMailDetails(String mailId) {
    Get.snackbar(
      'Mail Details',
      'Details for Mail $mailId coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.purple,
      colorText: Colors.white,
    );
  }
}