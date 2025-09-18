import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';

class AccountantsInvoicesController extends GetxController {
  var invoices = <Map<String, dynamic>>[].obs;
  var filteredInvoices = <Map<String, dynamic>>[].obs;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _searchQuery;
  String? _filterStatus;
  DateTime? _filterDate;

  @override
  void onInit() {
    super.onInit();
    fetchInvoices();
  }

  Future<void> fetchInvoices() async {
    try {
      final snapshot = await _firestore.collection('invoices').get();
      invoices.assignAll(snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id; // Include document ID
        return data;
      }).toList());
      filteredInvoices.assignAll(invoices); // Initialize filteredInvoices
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch invoices: $e');
    }
  }

  Future<void> createInvoice({
    required String patientId,
    required String patientName,
    required DateTime invoiceDate,
    required double amount,
    required double discount,
  }) async {
    try {
      final invoice = {
        'patientId': patientId,
        'patientName': patientName,
        'invoiceDate': Timestamp.fromDate(invoiceDate),
        'amount': amount,
        'discount': discount,
        'total': amount - discount,
        'status': 'Unpaid',
        'createdAt': Timestamp.now(),
      };
      final docRef = await _firestore.collection('invoices').add(invoice);
      invoice['id'] = docRef.id;
      invoices.add(invoice);
      filteredInvoices.add(invoice);
      Get.snackbar('Success', 'Invoice created successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to create invoice: $e');
    }
  }

  Future<void> editInvoice(String invoiceId, double amount, double discount, DateTime invoiceDate) async {
    try {
      final updatedInvoice = {
        'amount': amount,
        'discount': discount,
        'total': amount - discount,
        'invoiceDate': Timestamp.fromDate(invoiceDate),
      };
      await _firestore.collection('invoices').doc(invoiceId).update(updatedInvoice);
      final index = invoices.indexWhere((inv) => inv['id'] == invoiceId);
      if (index != -1) {
        invoices[index] = {...invoices[index], ...updatedInvoice, 'id': invoiceId};
        filteredInvoices[index] = invoices[index];
      }
      Get.snackbar('Success', 'Invoice updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update invoice: $e');
    }
  }

  void filterInvoices(String query) {
    _searchQuery = query.isEmpty ? null : query.toLowerCase();
    _applyFilters();
  }

  void applyFilters(String status, DateTime date) {
    _filterStatus = status == 'All' ? null : status;
    _filterDate = date;
    _applyFilters();
  }

  void _applyFilters() {
    filteredInvoices.assignAll(invoices.where((invoice) {
      final matchesSearch = _searchQuery == null ||
          invoice['patientName'].toString().toLowerCase().contains(_searchQuery!) ||
          invoice['patientId'].toString().toLowerCase().contains(_searchQuery!);
      final matchesStatus = _filterStatus == null || invoice['status'] == _filterStatus;
      final matchesDate = _filterDate == null ||
          DateFormat.yMd().format(invoice['invoiceDate'].toDate()) == DateFormat.yMd().format(_filterDate!);
      return matchesSearch && matchesStatus && matchesDate;
    }).toList());
  }

  Future<void> exportInvoiceAsPdf(Map<String, dynamic> invoice) async {
    try {
      final pdf = pw.Document();
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Invoice', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Patient Name: ${invoice['patientName']}'),
              pw.Text('Patient ID: ${invoice['patientId']}'),
              pw.Text('Date: ${DateFormat.yMd().format(invoice['invoiceDate'].toDate())}'),
              pw.Text('Amount: \$${invoice['amount'].toStringAsFixed(2)}'),
              pw.Text('Discount: \$${invoice['discount'].toStringAsFixed(2)}'),
              pw.Text('Total: \$${invoice['total'].toStringAsFixed(2)}'),
              pw.Text('Status: ${invoice['status']}'),
            ],
          ),
        ),
      );
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/invoice_${invoice['patientId']}.pdf');
      await file.writeAsBytes(await pdf.save());
      Get.snackbar('Success', 'PDF exported to ${file.path}');
    } catch (e) {
      Get.snackbar('Error', 'Failed to export PDF: $e');
    }
  }

//   Future<void> sendInvoiceEmail(Map<String, dynamic> invoice) async {
//     try {
//       final smtpServer = gmail('your-email@gmail.com', 'your-app-password'); // Replace with your credentials
//       final message = Message()
//         ..from = const Address('your-email@gmail.com', 'Your Clinic')
//         ..recipients.add('recipient-email@example.com') // Replace with actual recipient
//         ..subject = 'Invoice #${invoice['id']}'
//         ..text = '''
// Invoice Details:
// Patient Name: ${invoice['patientName']}
// Patient ID: ${invoice['patientId']}
// Date: ${DateFormat.yMd().format(invoice['invoiceDate'].toDate())}
// Amount: \$${invoice['amount'].toStringAsFixed(2)}
// Discount: \$${invoice['discount'].toStringAsFixed(2)}
// Total: \$${invoice['total'].toStringAsFixed(2)}
// Status: ${invoice['status']}
// ''';

//       final sendReport = await send(message, smtpServer);
//       Get.snackbar('Success', 'Invoice sent via email');
//     } catch (e) {
//       Get.snackbar('Error', 'Failed to send email: $e');
//     }
//   }

  Future<void> viewPaymentRecords(String invoiceId) async {
    try {
      final snapshot = await _firestore
          .collection('invoices')
          .doc(invoiceId)
          .collection('payments')
          .get();
      final payments = snapshot.docs.map((doc) => doc.data()).toList();
      Get.defaultDialog(
        title: 'Payment Records',
        content: payments.isEmpty
            ? Text('No payment records found.', style: GoogleFonts.poppins())
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: payments.map((payment) {
                  return ListTile(
                    title: Text('Amount: \$${payment['amount'].toStringAsFixed(2)}', style: GoogleFonts.poppins()),
                    subtitle: Text(
                      'Date: ${DateFormat.yMd().format(payment['date'].toDate())}',
                      style: GoogleFonts.poppins(),
                    ),
                  );
                }).toList(),
              ),
        textCancel: 'Close',
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch payment records: $e');
    }
  }
}