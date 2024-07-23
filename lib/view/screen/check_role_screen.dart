import 'package:attendence_management_system/provider/store_file/auth_store.dart';
import 'package:attendence_management_system/view/screen/sign_up_screen.dart';
import 'package:attendence_management_system/view/screen/student/home/home_bottom_navigation_screen.dart';
import 'package:attendence_management_system/view/screen/teacher/home/home_paget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../helper/auth_helper.dart';
import '../../provider/get_store.dart';

class CheckRoleScreen extends StatefulWidget {
  const CheckRoleScreen({Key? key}) : super(key: key);

  @override
  State<CheckRoleScreen> createState() => _CheckRoleScreenState();
}

class _CheckRoleScreenState extends State<CheckRoleScreen> {
  AuthStore authStore = getIt<AuthStore>();

  @override
  Widget build(BuildContext context) {
    User? currentUser = AuthHelper.authHelper.getCurrentUser();
    if (currentUser == null) {
      return const SignUpScreen();
    } else {
      return Builder(builder: (_) {
        return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
          future: authStore.checkUserRole(currentUser.uid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(
                    color: Colors.black,
                    backgroundColor: Colors.white,
                  ),
                ),
              );
            }
            if (snapshot.hasError ||
                !snapshot.hasData ||
                !snapshot.data!.exists) {
              return const Scaffold(
                body: Center(
                  child: Text('Error loading user role'),
                ),
              );
            }

            String role = snapshot.data!.data()!['role'];
            if (role == 'User') {
              return const HomeBottomNavigationScreen();
            } else if (role == 'Admin') {
              return const THomePage();
            } else {
              return const Scaffold(
                body: Center(
                  child: Text('Unauthorized access'),
                ),
              );
            }
          },
        );
      });
    }
  }
}
