import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
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