import 'package:attendence_management_system/view/screen/student/home/home_bottom_navigation_screen.dart';
import 'package:attendence_management_system/view/screen/student/sign_up_screen.dart';
import 'package:attendence_management_system/view/screen/teacher/home/home_paget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/auth_helper.dart';
import '../../helper/firebase_helper.dart';

class CheckRoleScreen extends StatefulWidget {
  const CheckRoleScreen({Key? key}) : super(key: key);

  @override
  State<CheckRoleScreen> createState() => _CheckRoleScreenState();
}

class _CheckRoleScreenState extends State<CheckRoleScreen> {
  @override
  Widget build(BuildContext context) {
    User? currentUser = AuthHelper.authHelper.getCurrentUser();
    if (currentUser == null) {
      return const SignUpScreen();
    } else {
      return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FireStoreHelper.storeHelper.getUserRole(currentUser.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          }
          if (snapshot.hasError ||
              !snapshot.hasData ||
              !snapshot.data!.exists) {
            return const Text('Error loading user role');
          }

          String role = snapshot.data!.data()!['role'];
          if (role == 'User') {
            return const HomeBottomNavigationScreen();
          } else if (role == 'Admin') {
            return const THomePage(); // Replace THomePage with your admin home page widget
          } else {
            return const Text(
                'Unauthorized access'); // Handle other roles or unexpected cases
          }
        },
      );
    }
  }
}
