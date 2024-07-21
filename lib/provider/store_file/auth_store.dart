import 'dart:convert';

import 'package:attendence_management_system/helper/auth_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';

import '../../helper/firebase_helper.dart';
import '../../model/user_model.dart';

class AuthStore with Store {
  Logger logger = Logger();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  Observable<String?> selectedRole = Observable(null);
  Observable<List<String>> items = Observable(["User", "Admin"]);
  Observable<bool> hide = Observable(true);

  Observable<String> username = Observable('');
  Observable<String> email = Observable('');
  Observable<DateTime?> checkInTime = Observable(null);
  Observable<DateTime?> checkOutTime = Observable(null);
  Observable<List<Map<String, dynamic>>> dailyAttendanceRecords =
      Observable([]);

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  selectRole({required String value}) {
    runInAction(
      () {
        if (selectedRole.value == null ||
            !items.value.contains(selectedRole.value)) {
          selectedRole.value = items.value.first;
        } else {
          selectedRole.value = value;
        }
      },
    );
  }

  Future<void> signUp() async {
    final String email = emailController.text.trim();
    final String password = passwordController.text.trim();
    final String username = usernameController.text.trim();
    final String role = selectedRole.value!;

    UserModel userModel = UserModel(
        email: email, password: password, username: username, role: role);

    try {
      await FireStoreHelper.storeHelper
          .signUp(userModel: userModel, role: role);
    } catch (e) {
      print("Error signing up: $e");
    }
  }

  void logInUser(UserModel userModel) async {
    await FireStoreHelper.storeHelper.logIn(userModel: userModel);
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> checkUserRole(
      String userId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> userDoc =
          await FireStoreHelper.storeHelper.getUserRole(userId);
      return userDoc;
    } catch (e) {
      print('Failed to check user role: $e');
      // Return a DocumentSnapshot with an error or handle it appropriately
      return Future.error(e);
    }
  }

  Future<void> fetchUsername() async {
    try {
      User? currentUser = AuthHelper.authHelper.getCurrentUser();

      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        logger.d("UId :-${currentUser.uid}");
        runInAction(() {
          username.value = userDoc['username'];
        });
      } else {
        logger.e('No user is currently logged in');
      }
    } catch (e) {
      logger.e('Failed to fetch username: $e');
    }
  }

  Future<void> fetchEmail() async {
    try {
      User? currentUser = AuthHelper.authHelper.getCurrentUser();

      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        logger.d("UId :-${currentUser.uid}");
        runInAction(() {
          email.value = userDoc['email'];
        });
      } else {
        logger.e('No user is currently logged in');
      }
    } catch (e) {
      logger.e('Failed to fetch username: $e');
    }
  }

  Future<void> checkIn() async {
    runInAction(() async {
      try {
        User? currentUser = AuthHelper.authHelper.getCurrentUser();
        if (currentUser != null) {
          await FireStoreHelper.storeHelper
              .addAttendanceRecord(currentUser.uid, DateTime.now());
          logger.d('Check-in successful');
        } else {
          logger.e('No user is currently logged in');
        }
      } catch (e) {
        logger.e('Check-in failed: $e');
      }
    });
  }

  Future<void> fetchCheckInTime() async {
    try {
      User? currentUser = AuthHelper.authHelper.getCurrentUser();
      if (currentUser != null) {
        DateTime? checkIn = await FireStoreHelper.storeHelper
            .getLatestCheckInTime(currentUser.uid);
        runInAction(() {
          checkInTime.value = checkIn;
        });
      } else {
        logger.e('No user is currently logged in');
      }
    } catch (e) {
      logger.e('Failed to fetch check-in time: $e');
    }
  }

  Future<void> checkOut() async {
    try {
      User? currentUser = AuthHelper.authHelper.getCurrentUser();
      if (currentUser != null) {
        await FireStoreHelper.storeHelper
            .addCheckoutRecord(currentUser.uid, DateTime.now());
        logger.d('Check-out successful');
      } else {
        logger.e('No user is currently logged in');
      }
    } catch (e) {
      logger.e('Check-out failed: $e');
    }
  }

  Future<void> fetchCheckOutTime() async {
    try {
      User? currentUser = AuthHelper.authHelper.getCurrentUser();
      if (currentUser != null) {
        DateTime? checkOut = await FireStoreHelper.storeHelper
            .getLatestCheckOutTime(currentUser.uid);
        runInAction(() {
          checkOutTime.value = checkOut;
        });
      } else {
        logger.e('No user is currently logged in');
      }
    } catch (e) {
      logger.e('Failed to fetch check-out time: $e');
    }
  }

  Future<void> fetchDailyAttendanceRecords(
      {required String userId, required DateTime selectedMonth}) async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await FireStoreHelper
          .storeHelper
          .getAttendanceRecordsForMonth(userId, selectedMonth);
      List<Map<String, dynamic>> records =
          querySnapshot.docs.map((doc) => doc.data()).toList();
      runInAction(() {
        dailyAttendanceRecords.value = records;
      });
    } catch (e) {
      logger.e('Failed to fetch attendance records: $e');
    }
  }

  hideOrShowPassword() {
    runInAction(() => hide.value = !hide.value);
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Observable<String> selectedMonth =
      Observable(DateFormat('MMMM yyyy').format(DateTime.now()));

  Future<void> fetchAttendanceRecords(String userId) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('attendance')
          .where('date', isGreaterThanOrEqualTo: _startOfMonth())
          .where('date', isLessThanOrEqualTo: _endOfMonth())
          .get();

      List<Map<String, dynamic>> records =
          snapshot.docs.map((doc) => doc.data()).toList();

      runInAction(() {
        dailyAttendanceRecords.value = records;
      });
    } catch (e) {
      logger.e('Failed to fetch attendance records: $e');
    }
  }

  DateTime _startOfMonth() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, 1);
  }

  DateTime _endOfMonth() {
    DateTime now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0);
  }

  void setSelectedMonth(String month) {
    runInAction(() {
      selectedMonth.value = month;
    });
  }
}
