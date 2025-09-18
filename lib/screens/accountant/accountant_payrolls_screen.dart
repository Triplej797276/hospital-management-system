import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hsmproject/controllers/accountant/payrolls_controller.dart';

class AccountantPayrollsScreen extends StatefulWidget {
  const AccountantPayrollsScreen({super.key});

  @override
  State<AccountantPayrollsScreen> createState() =>
      _AccountantPayrollsScreenState();
}

class _AccountantPayrollsScreenState extends State<AccountantPayrollsScreen> {
  final PayrollsController controller = Get.put(PayrollsController());
  final TextEditingController basicController = TextEditingController();
  final TextEditingController allowanceController = TextEditingController();
  final TextEditingController deductionController = TextEditingController();

  String? selectedRole;
  double netSalary = 0.0;

  void calculateNetSalary() {
    double basic = double.tryParse(basicController.text) ?? 0.0;
    double allowance = double.tryParse(allowanceController.text) ?? 0.0;
    double deduction = double.tryParse(deductionController.text) ?? 0.0;
    setState(() {
      netSalary = basic + allowance - deduction;
    });
  }

  void resetForm() {
    basicController.clear();
    allowanceController.clear();
    deductionController.clear();
    controller.selectedEmployee.value = null;
    setState(() {
      selectedRole = null;
      netSalary = 0.0;
    });
  }

  @override
  void initState() {
    super.initState();
    basicController.addListener(calculateNetSalary);
    allowanceController.addListener(calculateNetSalary);
    deductionController.addListener(calculateNetSalary);
  }

  @override
  void dispose() {
    basicController.dispose();
    allowanceController.dispose();
    deductionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2A6EBB),
        title: Text(
          'Manage Payrolls',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /// Payroll Form
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedRole,
                      decoration: InputDecoration(
                        labelText: "Select Role",
                        labelStyle: GoogleFonts.poppins(),
                      ),
                      items: ["Doctor", "Nurse", "Pharmacist", "Receptionist"]
                          .map((role) => DropdownMenuItem(
                                value: role,
                                child: Text(role),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            selectedRole = value;
                          });
                          controller.fetchEmployeesByRole(value);
                          controller.fetchPayrollsForRole(value);
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Obx(() {
                      if (controller.employees.isEmpty) {
                        return Text(
                          "Select a role to load employees",
                          style: GoogleFonts.poppins(),
                        );
                      }
                      return DropdownButtonFormField<Map<String, dynamic>>(
                        value: controller.selectedEmployee.value,
                        decoration: InputDecoration(
                          labelText: "Select Employee",
                          labelStyle: GoogleFonts.poppins(),
                        ),
                        items: controller.employees
                            .map((emp) => DropdownMenuItem(
                                  value: emp,
                                  child: Text(emp['name'] ?? "Unnamed"),
                                ))
                            .toList(),
                        onChanged: (value) {
                          controller.selectedEmployee.value = value;
                        },
                      );
                    }),
                    const SizedBox(height: 12),
                    Obx(() {
                      final emp = controller.selectedEmployee.value;
                      if (emp == null) return SizedBox.shrink();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("UID: ${emp['uid']}",
                              style: GoogleFonts.poppins(fontSize: 14)),
                          Text("Name: ${emp['name']}",
                              style: GoogleFonts.poppins(fontSize: 14)),
                        ],
                      );
                    }),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: basicController,
                            decoration: InputDecoration(
                              labelText: 'Basic',
                              labelStyle: GoogleFonts.poppins(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: allowanceController,
                            decoration: InputDecoration(
                              labelText: 'Allowances',
                              labelStyle: GoogleFonts.poppins(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: deductionController,
                            decoration: InputDecoration(
                              labelText: 'Deductions',
                              labelStyle: GoogleFonts.poppins(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Net Salary: \$${netSalary.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF4CAF50),
                        minimumSize: const Size.fromHeight(50),
                      ),
                      onPressed: () {
                        if (controller.selectedEmployee.value == null ||
                            selectedRole == null) {
                          Get.snackbar(
                              "Error", "Please select role and employee");
                          return;
                        }
                        final emp = controller.selectedEmployee.value!;
                        controller.addPayroll(
                          employeeUid: emp['uid'],
                          employeeName: emp['name'] ?? "Unknown",
                          role: selectedRole!,
                          basic: double.tryParse(basicController.text) ?? 0.0,
                          allowances:
                              double.tryParse(allowanceController.text) ?? 0.0,
                          deductions:
                              double.tryParse(deductionController.text) ?? 0.0,
                        );
                        resetForm();
                      },
                      child: Text(
                        'Add Payroll',
                        style: GoogleFonts.poppins(
                            color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Obx(() {
                if (controller.payrolls.isEmpty) {
                  return Center(
                      child: Text("No payrolls found",
                          style: GoogleFonts.poppins()));
                }
                return ListView.builder(
                  itemCount: controller.payrolls.length,
                  itemBuilder: (context, index) {
                    final payroll = controller.payrolls[index];
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        title: Text('Employee: ${payroll['employeeName']}',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600)),
                        subtitle: Text(
                          'Role: ${payroll['role']} | Net: \$${payroll['netSalary']} | Status: ${payroll['status']}',
                          style: GoogleFonts.poppins(fontSize: 13),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.picture_as_pdf,
                                  color: Colors.red),
                              onPressed: () {
                                controller.generatePayslipPDF(payroll);
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                payroll['status'] == 'paid'
                                    ? Icons.check_circle
                                    : Icons.payment,
                                color: payroll['status'] == 'paid'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                              onPressed: () {
                                if (payroll['status'] != 'paid') {
                                  controller.updatePayrollStatus(
                                    payroll['role'],
                                    payroll['employeeUid'],
                                    payroll['id'],
                                    'paid',
                                  );
                                }
                              },
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
