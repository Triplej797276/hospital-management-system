import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsmproject/controllers/accountant/accountant_dashboard_controller.dart';
import 'package:hsmproject/controllers/auth_controller.dart';

class AccountantDashboardScreen extends StatelessWidget {
  const AccountantDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    final AccountantDashboardController accountantController = Get.put(AccountantDashboardController());

    // Define a professional color scheme
    const primaryColor = Color(0xFF2A6EBB); // Calming blue
    const accentColor = Color(0xFF4CAF50); // Green for positive actions
    const backgroundColor = Color(0xFFF5F7FA); // Light grey background
    const cardColor = Colors.white;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        title: Text(
          'Accountant Dashboard',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => authController.signOut(),
          ),
        ],
      ),
      drawer: Drawer(
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [primaryColor, Color(0xFF1E4E8C)],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Text(
                  'Accountant Menu',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildDrawerItem(
                icon: Icons.receipt_long,
                title: 'Manage Invoices',
                onTap: () {
                  Get.back();
                  Get.toNamed('/accountant/invoice');
                },
              ),
              _buildDrawerItem(
                icon: Icons.payment,
                title: 'Manage Payments',
                onTap: () {
                  Get.back();
                  Get.toNamed('/accountant/payments');
                },
              ),
              _buildDrawerItem(
                icon: Icons.account_balance_wallet,
                title: 'Payrolls',
                onTap: () {
                  Get.back();
                  Get.toNamed('/accountant/payrolls');
                },
              ),
              _buildDrawerItem(
                icon: Icons.description,
                title: 'Bills',
                onTap: () {
                  Get.back();
                  Get.toNamed('/accountant/bill');
                },
              ),
              _buildDrawerItem(
                icon: Icons.account_balance,
                title: 'Manage Accounts',
                onTap: () {
                  Get.back();
                  Get.toNamed('/accountant/accounts');
                },
              ),
              _buildDrawerItem(
                icon: Icons.person,
                title: 'Manage Accountants',
                onTap: () {
                  Get.back();
                  Get.toNamed('/accountant/accountants');
                },
              ),
              _buildDrawerItem(
                icon: Icons.notification_important,
                title: 'Latest Notice',
                onTap: () {
                  Get.back();
                  Get.snackbar(
                    'Latest Notice',
                    accountantController.latestNotice.value,
                    backgroundColor: cardColor,
                    snackPosition: SnackPosition.TOP,
                  );
                },
              ),
              const Divider(color: Colors.white54),
              _buildDrawerItem(
                icon: Icons.logout,
                title: 'Sign Out',
                onTap: () {
                  Get.back();
                  authController.signOut();
                },
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Latest Notice Section
            Obx(() => Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 8,
                          offset: const Offset(4, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Latest Notice',
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: primaryColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          accountantController.latestNotice.value.isEmpty
                              ? 'No new notices.'
                              : accountantController.latestNotice.value,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.grey[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                )),
            const SizedBox(height: 20),
            // Dashboard Actions
            Text(
              'Accountant Tools',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  _buildDashboardTile(
                    context,
                    icon: Icons.receipt_long,
                    title: 'Manage Invoices',
                    onTap: () {
                      Get.toNamed('/accountant/invoice');
                    },
                    color: primaryColor,
                  ),
                  _buildDashboardTile(
                    context,
                    icon: Icons.payment,
                    title: 'Manage Payments',
                    onTap: () {
                      Get.toNamed('/accountant/payments');
                    },
                    color: accentColor,
                  ),
                  _buildDashboardTile(
                    context,
                    icon: Icons.account_balance_wallet,
                    title: 'Payrolls',
                    onTap: () {
                      Get.toNamed('/accountant/payrolls');
                    },
                    color: primaryColor,
                  ),
                  _buildDashboardTile(
                    context,
                    icon: Icons.description,
                    title: 'Bills',
                    onTap: () {
                      Get.toNamed('/accountant/bill');
                    },
                    color: accentColor,
                  ),
                  _buildDashboardTile(
                    context,
                    icon: Icons.account_balance,
                    title: 'Manage Accounts',
                    onTap: () {
                      Get.toNamed('/accountant/accounts');
                    },
                    color: primaryColor,
                  ),
                  _buildDashboardTile(
                    context,
                    icon: Icons.person,
                    title: 'Manage Accountants',
                    onTap: () {
                      Get.toNamed('/accountant/accountants');
                    },
                    color: accentColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build drawer items
  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        title,
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      hoverColor: Colors.white.withOpacity(0.1),
    );
  }

  // Helper method to build dashboard tiles with animations
  Widget _buildDashboardTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Colors.white, Colors.grey[100]!],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 48,
                color: color,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[800],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}