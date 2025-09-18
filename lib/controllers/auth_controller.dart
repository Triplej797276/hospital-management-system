import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/screens/home_screen.dart';
import 'package:hsmproject/screens/doctor/dashboard_screen.dart';
import 'package:hsmproject/screens/receptionist/receptionist_dashboard_screen.dart';
import 'package:hsmproject/screens/accountant/accountant_dashboard_screen.dart';
import 'package:hsmproject/screens/laboratorist/laboratorist_dashboard_screen.dart';
import 'package:hsmproject/screens/pharmacist/pharmacist_dashboard_screen.dart';
import 'package:hsmproject/screens/nurse/nurse_dashboard_screen.dart';
import 'package:hsmproject/screens/case_manager/case_manager_dashboard_screen.dart';
import 'package:hsmproject/screens/role_selection_screen.dart';

import '../screens/patient/patient_dashboard_screen.dart';

class AuthController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Rx<User?> user = Rx<User?>(null);
  final RxString userRole = ''.obs;
  final RxBool isLoading = false.obs;
  int loginAttempts = 0;

  @override
  void onInit() {
    super.onInit();
    user.bindStream(_auth.authStateChanges());
    ever(user, (User? firebaseUser) async {
      if (firebaseUser != null) {
        await _fetchUserRole(firebaseUser.uid);
        _navigateBasedOnRole();
      } else {
        userRole.value = '';
        Get.offAll(() => const RoleSelectionScreen());
      }
    });
  }

  Future<void> signIn(String email, String password, String role) async {
    try {
      if (email.isEmpty ||
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        Get.snackbar('Error', 'Please enter a valid email address');
        return;
      }

      if (role == 'receptionist' ||
          role == 'laboratorist' ||
          role == 'pharmacist' ||
          role == 'nurse' ||
          role == 'case_manager') {
        if (password.isEmpty || !RegExp(r'^\d+$').hasMatch(password)) {
          Get.snackbar('Error', 'Password must contain only numbers');
          return;
        }
        if (password.length < 6) {
          Get.snackbar('Error', 'Password must be at least 6 digits');
          return;
        }
      } else if (role != 'patient') {
        if (password.isEmpty || password.length < 6) {
          Get.snackbar('Error', 'Password must be at least 6 characters');
          return;
        }
      }

      if (loginAttempts >= 3) {
        Get.snackbar('Error', 'Too many login attempts. Please try again later.');
        return;
      }

      isLoading.value = true;
      loginAttempts++;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        await _fetchUserRole(firebaseUser.uid);
        if (userRole.value.isEmpty) {
          Get.snackbar('Error', 'User not found in any role-specific collection');
          await _auth.signOut();
        } else if (userRole.value != role) {
          Get.snackbar('Error', 'Selected role does not match user role');
          await _auth.signOut();
        } else {
          loginAttempts = 0;
          _navigateBasedOnRole();
        }
      } else {
        Get.snackbar('Error', 'Failed to retrieve user information after sign-in');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'invalid-credential':
          errorMessage = 'Incorrect email or password.';
          break;
        case 'user-disabled':
          errorMessage = 'This user account has been disabled.';
          break;
        case 'too-many-requests':
          errorMessage = 'Too many login attempts. Please try again later.';
          break;
        default:
          errorMessage = 'Failed to sign in: ${e.message}';
      }
      Get.snackbar('Sign-In Error', errorMessage);
    } catch (e) {
      Get.snackbar('Sign-In Error', 'Failed to sign in: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> registerUser({
    required String email,
    required String password,
    required String name,
    required String role,
    required String collection,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      if (email.isEmpty ||
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        Get.snackbar('Error', 'Please enter a valid email address');
        return;
      }
      if (name.isEmpty) {
        Get.snackbar('Error', 'Please enter your full name');
        return;
      }
      if (role == 'receptionist' ||
          role == 'laboratorist' ||
          role == 'pharmacist' ||
          role == 'nurse' ||
          role == 'case_manager') {
        if (password.isEmpty || !RegExp(r'^\d+$').hasMatch(password)) {
          Get.snackbar('Error', 'Password must contain only numbers');
          return;
        }
        if (password.length < 6) {
          Get.snackbar('Error', 'Password must be at least 6 digits');
          return;
        }
      } else if (role != 'patient') {
        if (password.isEmpty || password.length < 6) {
          Get.snackbar('Error', 'Password must be at least 6 characters');
          return;
        }
      }

      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: password,
      );
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        Map<String, dynamic> userData = {
          'email': email.trim().toLowerCase(),
          'name': name,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        };
        if (additionalData != null) {
          userData.addAll(additionalData);
        }

        await _firestore.collection(collection).doc(firebaseUser.uid).set(userData);
        userRole.value = role;
        loginAttempts = 0;
        _navigateBasedOnRole();
      } else {
        Get.snackbar('Error', 'Failed to retrieve user information after registration');
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'email-already-in-use':
          errorMessage = 'The email address is already registered.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'weak-password':
          errorMessage = 'The password is too weak.';
          break;
        case 'operation-not-allowed':
          errorMessage = 'Email/password accounts are not enabled.';
          break;
        default:
          errorMessage = 'Failed to register: ${e.message}';
      }
      Get.snackbar('Registration Error', errorMessage);
    } catch (e) {
      Get.snackbar('Registration Error', 'Failed to register: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _fetchUserRole(String uid) async {
    try {
      User? currentUser = _auth.currentUser;
      String? email = currentUser?.email?.toLowerCase();

      if (email == null) {
        userRole.value = '';
        Get.snackbar('Error', 'No email found for the current user');
        return;
      }

      const roleCollections = {
        'admin': 'admin',
        'doctor': 'doctors',
        'accountant': 'accountants',
        'receptionist': 'receptionists',
        'laboratorist': 'laboratorists',
        'pharmacist': 'pharmacists',
        'nurse': 'nurses',
        'patient': 'patients',
        'case_manager': 'case_managers',
      };

      for (var entry in roleCollections.entries) {
        String role = entry.key;
        String collection = entry.value;
        QuerySnapshot querySnapshot = await _firestore
            .collection(collection)
            .where('email', isEqualTo: email)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          userRole.value = role;
          return;
        }
      }

      userRole.value = '';
      Get.snackbar('Error', 'No role found for this user');
    } catch (e) {
      userRole.value = '';
      Get.snackbar('Error', 'Failed to fetch user role: ${e.toString()}');
    }
  }

  void _navigateBasedOnRole() {
    if (userRole.value.isNotEmpty && Get.currentRoute != '/${userRole.value}_dashboard') {
      switch (userRole.value) {
        case 'admin':
          Get.offAll(() => HomeScreen());
          break;
        case 'doctor':
          Get.offAll(() => const DashboardScreen());
          break;
        case 'accountant':
          Get.offAll(() => const AccountantDashboardScreen());
          break;
        case 'receptionist':
          Get.offAll(() => const ReceptionistDashboardScreen());
          break;
        case 'laboratorist':
          Get.offAll(() => const LaboratoristDashboardScreen());
          break;
        case 'pharmacist':
          Get.offAll(() => const PharmacistDashboardScreen());
          break;
        case 'nurse':
          Get.offAll(() => const NurseDashboardScreen());
          break;
        case 'patient':
          Get.offAll(() => PatientDashboardScreen());
          break;
        case 'case_manager':
          Get.offAll(() => const CaseManagerDashboardScreen());
          break;
        default:
          Get.offAll(() => const RoleSelectionScreen());
          Get.snackbar('Role Error', 'Invalid role assigned');
      }
    } else if (userRole.value.isEmpty) {
      Get.offAll(() => const RoleSelectionScreen());
      Get.snackbar('Role Error', 'Please select a role to continue');
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      userRole.value = '';
      loginAttempts = 0;
      Get.offAll(() => const RoleSelectionScreen());
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out: ${e.toString()}');
    }
  }
}