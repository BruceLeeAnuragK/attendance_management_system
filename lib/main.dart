import 'package:attendence_management_system/provider/get_store.dart';
import 'package:attendence_management_system/view/screen/auth_checker_screen.dart';
import 'package:attendence_management_system/view/screen/check_role_screen.dart';
import 'package:attendence_management_system/view/screen/edit_profile_screen.dart';
import 'package:attendence_management_system/view/screen/login_screen.dart';
import 'package:attendence_management_system/view/screen/sign_up_screen.dart';
import 'package:attendence_management_system/view/screen/splash_screen.dart';
import 'package:attendence_management_system/view/screen/student/analytics_screen.dart';
import 'package:attendence_management_system/view/screen/student/attendance_screen.dart';
import 'package:attendence_management_system/view/screen/student/home/home_bottom_navigation_screen.dart';
import 'package:attendence_management_system/view/screen/student/home/home_screen.dart';
import 'package:attendence_management_system/view/screen/teacher/home/home_paget.dart';
import 'package:attendence_management_system/view/screen/user_profile_screen.dart';
import 'package:attendence_management_system/view/utils/my_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.black),
          useMaterial3: true,
        ),
        initialRoute: MyRoutes.splashScreen,
        routes: {
          MyRoutes.homepage: (context) => const HomePage(),
          MyRoutes.tHomepage: (context) => const THomePage(),
          MyRoutes.bottomNavigation: (context) =>
              const HomeBottomNavigationScreen(),
          MyRoutes.splashScreen: (context) => const SplashScreen(),
          MyRoutes.checkRoleScreen: (context) => const CheckRoleScreen(),
          MyRoutes.authCheckerScreen: (context) => const AuthCheckerScreen(),
          MyRoutes.login: (context) => const LoginScreen(),
          MyRoutes.signup: (context) => const SignUpScreen(),
          MyRoutes.attendanceScreen: (context) => const MyAttendance(),
          MyRoutes.analyticsScreen: (context) => const MyAnalyticsScreen(),
          MyRoutes.profile: (context) => const ProfileScreen(),
          MyRoutes.editProfile: (context) => const EditProfileScreen(),
        },
      );
    });
  }
}
