import 'package:get/get.dart';

class AccountantController extends GetxController {
  // Observable variable for the latest notice
  var latestNotice = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Initialize with a default notice or fetch from a service
    fetchLatestNotice();
  }

  // Method to fetch or update the latest notice (e.g., from an API or database)
  void fetchLatestNotice() {
    // Placeholder: Replace with actual API call or database query
    latestNotice.value = 'New tax regulation effective from next month.';
  }

  // Method to update the notice (e.g., from a form or API)
  void updateNotice(String newNotice) {
    latestNotice.value = newNotice;
  }
}