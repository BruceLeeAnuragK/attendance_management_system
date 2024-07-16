import 'package:attendence_management_system/provider/get_store.dart';
import 'package:attendence_management_system/view/screen/home_screen.dart';
import 'package:attendence_management_system/view/screen/login_screen.dart';
import 'package:attendence_management_system/view/screen/sign_up_screen.dart';
import 'package:attendence_management_system/view/screen/splash_screen.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(builder: (context, orientation, deviceType) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        initialRoute: MyRoutes.homepage,
        routes: {
          MyRoutes.homepage: (context) => const HomePage(),
          MyRoutes.splashscreen: (context) => const SplashScreen(),
          MyRoutes.login: (context) => const LoginScreen(),
          MyRoutes.signup: (context) => const SignUpScreen(),
        },
      );
    });
  }
}
