import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LaboratoristBloodBankScreen extends StatefulWidget {
  const LaboratoristBloodBankScreen({super.key});

  @override
  State<LaboratoristBloodBankScreen> createState() => _LaboratoristBloodBankScreenState();
}

class _LaboratoristBloodBankScreenState extends State<LaboratoristBloodBankScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _unitsController = TextEditingController();
  final TextEditingController _expirationDateController = TextEditingController();
  String? _selectedBloodType;
  final List<String> _bloodTypes = ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Manage Blood Bank',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.teal.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Blood Bank Management',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
              ),
              const SizedBox(height: 20),
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Add to Blood Inventory',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.teal,
                            ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'Add new blood stock to the inventory.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                        value: _selectedBloodType,
                        decoration: const InputDecoration(
                          labelText: 'Blood Type',
                          border: OutlineInputBorder(),
                        ),
                        items: _bloodTypes.map((String bloodType) {
                          return DropdownMenuItem<String>(
                            value: bloodType,
                            child: Text(bloodType),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedBloodType = newValue;
                          });
                        },
                        validator: (value) => value == null ? 'Please select a blood type' : null,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _unitsController,
                        decoration: const InputDecoration(
                          labelText: 'Units Available',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _expirationDateController,
                        decoration: const InputDecoration(
                          labelText: 'Expiration Date (MM/DD/YYYY)',
                          border: OutlineInputBorder(),
                        ),
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            String formattedDate = DateFormat('MM/dd/yyyy').format(pickedDate);
                            _expirationDateController.text = formattedDate;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _addToInventory,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.teal,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Add Blood Stock'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current Blood Inventory',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.teal,
                              ),
                        ),
                        const SizedBox(height: 10),
                        Expanded(
                          child: StreamBuilder<QuerySnapshot>(
                            stream: _firestore.collection('blood_inventory').snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const Center(child: CircularProgressIndicator());
                              }
                              if (snapshot.hasError) {
                                return Center(child: Text('Error: ${snapshot.error}'));
                              }
                              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                                return const Center(child: Text('No blood stock available.'));
                              }
                              return ListView.builder(
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (context, index) {
                                  final doc = snapshot.data!.docs[index];
                                  final data = doc.data() as Map<String, dynamic>;
                                  return ListTile(
                                    leading: CircleAvatar(
                                      backgroundColor: Colors.teal.shade100,
                                      child: Text(
                                        data['blood_type']?.toString() ?? '',
                                        style: const TextStyle(color: Colors.teal),
                                      ),
                                    ),
                                    title: Text(data['blood_type']?.toString() ?? 'Unknown'),
                                    subtitle: Text(
                                      '${data['units']} units, Expires: ${data['expiration_date'] ?? 'N/A'}',
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteStock(doc.id),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addToInventory() {
    final units = int.tryParse(_unitsController.text.trim());
    final expirationDate = _expirationDateController.text.trim();

    if (_selectedBloodType == null || units == null || units <= 0 || expirationDate.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields with valid data.')),
      );
      return;
    }

    _firestore.collection('blood_inventory').add({
      'blood_type': _selectedBloodType,
      'units': units,
      'expiration_date': expirationDate,
      'added_at': FieldValue.serverTimestamp(),
    }).then((_) {
      _selectedBloodType = null;
      _unitsController.clear();
      _expirationDateController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blood stock added successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding stock: $error')),
      );
    });
  }

  void _deleteStock(String docId) {
    _firestore.collection('blood_inventory').doc(docId).delete().then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Blood stock deleted successfully!')),
      );
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting stock: $error')),
      );
    });
  }

  @override
  void dispose() {
    _unitsController.dispose();
    _expirationDateController.dispose();
    super.dispose();
  }
}