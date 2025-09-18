import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hsmproject/screens/patient/patient_dashboard_screen.dart';

class PatientController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final RxBool isLoading = false.obs;

  Future<void> signIn(String email, String phone) async {
    try {
      if (email.isEmpty ||
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        Get.snackbar('Error', 'Please enter a valid email address');
        return;
      }
      if (phone.isEmpty || phone.length < 10) {
        Get.snackbar('Error', 'Contact number must be at least 10 characters');
        return;
      }

      isLoading.value = true;
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: phone,
      );
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        DocumentSnapshot userDoc = await _firestore
            .collection('patients')
            .doc(firebaseUser.uid)
            .get();
        
        if (!userDoc.exists || userDoc['role'] != 'patient') {
          Get.snackbar('Error', 'User not found or not registered as a patient');
          await _auth.signOut();
          return;
        }

        Get.offAll(() => PatientDashboardScreen());
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
          errorMessage = 'Incorrect email or contact number.';
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

  Future<void> registerPatient({
    required String email,
    required String contactNumber,
    required String name,
    required int age,
    required String condition,
  }) async {
    try {
      if (email.isEmpty ||
          !RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
        Get.snackbar('Error', 'Please enter a valid email address');
        return;
      }
      if (name.isEmpty) {
        Get.snackbar('Error', 'Please enter patient name');
        return;
      }
      if (age <= 0) {
        Get.snackbar('Error', 'Please enter a valid age');
        return;
      }
      if (condition.isEmpty) {
        Get.snackbar('Error', 'Please enter a medical condition');
        return;
      }
      if (contactNumber.isEmpty || contactNumber.length < 10) {
        Get.snackbar('Error', 'Contact number must be at least 10 characters');
        return;
      }

      isLoading.value = true;
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim().toLowerCase(),
        password: contactNumber,
      );
      User? firebaseUser = userCredential.user;

      if (firebaseUser != null) {
        await _firestore.collection('patients').doc(firebaseUser.uid).set({
          'email': email.trim().toLowerCase(),
          'name': name,
          'age': age,
          'condition': condition,
          'contact_number': contactNumber,
          'role': 'patient',
          'createdAt': FieldValue.serverTimestamp(),
        });

        Get.back();
        Get.snackbar('Success', 'Patient added successfully');
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
          errorMessage = 'The contact number is too weak. Please use at least 10 characters.';
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
}