import 'dart:convert'; // for the utf8.encode method

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

        await firestore
            .collection(collection)
            .doc(userCredential.user!.uid)
            .collection("attendance")
            .doc(userCredential.user!.uid)
            .set({'checkIn': DateTime.now(), 'checkout': DateTime.now()});
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

  Future<void> addAttendanceRecord(String userId, DateTime checkIn) async {
    final attendanceDoc = firestore
        .collection(collection)
        .doc(userId)
        .collection(colAttendance)
        .doc(userId);

    final docSnapshot = await attendanceDoc.get();

    if (docSnapshot.exists) {
      await attendanceDoc.update({
        'checkIn': checkIn,
      });
    } else {
      await attendanceDoc.set({
        'checkIn': checkIn,
      });
    }
  }

  Future<DateTime?> getLatestCheckInTime(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection(collection)
          .doc(userId)
          .collection(colAttendance)
          .doc(userId)
          .get();
      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        if (data != null && data.containsKey('checkIn')) {
          return (data['checkIn'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      print("Error fetching latest check-in time: $e");
    }
    return null;
  }

  Future<void> addCheckoutRecord(String userId, DateTime checkOut) async {
    final attendanceDoc = firestore
        .collection(collection)
        .doc(userId)
        .collection(colAttendance)
        .doc(userId);

    try {
      await attendanceDoc.update({
        'checkout': checkOut,
      });
    } catch (e) {
      // If the document does not exist, create it
      await attendanceDoc.set({
        'checkout': checkOut,
      });
    }
  }

  Future<DateTime?> getLatestCheckOutTime(String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection(collection)
          .doc(userId)
          .collection(colAttendance)
          .doc(userId)
          .get();

      if (snapshot.exists) {
        Map<String, dynamic>? data = snapshot.data();
        if (data != null && data.containsKey('checkout')) {
          return (data['checkout'] as Timestamp).toDate();
        }
      }
    } catch (e) {
      print("Error fetching latest check-out time: $e");
    }
    return null;
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
}
