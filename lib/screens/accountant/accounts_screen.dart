import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsmproject/controllers/accountant/accounts_controller.dart';

class AccountsScreen extends StatelessWidget {
  const AccountsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountsController controller = Get.put(AccountsController());

    final TextEditingController accountNameController = TextEditingController();
    final TextEditingController balanceController = TextEditingController();
    String? selectedType;

    void clearForm() {
      accountNameController.clear();
      balanceController.clear();
      selectedType = null;
    }

    void openEditDialog(Map<String, dynamic> account, String accountId) {
      final TextEditingController editName = TextEditingController(text: account['accountName']);
      final TextEditingController editBalance = TextEditingController(text: account['balance'].toString());
      String? editType = account['accountType'];

      Get.defaultDialog(
        title: "Edit Account",
        content: Column(
          children: [
            TextField(
              controller: editName,
              decoration: InputDecoration(labelText: "Account Name"),
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<String>(
              value: editType,
              items: ['Cash', 'Bank', 'Other']
                  .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                  .toList(),
              onChanged: (value) => editType = value,
              decoration: const InputDecoration(labelText: "Account Type"),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: editBalance,
              decoration: const InputDecoration(labelText: "Balance"),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        textConfirm: "Save",
        textCancel: "Cancel",
        confirmTextColor: Colors.white,
        onConfirm: () {
          if (editName.text.isEmpty || editBalance.text.isEmpty || editType == null) {
            Get.snackbar("Error", "All fields are required");
            return;
          }
          controller.updateAccount(
            accountId,
            editName.text,
            editType!,
            double.tryParse(editBalance.text) ?? 0.0,
          );
          Get.back();
        },
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A6EBB),
        title: Text(
          'Manage Accounts',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Professional Add Account Form
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      "Add New Account",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Account Name
                    TextField(
                      controller: accountNameController,
                      decoration: InputDecoration(
                        labelText: "Account Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Account Type Dropdown
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(
                        labelText: "Account Type",
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: ['Cash', 'Bank', 'Other']
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ))
                          .toList(),
                      onChanged: (value) => selectedType = value,
                    ),
                    const SizedBox(height: 12),

                    // Balance
                    TextField(
                      controller: balanceController,
                      decoration: InputDecoration(
                        labelText: "Balance",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 16),

                    // Add Account Button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (accountNameController.text.isEmpty ||
                            balanceController.text.isEmpty ||
                            selectedType == null) {
                          Get.snackbar("Error", "All fields are required");
                          return;
                        }
                        controller.createAccount(
                          accountName: accountNameController.text,
                          accountType: selectedType!,
                          balance: double.tryParse(balanceController.text) ?? 0.0,
                        );
                        clearForm();
                      },
                      child: Text(
                        "Add Account",
                        style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// Accounts List
            Expanded(
              child: Obx(() {
                if (controller.accounts.isEmpty) {
                  return Center(
                    child: Text("No accounts available", style: GoogleFonts.poppins()),
                  );
                }
                return ListView.builder(
                  itemCount: controller.accounts.length,
                  itemBuilder: (context, index) {
                    final account = controller.accounts[index];
                    final accountId = account['id'] ?? '';
                    return Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: Text(account['accountName'] ?? '-', style: GoogleFonts.poppins(fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          "Type: ${account['accountType']} | Balance: \$${account['balance'] ?? 0.0}",
                          style: GoogleFonts.poppins(),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () => openEditDialog(account, accountId),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => controller.deleteAccount(accountId),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
