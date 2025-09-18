import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

// Model for Blood Bag
class BloodBag {
  final String id;
  final String bloodGroup;
  final int quantity;
  final DateTime averageAge;
  final int outdated;

  BloodBag({
    required this.id,
    required this.bloodGroup,
    required this.quantity,
    required this.averageAge,
    required this.outdated,
  });

  factory BloodBag.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return BloodBag(
      id: doc.id,
      bloodGroup: data['bloodGroup'] ?? '',
      quantity: data['quantity'] ?? 0,
      averageAge: (data['averageAge'] as Timestamp).toDate(),
      outdated: data['outdated'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'bloodGroup': bloodGroup,
      'quantity': quantity,
      'averageAge': Timestamp.fromDate(averageAge),
      'outdated': outdated,
    };
  }
}

// Model for Blood Donor
class BloodDonor {
  final String id;
  final String name;
  final DateTime donationDate;
  final String bloodGroup;
  final String gender;

  BloodDonor({
    required this.id,
    required this.name,
    required this.donationDate,
    required this.bloodGroup,
    required this.gender,
  });

  factory BloodDonor.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return BloodDonor(
      id: doc.id,
      name: data['name'] ?? '',
      donationDate: (data['donationDate'] as Timestamp).toDate(),
      bloodGroup: data['bloodGroup'] ?? '',
      gender: data['gender'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'donationDate': Timestamp.fromDate(donationDate),
      'bloodGroup': bloodGroup,
      'gender': gender,
    };
  }
}

// Controller to manage blood bank data with Firebase
class BloodBankController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<BloodBag>> get bloodBags {
    return _firestore.collection('bloodBags').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => BloodBag.fromFirestore(doc)).toList());
  }

  Stream<List<BloodDonor>> get donors {
    return _firestore.collection('donors').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => BloodDonor.fromFirestore(doc)).toList());
  }

  Future<void> addDonor(String name, String bloodGroup, String gender) async {
    await _firestore.collection('donors').add(BloodDonor(
      id: '',
      name: name,
      donationDate: DateTime.now(),
      bloodGroup: bloodGroup,
      gender: gender,
    ).toFirestore());
    update();
  }

  Future<void> updateBloodStock(String id, String bloodGroup, int quantity) async {
    await _firestore.collection('bloodBags').doc(id).update({
      'quantity': quantity,
    });
    update();
  }

  Future<void> initializeSampleData() async {
    final bloodBagsSnapshot = await _firestore.collection('bloodBags').get();
    if (bloodBagsSnapshot.docs.isEmpty) {
      final sampleBags = [
        BloodBag(
          id: '',
          bloodGroup: 'A+',
          quantity: 50,
          averageAge: DateTime.now().subtract(Duration(days: 10)),
          outdated: 5,
        ),
        BloodBag(
          id: '',
          bloodGroup: 'B+',
          quantity: 30,
          averageAge: DateTime.now().subtract(Duration(days: 15)),
          outdated: 3,
        ),
        BloodBag(
          id: '',
          bloodGroup: 'O+',
          quantity: 70,
          averageAge: DateTime.now().subtract(Duration(days: 8)),
          outdated: 2,
        ),
        BloodBag(
          id: '',
          bloodGroup: 'AB+',
          quantity: 20,
          averageAge: DateTime.now().subtract(Duration(days: 12)),
          outdated: 4,
        ),
      ];

      for (var bag in sampleBags) {
        await _firestore.collection('bloodBags').add(bag.toFirestore());
      }
    }

    final donorsSnapshot = await _firestore.collection('donors').get();
    if (donorsSnapshot.docs.isEmpty) {
      final sampleDonors = [
        BloodDonor(
          id: '',
          name: 'John Doe',
          donationDate: DateTime.now().subtract(Duration(days: 5)),
          bloodGroup: 'A+',
          gender: 'Male',
        ),
        BloodDonor(
          id: '',
          name: 'Jane Smith',
          donationDate: DateTime.now().subtract(Duration(days: 10)),
          bloodGroup: 'B+',
          gender: 'Female',
        ),
      ];

      for (var donor in sampleDonors) {
        await _firestore.collection('donors').add(donor.toFirestore());
      }
    }
  }
}