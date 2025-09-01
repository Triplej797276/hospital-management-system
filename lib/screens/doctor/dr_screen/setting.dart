import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsController extends GetxController {
  var themeMode = 'Light'.obs; // Example setting

  void changeTheme(String mode) {
    themeMode.value = mode;
    // Implement theme change
  }
}

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SettingsController());

    return Scaffold(
      appBar: AppBar(title: Text('Settings'), backgroundColor: Color(0xFF26A69A)),
      body: Obx(() => ListView(
        children: [
          ListTile(
            title: Text('Theme: ${controller.themeMode.value}'),
            trailing: Switch(
              value: controller.themeMode.value == 'Dark',
              onChanged: (val) => controller.changeTheme(val ? 'Dark' : 'Light'),
            ),
          ),
          // Add more settings
        ],
      )),
    );
  }
}