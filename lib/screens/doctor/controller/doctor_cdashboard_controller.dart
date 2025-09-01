import 'package:get/get.dart';

class DashboardController extends GetxController {
  var currentIndex = 0.obs;
  var latestNotice = 'New hospital policy update: Please review the latest guidelines.'.obs;

  void changeTabIndex(int index) {
    currentIndex.value = index;
    if (index == 1) {
      Get.toNamed('/profile');
    } else if (index == 2) {
      Get.toNamed('/settings');
    } else {
      Get.toNamed('/dashboard');
    }
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch latest notice from backend/mock
    latestNotice.value = 'Updated notice: Staff meeting at 10 AM.';
  }
}