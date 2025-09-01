// lib/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email or Username'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 20),
          ElevatedButton(
  onPressed: () => authController.signIn(
    emailController.text.trim(),
    passwordController.text.trim(),
    'admin', 
  ),
  child: const Text('Sign In'),
            ),
            TextButton(
              onPressed: () {
                Get.snackbar('Info', 'Sign-up not implemented');
              },
              child: const Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}