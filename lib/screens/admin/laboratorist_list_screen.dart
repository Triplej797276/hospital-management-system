import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class LaboratoristListScreen extends StatelessWidget {
  const LaboratoristListScreen({super.key});

  // 🔹 Form dialog for adding a new laboratorist
  void _showAddLaboratoristForm(BuildContext context) {
    final nameController = TextEditingController();
    final contactController = TextEditingController();
    final emailController = TextEditingController();
    final roleController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text(
          'Add New Laboratorist',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
        ),
        content: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person, color: Colors.teal),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a name' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: contactController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'Contact',
                    prefixIcon: Icon(Icons.phone, color: Colors.teal),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter contact info' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email, color: Colors.teal),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter an email' : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: roleController,
                  decoration: const InputDecoration(
                    labelText: 'Role',
                    prefixIcon: Icon(Icons.badge, color: Colors.teal),
                  ),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Please enter a role' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
            onPressed: () async {
              if (formKey.currentState!.validate()) {
                try {
                  await FirebaseFirestore.instance.collection('laboratorists').add({
                    'name': nameController.text,
                    'contact': contactController.text,
                    'email': emailController.text,
                    'role': roleController.text,
                    'createdAt': FieldValue.serverTimestamp(),
                  });
                  Navigator.pop(context);
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error adding laboratorist: $e')),
                  );
                }
              }
            },
            icon: const Icon(Icons.add, color: Colors.white),
            label: const Text('Add'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Laboratorists"),
        backgroundColor: Colors.teal,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance.collection('laboratorists').orderBy('createdAt', descending: true).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error loading laboratorists"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final laboratorists = snapshot.data!.docs;

          if (laboratorists.isEmpty) {
            return const Center(
              child: Text(
                "No Laboratorists Found",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return Column(
            children: [
              // 🔹 Counter at the top
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.teal[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  "Total Laboratorists: ${laboratorists.length}",
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal),
                ),
              ),

              // 🔹 DataTable
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: MaterialStateProperty.all(Colors.teal[100]),
                      border: TableBorder.all(color: Colors.grey.shade300),
                      columns: const [
                        DataColumn(
                          label: Text(
                            "Name",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Contact",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Email",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Role",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Created At",
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal),
                          ),
                        ),
                      ],
                      rows: laboratorists.map((laboratorist) {
                        final createdAt = laboratorist['createdAt'] as Timestamp?;
                        return DataRow(cells: [
                          DataCell(Text(laboratorist['name'] ?? "Unknown")),
                          DataCell(Text(laboratorist['contact'] ?? "N/A")),
                          DataCell(Text(laboratorist['email'] ?? "N/A")),
                          DataCell(Text(laboratorist['role'] ?? "N/A")),
                          DataCell(Text(
                            createdAt != null
                                ? DateFormat('dd MMM yyyy, HH:mm').format(createdAt.toDate())
                                : 'N/A',
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),

      // 🔹 Floating button
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.teal,
        onPressed: () => _showAddLaboratoristForm(context),
        icon: const Icon(Icons.add),
        label: const Text("Add Laboratorist"),
      ),
    );
  }
}
