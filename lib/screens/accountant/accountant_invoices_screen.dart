import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsmproject/controllers/accountant/accountants_invoices_controller.dart';
import 'package:intl/intl.dart';

class AccountantInvoicesScreen extends StatelessWidget {
  const AccountantInvoicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AccountantsInvoicesController controller = Get.put(AccountantsInvoicesController());
    final TextEditingController patientIdController = TextEditingController();
    final TextEditingController patientNameController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    final TextEditingController discountController = TextEditingController();
    final TextEditingController searchController = TextEditingController();
    final Rx<DateTime> selectedDate = DateTime.now().obs;
    final RxString filterStatus = 'All'.obs;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A6EBB),
        title: Text(
          'Manage Invoices',
          style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterDialog(context, filterStatus, selectedDate, controller),
          ),
        ],
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
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: patientNameController,
                      decoration: InputDecoration(
                        labelText: 'Patient Name',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: amountController,
                      decoration: InputDecoration(
                        labelText: 'Amount',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: discountController,
                      decoration: InputDecoration(
                        labelText: 'Discount',
                        labelStyle: GoogleFonts.poppins(),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 12),
                    Obx(
                      () => TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
                            context: context,
                            initialDate: selectedDate.value,
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2030),
                          );
                          if (picked != null) selectedDate.value = picked;
                        },
                        child: Text(
                          'Select Invoice Date: ${DateFormat.yMd().format(selectedDate.value)}',
                          style: GoogleFonts.poppins(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (patientIdController.text.isEmpty || patientNameController.text.isEmpty) {
                          Get.snackbar('Error', 'Patient ID and Name are required');
                          return;
                        }
                        controller.createInvoice(
                          patientId: patientIdController.text,
                          patientName: patientNameController.text,
                          invoiceDate: selectedDate.value,
                          amount: double.tryParse(amountController.text) ?? 0.0,
                          discount: double.tryParse(discountController.text) ?? 0.0,
                        );
                        patientIdController.clear();
                        patientNameController.clear();
                        amountController.clear();
                        discountController.clear();
                      },
                      child: Text('Create Invoice', style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search by Patient Name or ID',
                labelStyle: GoogleFonts.poppins(),
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.search),
              ),
              onChanged: (value) => controller.filterInvoices(value),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(
                () => ListView.builder(
                  itemCount: controller.filteredInvoices.length,
                  itemBuilder: (context, index) {
                    final invoice = controller.filteredInvoices[index];
                    final isPaid = invoice['status'] == 'Paid';
                    return Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        title: Text(
                          'Patient: ${invoice['patientName']}',
                          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('ID: ${invoice['patientId']}', style: GoogleFonts.poppins()),
                            Text('Total: \$${invoice['total'].toStringAsFixed(2)}', style: GoogleFonts.poppins()),
                            Text('Status: ${invoice['status']}', style: GoogleFonts.poppins()),
                            Text(
                              'Date: ${DateFormat.yMd().format(invoice['invoiceDate'].toDate())}',
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (!isPaid)
                              IconButton(
                                icon: const Icon(Icons.edit, color: Color(0xFF2A6EBB)),
                                onPressed: () => _showEditDialog(context, invoice, controller),
                              ),
                            IconButton(
                              icon: const Icon(Icons.download, color: Color(0xFF2A6EBB)),
                              onPressed: () => controller.exportInvoiceAsPdf(invoice),
                            ),
                            // IconButton(
                            //   icon: const Icon(Icons.email, color: Color(0xFF2A6EBB)),
                            //   // onPressed: () => controller.sendInvoiceEmail(invoice),
                            // ),
                            IconButton(
                              icon: const Icon(Icons.payment, color: Color(0xFF2A6EBB)),
                              onPressed: () => controller.viewPaymentRecords(invoice['id']),
                            ),
                          ],
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

  void _showFilterDialog(BuildContext context, RxString filterStatus, Rx<DateTime> selectedDate, AccountantsInvoicesController controller) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Invoices', style: GoogleFonts.poppins()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: filterStatus.value,
                items: ['All', 'Paid', 'Unpaid'].map((status) {
                  return DropdownMenuItem(value: status, child: Text(status, style: GoogleFonts.poppins()));
                }).toList(),
                onChanged: (value) {
                  if (value != null) filterStatus.value = value;
                },
              ),
              TextButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: selectedDate.value,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) selectedDate.value = picked;
                },
                child: Obx(
                  () => Text(
                    'Select Date: ${DateFormat.yMd().format(selectedDate.value)}',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.applyFilters(filterStatus.value, selectedDate.value);
                Get.back();
              },
              child: Text('Apply', style: GoogleFonts.poppins()),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, Map<String, dynamic> invoice, AccountantsInvoicesController controller) {
    final TextEditingController amountController = TextEditingController(text: invoice['amount'].toString());
    final TextEditingController discountController = TextEditingController(text: invoice['discount'].toString());
    final Rx<DateTime> selectedDate = invoice['invoiceDate'].toDate().obs;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Invoice', style: GoogleFonts.poppins()),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              TextField(
                controller: discountController,
                decoration: InputDecoration(
                  labelText: 'Discount',
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 12),
              Obx(
                () => TextButton(
                  onPressed: () async {
                    final DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate.value,
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2030),
                    );
                    if (picked != null) selectedDate.value = picked;
                  },
                  child: Text(
                    'Select Date: ${DateFormat.yMd().format(selectedDate.value)}',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                controller.editInvoice(
                  invoice['id'],
                  double.tryParse(amountController.text) ?? invoice['amount'],
                  double.tryParse(discountController.text) ?? invoice['discount'],
                  selectedDate.value,
                );
                Get.back();
              },
              child: Text('Save', style: GoogleFonts.poppins()),
            ),
            TextButton(
              onPressed: () => Get.back(),
              child: Text('Cancel', style: GoogleFonts.poppins()),
            ),
          ],
        );
      },
    );
  }
}