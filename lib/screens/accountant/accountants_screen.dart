import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsmproject/controllers/accountant/accountants_controller.dart';

class AccountantsScreen extends StatelessWidget {
  const AccountantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountantsController controller = Get.put(AccountantsController());
    final TextEditingController nameController = TextEditingController();
    final TextEditingController emailController = TextEditingController();
    final TextEditingController roleController = TextEditingController();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A6EBB),
        title: Text(
          'Manage Accountants',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: 'Name',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                    TextField(
                      controller: roleController,
                      decoration: InputDecoration(
                        labelText: 'Role',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                      ),
                      onPressed: () {
                        controller.createAccountant(
                          name: nameController.text,
                          email: emailController.text,
                          role: roleController.text,
                        );
                      },
                      child: Text('Create Accountant', style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.accountants.length,
                  itemBuilder: (context, index) {
                    final accountant = controller.accountants[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(
                          'Name: ${accountant['name']}',
                          style: GoogleFonts.poppins(),
                        ),
                        subtitle: Text(
                          'Email: ${accountant['email']} | Role: ${accountant['role']}',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}