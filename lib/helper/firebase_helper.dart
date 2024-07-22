import 'dart:convert'; // for the utf8.encode method

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../model/user_model.dart';
import 'auth_helper.dart';

class FireStoreHelper {
  FireStoreHelper._();

  static final FireStoreHelper storeHelper = FireStoreHelper._();
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String collection = "users";
  String colUsername = "username";
  String colEmail = "email";
  String colPassword = "password";
  String colRole = "role";
  String colAttendance = "attendance";

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final hashed = sha256.convert(bytes);
    return hashed.toString();
  }

  Future<void> signUp(
      {required UserModel userModel, required String role}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: userModel.email,
        password: userModel.password,
      );

      if (userCredential.user != null) {
        String hashedPassword = hashPassword(userModel.password);

        Map<String, dynamic> data = {
          colUsername: userModel.username,
          colEmail: userModel.email,
          colPassword: hashedPassword,
          colRole: role,
        };

        await firestore
            .collection(collection)
            .doc(userCredential.user!.uid)
            .set(data);
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print("Error signing up: The email address is already in use.");
      } else {
        print("Error signing up: $e");
      }
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  Future<void> logIn({required UserModel userModel}) async {
    User? user = await AuthHelper.authHelper.logIn(
      email: userModel.email,
      password: userModel.password,
    );
    if (user != null) {
      return;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUser() {
    return firestore.collection(collection).snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserRole(String userId) {
    return firestore.collection(collection).doc(userId).get();
  }

  Future<List<UserModel>> fetchAllUsers() async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await firestore.collection(collection).get();
    return snapshot.docs.map((doc) => UserModel.fromMap(doc.data())).toList();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAttendanceRecordsForMonth(
      String userId, DateTime selectedMonth) async {
    try {
      DateTime startOfMonth =
          DateTime(selectedMonth.year, selectedMonth.month, 1);
      DateTime endOfMonth =
          DateTime(selectedMonth.year, selectedMonth.month + 1, 0, 23, 59, 59);

      return firestore
          .collection('users')
          .doc(userId)
          .collection('attendance')
          .where('checkIn', isGreaterThanOrEqualTo: startOfMonth)
          .where('checkIn', isLessThanOrEqualTo: endOfMonth)
          .get();
    } catch (e) {
      print("Error fetching attendance records: $e");
      rethrow;
    }
  }

  Future<void> checkInAndOut({required GlobalKey<SlideActionState> key}) async {
    Logger logger = Logger();
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
    String time = DateFormat('HH-mm-ss').format(DateTime.now());
    User? currentUser = AuthHelper.authHelper.getCurrentUser();

    DocumentSnapshot snapshot2 = await firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('attendance')
        .doc(today)
        .get();

    if (snapshot2.exists) {
      try {
        Timestamp checkinTimestamp = snapshot2['checkIn'];
        await firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('attendance')
            .doc(today)
            .update({
          'checkIn': checkinTimestamp,
          'checkout': FieldValue.serverTimestamp()
        });
      } catch (e) {
        logger.e("Error updating checkout time: ${e}");
      }
    } else {
      try {
        await firestore
            .collection('users')
            .doc(currentUser.uid)
            .collection('attendance')
            .doc(today)
            .set({'checkIn': FieldValue.serverTimestamp()});
        key.currentState?.reset();
      } catch (e) {
        logger.e("Error setting checkin time: ${e}");
      }
    }
  }
}
