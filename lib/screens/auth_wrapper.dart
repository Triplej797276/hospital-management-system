import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/screens/accountant/accountant_list_screen.dart';
import 'package:hsmproject/screens/doctor/dashboard_screen.dart';
import 'package:hsmproject/screens/home_screen.dart';
import '../controllers/auth_controller.dart';
import 'role_selection_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Obx(() {
      final authController = Get.find<AuthController>();
      if (authController.user.value == null) {
        return const RoleSelectionScreen();
      }
      if (authController.isLoading.value) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }
      switch (authController.userRole.value) {
        case 'admin':
          return HomeScreen();
        case 'doctor':
          return const DashboardScreen();
        case 'accountant':
          return const AccountantListScreen();
        case 'receptionist':
          return HomeScreen(); // Placeholder: Update with receptionist-specific screen
        default:
          return const RoleSelectionScreen();
      }
    });
  }
}