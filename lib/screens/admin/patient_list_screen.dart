import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Admission {
  final String id;
  final String patientName;
  final String ward;
  final String doctor;
  final DateTime admissionDate;

  Admission({
    required this.id,
    required this.patientName,
    required this.ward,
    required this.doctor,
    required this.admissionDate,
  });

  factory Admission.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Admission(
      id: doc.id,
      patientName: data['patientName'] ?? '',
      ward: data['ward'] ?? '',
      doctor: data['doctor'] ?? '',
      admissionDate: (data['admissionDate'] is Timestamp)
          ? (data['admissionDate'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }
}

class AdmissionListScreen extends StatefulWidget {
  const AdmissionListScreen({super.key});

  @override
  _AdmissionListScreenState createState() => _AdmissionListScreenState();
}

class _AdmissionListScreenState extends State<AdmissionListScreen> {
  final ValueNotifier<List<Admission>> admissions =
      ValueNotifier<List<Admission>>([]);
  final ValueNotifier<List<Admission>> filteredAdmissions =
      ValueNotifier<List<Admission>>([]);
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // 🔹 Fetch admissions in real-time
    FirebaseFirestore.instance
        .collection('admissions')
        .snapshots()
        .listen((snapshot) {
      admissions.value =
          snapshot.docs.map((doc) => Admission.fromFirestore(doc)).toList();
      filterAdmissions();
    });

    // 🔹 Listen for search changes
    _searchController.addListener(filterAdmissions);
  }

  // 🔹 Filter logic
  void filterAdmissions() {
    final query = _searchController.text.toLowerCase();
    if (query.isEmpty) {
      filteredAdmissions.value = admissions.value;
    } else {
      filteredAdmissions.value = admissions.value.where((admission) {
        return admission.patientName.toLowerCase().contains(query) ||
            admission.ward.toLowerCase().contains(query) ||
            admission.doctor.toLowerCase().contains(query);
      }).toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admissions"),
        backgroundColor: Colors.indigo[400],
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          fontFamily: 'Roboto',
        ),
      ),
      body: Column(
        children: [
          // 🔹 Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: "Search Admissions",
                prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),

          // 🔹 List with DataTable
          Expanded(
            child: ValueListenableBuilder<List<Admission>>(
              valueListenable: filteredAdmissions,
              builder: (context, admissionsList, _) {
                if (admissionsList.isEmpty) {
                  return const Center(
                    child: Text(
                      "No admissions found.",
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.indigo,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columns: const [
                        DataColumn(
                          label: Text(
                            "Patient Name",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Ward",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Doctor",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          ),
                        ),
                        DataColumn(
                          label: Text(
                            "Admission Date",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.indigo),
                          ),
                        ),
                      ],
                      rows: admissionsList.map((admission) {
                        return DataRow(cells: [
                          DataCell(Text(admission.patientName)),
                          DataCell(Text(admission.ward)),
                          DataCell(Text(admission.doctor)),
                          DataCell(Text(
                              "${admission.admissionDate.day}-${admission.admissionDate.month}-${admission.admissionDate.year}")),
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    admissions.dispose();
    filteredAdmissions.dispose();
    super.dispose();
  }
}
