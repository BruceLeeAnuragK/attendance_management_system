import 'dart:convert';
import 'dart:developer';

import 'package:attendence_management_system/helper/auth_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:mobx/mobx.dart';
import 'package:slide_to_act/slide_to_act.dart';

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
  Observable<String> role = Observable('');
  Observable<DateTime?> checkInTime = Observable(null);
  Observable<DateTime?> checkOutTime = Observable(null);
  Observable<List<Map<String, dynamic>>> dailyAttendanceRecords =
      Observable([]);
  ObservableList<UserModel> adminUsers = ObservableList<UserModel>();

  @observable
  ObservableList<UserModel> normalUsers = ObservableList<UserModel>();

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

  Future<void> logOut() async {
    await AuthHelper.authHelper.logOut();
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

  Future<void> fetchRole() async {
    try {
      User? currentUser = AuthHelper.authHelper.getCurrentUser();

      if (currentUser != null) {
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.uid)
            .get();
        logger.d("UId :-${currentUser.uid}");
        runInAction(() {
          role.value = userDoc['role'];
        });
      } else {
        logger.e('No user is currently logged in');
      }
    } catch (e) {
      logger.e('Failed to fetch username: $e');
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

  Future<void> updateUsername(String newUsername) async {
    try {
      User? currentUser = AuthHelper.authHelper.getCurrentUser();
      if (currentUser != null) {
        await firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({'username': newUsername});
        runInAction(() {
          username.value = newUsername;
        });
      } else {
        logger.e('No user is currently logged in');
      }
    } catch (e) {
      logger.e('Failed to update username: $e');
    }
  }

  Future<void> updateEmail(String newEmail) async {
    try {
      User? currentUser = AuthHelper.authHelper.getCurrentUser();
      if (currentUser != null) {
        await currentUser.updateEmail(newEmail);
        await firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({'email': newEmail});
        runInAction(() {
          email.value = newEmail;
        });
      } else {
        logger.e('No user is currently logged in');
      }
    } catch (e) {
      logger.e('Failed to update email: $e');
    }
  }

  Future<void> updateRole(String newRole) async {
    try {
      User? currentUser = AuthHelper.authHelper.getCurrentUser();
      if (currentUser != null) {
        await firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({'role': newRole});
        runInAction(() {
          role.value = newRole;
        });
      } else {
        logger.e('No user is currently logged in');
      }
    } catch (e) {
      logger.e('Failed to update role: $e');
    }
  }

  Future<void> updatePassword(String newPassword) async {
    try {
      User? currentUser = AuthHelper.authHelper.getCurrentUser();
      if (currentUser != null) {
        await currentUser.updatePassword(newPassword);
        String hashedPassword = hashPassword(newPassword);
        await firestore
            .collection('users')
            .doc(currentUser.uid)
            .update({'password': hashedPassword});
      } else {
        logger.e('No user is currently logged in');
      }
    } catch (e) {
      logger.e('Failed to update password: $e');
    }
  }

  void checkIfDayChanged() {
    DateTime now = DateTime.now();
    if (checkInTime.value != null && !isSameDay(checkInTime.value!, now)) {
      runInAction(() {
        checkInTime.value = null;
        checkOutTime.value = null;
      });
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  checkInAndOut({required GlobalKey<SlideActionState> key}) {
    FireStoreHelper.storeHelper.checkInAndOut(key: key);
  }

  fetchCheckInAndOut() async {
    try {
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      User? currentUser = AuthHelper.authHelper.getCurrentUser();
      DocumentSnapshot snapshot2 = await firestore
          .collection('users')
          .doc(currentUser!.uid)
          .collection('attendance')
          .doc(today)
          .get();

      runInAction(() {
        if (snapshot2.exists) {
          Timestamp? checkinTimestamp = snapshot2['checkIn'];
          Timestamp? checkoutTimestamp = snapshot2['checkout'];
          checkInTime.value = checkinTimestamp?.toDate();
          checkOutTime.value = checkoutTimestamp?.toDate();
          logger.d("CheckIn :- fetched ${checkInTime.value}");
          logger.d("CheckOut :- fetched ${checkOutTime.value}");
        } else {
          checkInTime.value = null;
          checkOutTime.value = null;
          logger.d("CheckIn :- No record for today");
          logger.d("CheckOut :- No record for today");
        }
      });
    } catch (e) {
      runInAction(() {
        checkInTime.value = null;
        checkOutTime.value = null;
        logger.e("Error fetching CheckIn/CheckOut :- ${e}");
      });
    }
  }

  Future<void> fetchAttendanceRecords(String userId) async {
    DateTime selectedDate = DateFormat('MMMM yyyy').parse(selectedMonth.value);
    DateTime startOfMonth = DateTime(selectedDate.year, selectedDate.month, 1);
    DateTime endOfMonth =
        DateTime(selectedDate.year, selectedDate.month + 1, 0, 23, 59, 59);

    log("Start Month : $startOfMonth");
    log("End Month : $endOfMonth");

    QuerySnapshot<Map<String, dynamic>> snapshot = await firestore
        .collection('users')
        .doc(userId)
        .collection('attendance')
        .where('checkIn',
            isGreaterThanOrEqualTo: Timestamp.fromDate(startOfMonth))
        .where('checkIn', isLessThanOrEqualTo: Timestamp.fromDate(endOfMonth))
        .get();

    runInAction(() {
      dailyAttendanceRecords.value.clear();
      snapshot.docs.forEach((doc) {
        dailyAttendanceRecords.value.add(doc.data());
      });
    });
  }

  Future<void> fetchAllUsers() async {
    List<UserModel> users = await FireStoreHelper.storeHelper.fetchAllUsers();
    adminUsers.clear();
    normalUsers.clear();
    for (var user in users) {
      if (user.role == 'Admin') {
        adminUsers.add(user);
      } else {
        normalUsers.add(user);
      }
    }
  }
}
