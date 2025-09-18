import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsmproject/controllers/admin/admin_payrolls_controller.dart';

class AdminPayrollListScreen extends StatelessWidget {
  const AdminPayrollListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminPayrollsController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Payrolls'),
        backgroundColor: Colors.blue,
      ),
      body: Obx(() {
        if (controller.payrolls.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        final payrolls = controller.payrolls;

        return Column(
          children: [
            // 🔹 Counter
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "Total Payrolls: ${payrolls.length}",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ),
            ),

            // 🔹 Payroll Table
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  headingRowColor: MaterialStateProperty.all(Colors.blue.shade100),
                  border: TableBorder.all(color: Colors.grey.shade300),
                  columns: const [
                    DataColumn(label: Text('Employee')),
                    DataColumn(label: Text('Role')),
                    DataColumn(label: Text('Basic')),
                    DataColumn(label: Text('Allowances')),
                    DataColumn(label: Text('Deductions')),
                    DataColumn(label: Text('Net Salary')),
                    DataColumn(label: Text('Status')),
                  ],
                  rows: payrolls.map((payroll) {
                    return DataRow(
                      cells: [
                        DataCell(Text(payroll['employeeName'] ?? 'Unknown')),
                        DataCell(Text(payroll['role'] ?? 'N/A')),
                        DataCell(Text("\$${payroll['basic'] ?? 'N/A'}")),
                        DataCell(Text("\$${payroll['allowances'] ?? 'N/A'}")),
                        DataCell(Text("\$${payroll['deductions'] ?? 'N/A'}")),
                        DataCell(Text("\$${payroll['netSalary'] ?? 'N/A'}")),
                        DataCell(Row(
                          children: [
                            Icon(
                              payroll['status'] == 'paid'
                                  ? Icons.check_circle
                                  : Icons.pending_actions,
                              color: payroll['status'] == 'paid'
                                  ? Colors.green
                                  : Colors.orange,
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(payroll['status'] ?? 'unpaid'),
                          ],
                        )),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
