import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ServicesManagementController extends GetxController {
  // Use proper IconData instead of emojis
  var services = <Map<String, Object>>[
    {'icon': Icons.local_hospital, 'title': 'Ambulance', 'route': '/ambulance_services'},
    {'icon': Icons.shield, 'title': 'Insurance', 'route': '/insurance_services'},
    {'icon': Icons.inventory_2, 'title': 'Packages', 'route': '/packages_services'},
    // {'icon': Icons.science, 'title': 'Laboratory', 'route': '/laboratory_services'},
    // {'icon': Icons.local_pharmacy, 'title': 'Pharmacy', 'route': '/pharmacy_services'},
    // {'icon': Icons.bloodtype, 'title': 'Blood Bank', 'route': '/bloodbank_services'},
    // {'icon': Icons.bed, 'title': 'Beds/Rooms', 'route': '/bed_services'},
    {'icon': Icons.emergency, 'title': 'Emergency', 'route': '/emergency_services'},
  ].obs;
}
