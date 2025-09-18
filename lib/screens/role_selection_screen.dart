import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AppTheme {
  static const Color primaryColor = Colors.blueAccent;

  static final ThemeData lightTheme = ThemeData(
    primaryColor: primaryColor,
    scaffoldBackgroundColor: Colors.blue[50], // 🔹 Light blue background
    textTheme: TextTheme(
      headlineSmall: const TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: Colors.blueAccent, // Blue heading
        letterSpacing: 1.1,
      ),
      bodyLarge: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: Colors.blueAccent,
      ),
      bodyMedium: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: Colors.blueAccent,
      ),
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

 final List<Map<String, dynamic>> _roles = [
  {'label': 'Admin', 'route': '/admin-login', 'icon': Icons.admin_panel_settings},
  {'label': 'Doctor', 'route': '/doctor-login', 'icon': Icons.local_hospital},
  {'label': 'Nurse', 'route': '/nurse-login', 'icon': Icons.medical_services},
  {'label': 'Receptionist', 'route': '/receptionist-login', 'icon': Icons.support_agent},
  {'label': 'Accountant', 'route': '/accountant_login', 'icon': Icons.calculate},
  {'label': 'Pharmacist', 'route': '/pharmacist_login', 'icon': Icons.local_pharmacy},
  {'label': 'Laboratorist', 'route': '/laboratorist-login', 'icon': Icons.biotech},
  {'label': 'Case Manager', 'route': '/case_manager_login', 'icon': Icons.people},
  {'label': 'Patient', 'route': '/patient-login', 'icon': Icons.person},
];

  void _navigateToRoleScreen() {
    if (_selectedRole == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a role')),
      );
      return;
    }

    final selectedRoute = _roles.firstWhere(
      (role) => role['label'] == _selectedRole!,
      orElse: () => {'route': ''},
    )['route'];

    if (selectedRoute != null && selectedRoute.isNotEmpty) {
      try {
        Get.toNamed(selectedRoute);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error navigating to $_selectedRole login')),
        );
      }
    } else {
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
        backgroundColor: Colors.blue[50], // 🔹 Soft hospital-like background
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 50),
              Text(
  'Choose Your Portal',
  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
  textAlign: TextAlign.center,
),
              const SizedBox(height: 40),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 360),
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white, // White card on light blue
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownButtonFormField<String>(
                            value: _selectedRole,
                            dropdownColor: Colors.white,
                            hint: Text(
                              'Choose a role',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            items: _roles.map((role) {
                              return DropdownMenuItem<String>(
                                value: role['label'],
                                child: Row(
                                  children: [
                                    Icon(role['icon'], color: Colors.blueAccent),
                                    const SizedBox(width: 12),
                                    Text(role['label'],
                                        style: Theme.of(context).textTheme.bodyMedium),
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedRole = value;
                              });
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.blue[50],
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14),
                                borderSide: BorderSide.none,
                              ),
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            ),
                            isExpanded: true,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton(
                              onPressed: _navigateToRoleScreen,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                elevation: 4,
                              ),
                              child: const Text(
                                'Proceed',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
