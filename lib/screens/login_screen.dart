// lib/screens/admin_login_screen.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Container(
                  padding: const EdgeInsets.all(28),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26.withOpacity(0.15),
                        blurRadius: 12,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(color: Colors.white24, width: 1.2),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Icon
                      const Icon(Icons.admin_panel_settings,
                          size: 90, color: Colors.white),
                      const SizedBox(height: 12),

                      // Title
                      Text(
                        "Admin Login",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(
                                  blurRadius: 8.0,
                                  color: Colors.black38,
                                  offset: Offset(2.0, 2.0),
                                ),
                              ],
                            ),
                      ),
                      const SizedBox(height: 32),

                      // Email
                      TextField(
                        controller: emailController,
                        style: const TextStyle(color: Colors.black87),
                        decoration: InputDecoration(
                          labelText: 'Email or Username',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.95),
                          prefixIcon:
                              const Icon(Icons.email, color: Colors.blueGrey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Password
                      TextField(
                        controller: passwordController,
                        style: const TextStyle(color: Colors.black87),
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.95),
                          prefixIcon:
                              const Icon(Icons.lock, color: Colors.blueGrey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Colors.blueGrey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Forgot Password
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () {
                            Get.snackbar("Forgot Password",
                                "Password reset not implemented yet");
                          },
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(color: Colors.white70),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Sign In Button
                      SizedBox(
                        height: 55,
                        child: ElevatedButton(
                          onPressed: () => authController.signIn(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            'admin',
                          ),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            elevation: 10,
                          ),
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Container(
                              alignment: Alignment.center,
                              child: const Text(
                                'Sign In',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),

                      // Create Account
                      TextButton(
                        onPressed: () {
                          Get.snackbar('Info', 'Sign-up not implemented');
                        },
                        child: const Text(
                          'Create Account',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
