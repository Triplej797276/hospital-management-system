import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctors/settings_controller.dart';
class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => ListView(
            padding: EdgeInsets.all(16.0),
            children: [
              // Theme Selection
              ListTile(
                title: Text('Theme'),
                subtitle: Text('Current: ${controller.themeMode.value == ThemeMode.system ? 'System' : controller.themeMode.value == ThemeMode.dark ? 'Dark' : 'Light'}'),
                trailing: DropdownButton<ThemeMode>(
                  value: controller.themeMode.value,
                  items: [
                    DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                    DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                    DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
                  ],
                  onChanged: (mode) {
                    if (mode != null) {
                      controller.changeTheme(mode);
                    }
                  },
                ),
              ),
              Divider(),
              // Notifications Toggle
              SwitchListTile(
                title: Text('Enable Notifications'),
                subtitle: Text('Receive app notifications'),
                value: controller.notificationsEnabled.value,
                onChanged: controller.toggleNotifications,
                activeColor: Color(0xFF26A69A),
              ),
              // Notification Frequency
              ListTile(
                title: Text('Notification Frequency'),
                subtitle: Text('Notify every ${controller.notificationFrequency.value.toStringAsFixed(1)} hour(s)'),
                enabled: controller.notificationsEnabled.value,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              Slider(
                value: controller.notificationFrequency.value,
                min: 1.0,
                max: 24.0,
                divisions: 23,
                label: '${controller.notificationFrequency.value.toStringAsFixed(1)} hours',
                onChanged: controller.notificationsEnabled.value
                    ? (value) => controller.setNotificationFrequency(value)
                    : null,
                activeColor: Color(0xFF26A69A),
                inactiveColor: Colors.grey[300],
              ),
              Divider(),
              // Language Selection
              ListTile(
                title: Text('Language'),
                subtitle: Text('Current: ${controller.selectedLanguage.value}'),
                trailing: DropdownButton<String>(
                  value: controller.selectedLanguage.value,
                  items: controller.languages
                      .map((lang) => DropdownMenuItem(value: lang, child: Text(lang)))
                      .toList(),
                  onChanged: (lang) {
                    if (lang != null) {
                      controller.changeLanguage(lang);
                    }
                  },
                ),
              ),
              Divider(),
              // Logout Button
              ListTile(
                title: Text('Logout', style: TextStyle(color: Colors.red)),
                leading: Icon(Icons.logout, color: Colors.red),
                onTap: controller.logout,
              ),
            ],
          )),
    );
  }
}