import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/doctors/profilecontrollers.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(ProfileController());
    final authController = Get.put(AuthController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        backgroundColor: Color(0xFF26A69A),
      ),
      body: Obx(() => Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text('Email: ${authController.user.value?['email'] ?? ''}'),
                Text('Name: ${authController.user.value?['name'] ?? ''}'),
                ElevatedButton(
                  onPressed: () {
                    Get.defaultDialog(
                      title: 'Update Name',
                      content: Text('Implement form here'),
                    );
                  },
                  child: Text('Edit Profile'),
                ),
              ],
            ),
          )),
    );
  }
}