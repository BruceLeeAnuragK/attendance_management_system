import 'dart:ui';

import 'package:attendence_management_system/provider/store_file/password_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../provider/get_store.dart';
import '../utils/my_routes.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final PasswordStore passwordStore = getIt<PasswordStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClipRRect(
              child: SizedBox(
                height: 40.h,
                width: 100.w,
                child: Stack(
                  children: [
                    Positioned(
                      right: 80,
                      child: Container(
                        height: 50.h,
                        width: 100.w,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              image: AssetImage("assets/images/clockgif.gif"),
                              fit: BoxFit.fitWidth),
                        ),
                      ),
                    ),
                    BackdropFilter(
                      filter: ImageFilter.blur(
                        sigmaX: 2,
                        sigmaY: 2,
                      ),
                      child: Container(),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                        borderRadius: BorderRadius.circular(20),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.grey.withOpacity(0.4),
                            Colors.white.withOpacity(0.1),
                            Colors.grey.withOpacity(0.4),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 110,
                      top: 30.h,
                      child: Text(
                        "Log In",
                        style: GoogleFonts.solway(
                            color: Colors.black,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Form(
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      child: SizedBox(
                        height: 8.h,
                        width: 100.w,
                        child: Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 2,
                                sigmaY: 2,
                              ),
                              child: Container(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.grey.withOpacity(0.4),
                                    Colors.white.withOpacity(0.1),
                                    Colors.grey.withOpacity(0.4),
                                    // Colors.grey.withOpacity(0.4),
                                    // Colors.grey.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                            TextFormField(
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                focusColor: Colors.black,
                                border: UnderlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide:
                                        const BorderSide(color: Colors.white)),
                                prefixIcon: const Icon(
                                  Icons.email,
                                  color: Colors.black,
                                ),
                                labelText: "Email",
                                labelStyle: GoogleFonts.solway(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      child: SizedBox(
                        height: 8.h,
                        width: 100.w,
                        child: Stack(
                          children: [
                            BackdropFilter(
                              filter: ImageFilter.blur(
                                sigmaX: 2,
                                sigmaY: 2,
                              ),
                              child: Container(),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                borderRadius: BorderRadius.circular(10),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Colors.grey.withOpacity(0.4),
                                    Colors.white.withOpacity(0.1),
                                    Colors.grey.withOpacity(0.4),
                                    // Colors.grey.withOpacity(0.4),
                                    // Colors.grey.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                            Observer(builder: (_) {
                              return TextFormField(
                                obscureText: passwordStore.hide.value,
                                cursorColor: Colors.black,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  focusColor: Colors.black,
                                  border: UnderlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide: const BorderSide(
                                          color: Colors.white)),
                                  prefixIcon: const Icon(
                                    Icons.key,
                                    color: Colors.black,
                                  ),
                                  suffixIcon: IconButton(
                                    icon: passwordStore.hide.value == true
                                        ? const Icon(
                                            Icons.visibility_off,
                                            color: Colors.black,
                                          )
                                        : const Icon(Icons.visibility),
                                    onPressed: () {
                                      passwordStore.hideOrShowPassword();
                                    },
                                  ),
                                  labelText: "Password",
                                  labelStyle: GoogleFonts.solway(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 12.sp,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If not Registered then,",
                        style: GoogleFonts.solway(
                          color: Colors.black,
                          fontSize: 10.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(MyRoutes.signup);
                        },
                        child: Text(
                          "Sign up",
                          style: GoogleFonts.solway(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 10.sp,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(MyRoutes.bottomNavigation);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        child: SizedBox(
                          height: 8.h,
                          width: 50.w,
                          child: Stack(
                            children: [
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 2,
                                  sigmaY: 2,
                                ),
                                child: Container(),
                              ),
                              Container(
                                child: Text(
                                  "LOGIN",
                                  style: GoogleFonts.solway(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20.sp,
                                  ),
                                ),
                                alignment: Alignment.center,
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.grey.withOpacity(0.4),
                                      Colors.grey.withOpacity(0.1),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
