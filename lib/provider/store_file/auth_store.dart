import 'dart:convert';

import 'package:attendence_management_system/helper/auth_helper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
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

  void checkUserRole(String userId) async {
    DocumentSnapshot<Map<String, dynamic>> userDoc =
        await FireStoreHelper.storeHelper.getUserRole(userId);
    if (userDoc.exists) {
      String role = userDoc.data()!['role'];
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

  hideOrShowPassword() {
    runInAction(() => hide.value = !hide.value);
  }

  String hashPassword(String password) {
    final bytes = utf8.encode(password);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}
