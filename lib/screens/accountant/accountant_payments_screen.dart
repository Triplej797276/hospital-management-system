import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsmproject/controllers/accountant/accountants_payments_controller.dart';

class AccountantPaymentsScreen extends StatelessWidget {
  const AccountantPaymentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountantsPaymentsController controller = Get.put(AccountantsPaymentsController());
    final TextEditingController patientIdController = TextEditingController();
    final TextEditingController patientNameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController accountTypeController = TextEditingController();
    var isAdvance = false.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A6EBB),
        title: Text(
          'Manage Payments',
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
                      controller: patientIdController,
                      decoration: InputDecoration(
                        labelText: 'Patient ID',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                    TextField(
                      controller: patientNameController,
                      decoration: InputDecoration(
                        labelText: 'Patient Name',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    TextField(
                      controller: accountTypeController,
                      decoration: InputDecoration(
                        labelText: 'Account Type (Credit/Debit)',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                    Obx(
                      () => CheckboxListTile(
                        title: Text('Advance Payment', style: GoogleFonts.poppins()),
                        value: isAdvance.value,
                        onChanged: (value) => isAdvance.value = value!,
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                      ),
                      onPressed: () {
                        controller.recordPayment(
                          patientId: patientIdController.text,
                          patientName: patientNameController.text,
                          amount: double.parse(amountController.text),
                          accountType: accountTypeController.text,
                          isAdvance: isAdvance.value,
                        );
                      },
                      child: Text('Record Payment', style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.payments.length,
                  itemBuilder: (context, index) {
                    final payment = controller.payments[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(
                          'Patient: ${payment['patientName']}',
                          style: GoogleFonts.poppins(),
                        ),
                        subtitle: Text(
                          'Amount: \$${payment['amount']} ${payment['isAdvance'] ? '(Advance)' : ''}',
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