import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/doctors/bed_management_controller.dart';
class BedManagementScreen extends StatefulWidget {
  const BedManagementScreen({super.key});

  @override
  _BedManagementScreenState createState() => _BedManagementScreenState();
}

class _BedManagementScreenState extends State<BedManagementScreen> {
  List<Bed> beds = [];
  List<Patient> patients = [];
  List<Bed> filteredBeds = [];
  final BedManagementController _controller = BedManagementController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.fetchBeds().listen((bedList) {
      setState(() {
        beds = bedList;
        filteredBeds = beds;
      });
    });
    _controller.fetchPatients().listen((patientList) {
      setState(() {
        patients = patientList;
        _filterData();
      });
    });
    _searchController.addListener(_filterData);
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredBeds = beds.where((bed) {
        final patientName = bed.isOccupied
            ? patients
                .firstWhere(
                  (patient) => patient.id == bed.patientId,
                  orElse: () => Patient(id: '', name: 'Unknown'),
                )
                .name
                .toLowerCase()
            : '';
        return bed.bedNumber.toLowerCase().contains(query) ||
            bed.ward.toLowerCase().contains(query) ||
            patientName.contains(query);
      }).toList();
    });
  }

  void _showAssignPatientDialog(BuildContext context, String bedId) {
    String? selectedPatientId;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              title: Text(
                'Assign Patient to Bed',
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800]),
              ),
              content: Container(
                width: double.maxFinite,
                child: DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: 'Select Patient',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                  value: selectedPatientId,
                  items: patients.map((patient) {
                    return DropdownMenuItem(
                      value: patient.id,
                      child: Text(patient.name),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedPatientId = value;
                    });
                  },
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: () async {
                    if (selectedPatientId != null) {
                      try {
                        await _controller.assignBed(bedId, selectedPatientId!);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Bed assigned successfully'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('$e'), backgroundColor: Colors.red),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Please select a patient'), backgroundColor: Colors.red),
                      );
                    }
                  },
                  child: Text('Assign', style: TextStyle(color: Colors.white)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showAddPatientDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Add New Patient',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800]),
          ),
          content: TextField(
            controller: nameController,
            decoration: InputDecoration(
              labelText: 'Patient Name',
              border: OutlineInputBorder(),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (nameController.text.isNotEmpty) {
                  try {
                    await _controller.addPatient(nameController.text);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Patient added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  void _showAddBedDialog(BuildContext context) {
    final TextEditingController wardController = TextEditingController();
    final TextEditingController bedNumberController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(
            'Add New Bed',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800]),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: wardController,
                  decoration: InputDecoration(
                    labelText: 'Ward (e.g., General, ICU)',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: bedNumberController,
                  decoration: InputDecoration(
                    labelText: 'Bed Number',
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.grey[100],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: Colors.grey[600])),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () async {
                if (wardController.text.isNotEmpty && bedNumberController.text.isNotEmpty) {
                  try {
                    await _controller.addBed(wardController.text, bedNumberController.text);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Bed added successfully'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$e'), backgroundColor: Colors.red),
                    );
                  }
                }
              },
              child: Text('Add', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bed Management',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.teal,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[50]!, Colors.white],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search beds or patients...',
                  prefixIcon: Icon(Icons.search, color: Colors.teal),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(vertical: 0),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Beds and Patients',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[800],
                ),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 16.0),
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 20,
                      columns: [
                        DataColumn(
                          label: Text(
                            'Bed Number',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800]),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Ward',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800]),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Status',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800]),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Patient Name',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800]),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Patient ID',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800]),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            'Action',
                            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.teal[800]),
                          ),
                        ),
                      ],
                      rows: filteredBeds.map((bed) {
                        final patient = bed.isOccupied
                            ? patients.firstWhere(
                                (patient) => patient.id == bed.patientId,
                                orElse: () => Patient(id: '', name: 'None'),
                              )
                            : Patient(id: '', name: 'None');
                        return DataRow(cells: [
                          DataCell(Text(bed.bedNumber)),
                          DataCell(Text(bed.ward)),
                          DataCell(
                            Text(
                              bed.isOccupied ? 'Occupied' : 'Available',
                              style: TextStyle(
                                color: bed.isOccupied ? Colors.red : Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          DataCell(Text(patient.name)),
                          DataCell(Text(patient.id)),
                          DataCell(
                            bed.isOccupied
                                ? IconButton(
                                    icon: Icon(Icons.remove_circle, color: Colors.red),
                                    onPressed: () async {
                                      try {
                                        await _controller.unassignBed(bed.id);
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text('Bed unassigned successfully'),
                                            backgroundColor: Colors.green,
                                          ),
                                        );
                                      } catch (e) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(content: Text('$e'), backgroundColor: Colors.red),
                                        );
                                      }
                                    },
                                  )
                                : IconButton(
                                    icon: Icon(Icons.add_circle, color: Colors.teal),
                                    onPressed: () => _showAssignPatientDialog(context, bed.id),
                                  ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );  
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}