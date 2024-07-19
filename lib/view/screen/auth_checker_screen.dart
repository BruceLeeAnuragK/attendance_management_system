import 'package:attendence_management_system/view/screen/student/home/home_bottom_navigation_screen.dart';
import 'package:attendence_management_system/view/screen/student/login_screen.dart';
import 'package:attendence_management_system/view/screen/student/sign_up_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthCheckerScreen extends StatefulWidget {
  const AuthCheckerScreen({super.key});

  @override
  State<AuthCheckerScreen> createState() => _AuthCheckerScreenState();
}

class _AuthCheckerScreenState extends State<AuthCheckerScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(snapshot.data!.uid)
                .get(),
            builder: (context, userSnapshot) {
              if (userSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(
                      color: Colors.black,
                      backgroundColor: Colors.white,
                    ),
                  ),
                );
              } else if (userSnapshot.hasError) {
                return const Text('Error loading user data');
              } else if (userSnapshot.hasData && userSnapshot.data!.exists) {
                return const HomeBottomNavigationScreen();
              } else {
                return const SignUpScreen();
              }
            },
          );
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
