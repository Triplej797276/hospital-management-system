import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SettingsController extends GetxController {
  var themeMode = ThemeMode.system.obs; // System, Light, or Dark
  var notificationsEnabled = true.obs; // Toggle for notifications
  var notificationFrequency = 1.0.obs; // Frequency in hours (1-24)
  var selectedLanguage = 'English'.obs; // Selected language
  final List<String> languages = ['English', 'Spanish', 'French'];

  @override
  void onInit() {
    super.onInit();
    // Load saved settings (simulated here, replace with SharedPreferences or similar)
    loadSettings();
  }

  void loadSettings() {
    // Simulate loading from storage
    themeMode.value = ThemeMode.system;
    notificationsEnabled.value = true;
    notificationFrequency.value = 1.0;
    selectedLanguage.value = 'English';
  }

  void changeTheme(ThemeMode mode) {
    themeMode.value = mode;
    Get.changeThemeMode(mode); // Apply theme change
  }

  void toggleNotifications(bool value) {
    notificationsEnabled.value = value;
    // Save to storage or update notification settings
  }

  void setNotificationFrequency(double value) {
    notificationFrequency.value = value;
    // Save to storage or update notification schedule
  }

  void changeLanguage(String language) {
    selectedLanguage.value = language;
    // Implement language change (e.g., update locale)
    // Example: Get.updateLocale(Locale(language == 'English' ? 'en' : language == 'Spanish' ? 'es' : 'fr'));
  }

  void logout() {
    // Simulate logout (e.g., clear user session)
    Get.dialog(
      AlertDialog(
        title: Text('Logout'),
        content: Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform logout (e.g., clear auth token)
              Get.snackbar('Success', 'Logged out successfully');
              Get.offAllNamed('/login'); // Navigate to login screen
            },
            child: Text('Logout'),
          ),
        ],
      ),
    );
  }
}