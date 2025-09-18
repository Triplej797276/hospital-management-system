import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsmproject/controllers/accountant/bills_controller.dart';
import 'package:intl/intl.dart';

class AccountantBillsScreen extends StatelessWidget {
  const AccountantBillsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountantBillsController controller = Get.put(AccountantBillsController());
    final TextEditingController patientIdController = TextEditingController();
    final TextEditingController patientNameController = TextEditingController();
    final TextEditingController admissionIdController = TextEditingController();
    final TextEditingController insuranceDetailsController = TextEditingController();
    final TextEditingController totalController = TextEditingController();
    final TextEditingController extraItemController = TextEditingController();
    final TextEditingController extraItemAmountController = TextEditingController();
    var extraItems = <Map<String, dynamic>>[].obs;
    DateTime admissionDate = DateTime.now();
    DateTime? dischargeDate;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A6EBB),
        title: Text(
          'Manage Bills',
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
                      controller: admissionIdController,
                      decoration: InputDecoration(
                        labelText: 'Admission ID',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                    TextField(
                      controller: insuranceDetailsController,
                      decoration: InputDecoration(
                        labelText: 'Insurance Details',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                    ),
                    TextField(
                      controller: totalController,
                      decoration: InputDecoration(
                        labelText: 'Total Amount',
                        labelStyle: GoogleFonts.poppins(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: extraItemController,
                            decoration: InputDecoration(
                              labelText: 'Extra Item',
                              labelStyle: GoogleFonts.poppins(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: extraItemAmountController,
                            decoration: InputDecoration(
                              labelText: 'Amount',
                              labelStyle: GoogleFonts.poppins(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add, color: Color(0xFF4CAF50)),
                          onPressed: () {
                            extraItems.add({
                              'item': extraItemController.text,
                              'amount': double.parse(extraItemAmountController.text),
                            });
                            extraItemController.clear();
                            extraItemAmountController.clear();
                          },
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: admissionDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) admissionDate = picked;
                      },
                      child: Text(
                        'Admission Date: ${DateFormat.yMd().format(admissionDate)}',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2030),
                        );
                        if (picked != null) dischargeDate = picked;
                      },
                      child: Text(
                        'Discharge Date: ${dischargeDate != null ? DateFormat.yMd().format(dischargeDate!) : 'Not set'}',
                        style: GoogleFonts.poppins(),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                      ),
                      onPressed: () {
                        controller.createBill(
                          patientId: patientIdController.text,
                          patientName: patientNameController.text,
                          admissionId: admissionIdController.text,
                          admissionDate: admissionDate,
                          dischargeDate: dischargeDate,
                          insuranceDetails: insuranceDetailsController.text,
                          extraItems: extraItems,
                          total: double.parse(totalController.text),
                        );
                      },
                      child: Text('Create Bill', style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.bills.length,
                  itemBuilder: (context, index) {
                    final bill = controller.bills[index];
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(
                          'Patient: ${bill['patientName']}',
                          style: GoogleFonts.poppins(),
                        ),
                        subtitle: Text(
                          'Admission ID: ${bill['admissionId']} | Total: \$${bill['total']}',
                          style: GoogleFonts.poppins(),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.download, color: Color(0xFF2A6EBB)),
                          onPressed: () => controller.exportBillAsPdf(bill),
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