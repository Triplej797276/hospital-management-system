import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/controllers/auth_controller.dart';

class NursePayrollsScreen extends StatelessWidget {
  const NursePayrollsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payrolls'),
        backgroundColor: const Color(0xFF0077B6),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authController.signOut();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Payroll Information',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF023E8A),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildPayrollCard(
                    period: 'August 2025',
                    amount: '5000 USD',
                    status: 'Paid',
                  ),
                  _buildPayrollCard(
                    period: 'July 2025',
                    amount: '5000 USD',
                    status: 'Paid',
                  ),
                  _buildPayrollCard(
                    period: 'June 2025',
                    amount: '5000 USD',
                    status: 'Paid',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayrollCard({required String period, required String amount, required String status}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.account_balance_wallet, color: Color(0xFF0077B6)),
        title: Text(
          period,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Text('Amount: $amount\nStatus: $status'),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
          // Navigate to payroll details
          Get.toNamed('/payrollDetails');
        },
      ),
    );
  }
}