import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Centralized theme management
class AppTheme {
  static const Color buttonColor = Color(0xFF6A1B9A); // Dark purple

  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFF2196F3),
    scaffoldBackgroundColor: Colors.white,
    textTheme: TextTheme(
      headlineSmall: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.blueGrey[900],
        letterSpacing: 1.2,
      ),
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      bodyMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Colors.blueGrey[900],
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: buttonColor,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 8,
        shadowColor: Colors.black38,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Colors.blueGrey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: Color(0xFF2196F3), width: 2),
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  );
}

class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  _RoleSelectionScreenState createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  String? _selectedRole;

  final List<Map<String, String>> _roles = [
    {'label': 'Doctor', 'route': '/doctor-login'},
    {'label': 'Admin', 'route': '/admin-login'},
    {'label': 'Receptionist', 'route': '/receptionist-login'},
    {'label': 'Accountant', 'route': '/accountant-login'},
    {'label': 'Laboratorist', 'route': '/laboratorist-login'},
    {'label': 'Pharmacist', 'route': '/pharmacist-login'},
    {'label': 'Nurse', 'route': '/nurse-login'},
    {'label': 'Patient', 'route': '/patient-login'},
    {'label': 'Case Manager', 'route': '/case_manager_login'},
  ];

  void _navigateToRoleScreen() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    final selectedRoute = _roles.firstWhere(
      (role) => role['label']! == _selectedRole!, // Use ! since we checked _selectedRole is non-null
      orElse: () => {'route': ''}, // Return empty string instead of null
    )['route'];

    if (selectedRoute != null && selectedRoute.isNotEmpty) {
      try {
        Get.toNamed(selectedRoute);
        debugPrint('Navigating to $selectedRoute');
      } catch (e) {
        debugPrint('Navigation error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error navigating to $_selectedRole login')),
        );
      }
    } else {
      debugPrint('No route found for role: $_selectedRole');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid role selected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: AppTheme.lightTheme,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Text(
                  'Select Your Role',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        shadows: [
                          Shadow(
                            blurRadius: 8.0,
                            color: Colors.black26,
                            offset: Offset(2.0, 2.0),
                          ),
                        ],
                      ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: DropdownButtonFormField<String>(
                                value: _selectedRole,
                                hint: Text(
                                  'Choose a role',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                items: _roles.map((role) {
                                  return DropdownMenuItem<String>(
                                    value: role['label']!, // Use ! since label is guaranteed non-null
                                    child: Text(
                                      role['label']!, // Use ! since label is guaranteed non-null
                                      style: Theme.of(context).textTheme.bodyMedium,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRole = value;
                                  });
                                },
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                isExpanded: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 300),
                          child: ElevatedButton(
                            onPressed: _navigateToRoleScreen,
                            child: const Text('Proceed'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}