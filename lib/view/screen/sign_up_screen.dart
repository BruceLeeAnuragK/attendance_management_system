import 'dart:ui';

import 'package:attendence_management_system/provider/store_file/auth_store.dart';
import 'package:attendence_management_system/provider/store_file/password_store.dart';
import 'package:attendence_management_system/view/utils/my_routes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../provider/get_store.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

final AuthStore authStore = getIt<AuthStore>();
final PasswordStore passwordStore = getIt<PasswordStore>();

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

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
                        "Sign Up",
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
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: ClipRRect(
                      child: SizedBox(
                        height: 7.h,
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
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Username is required.";
                                } else if (value.length <= 6) {
                                  return "Username must be at least of 6 letters";
                                }
                                return null;
                              },
                              controller: authStore.usernameController,
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                focusColor: Colors.black,
                                prefixIcon: const Icon(
                                  Icons.person,
                                  color: Colors.black,
                                ),
                                labelText: "Username",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
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
                        height: 7.h,
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
                              controller: authStore.emailController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter an email';
                                }
                                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                                    .hasMatch(value)) {
                                  return 'Please enter a valid email address (use @gmail.com)';
                                }
                                return null;
                              },
                              cursorColor: Colors.black,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                focusColor: Colors.black,
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
                        height: 7.h,
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
                                controller: authStore.passwordController,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return "The Password is very important for Authentication.";
                                  } else if (value.length <= 6) {
                                    return "The Password must be at least 6 character long.";
                                  }
                                  return null;
                                },
                                obscureText: passwordStore.hide.value,
                                cursorColor: Colors.black,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                  focusColor: Colors.black,
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
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
                  //
                  Observer(builder: (_) {
                    return DropdownButtonHideUnderline(
                      child: DropdownButton2<String>(
                        dropdownStyleData: DropdownStyleData(
                          maxHeight: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14),
                            color: Colors.white,
                          ),
                          offset: const Offset(-20, 0),
                          scrollbarTheme: ScrollbarThemeData(
                            radius: const Radius.circular(40),
                            thickness: WidgetStateProperty.all<double>(6),
                            thumbVisibility:
                                WidgetStateProperty.all<bool>(true),
                          ),
                        ),
                        buttonStyleData: ButtonStyleData(
                          height: 50,
                          width: 160,
                          padding: const EdgeInsets.only(left: 14, right: 14),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.white.withOpacity(0.2),
                            ),
                            borderRadius: BorderRadius.circular(10),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.grey.withOpacity(0.1),
                                Colors.white.withOpacity(0.9),
                                Colors.grey.withOpacity(0.1),
                              ],
                            ),
                          ),
                          elevation: 2,
                        ),
                        isExpanded: true,
                        hint: Row(
                          children: [
                            Text(
                              'Select Role',
                              style: GoogleFonts.solway(
                                fontSize: 10.sp,
                              ),
                            ),
                          ],
                        ),
                        value: authStore.selectedRole.value,
                        items: authStore.items.value
                            .map(
                              (String item) => DropdownMenuItem<String>(
                                value: item,
                                child: Text(
                                  item,
                                  style: GoogleFonts.solway(
                                    fontSize: 10.sp,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (String? value) {
                          authStore.selectRole(value: value!);
                        },
                      ),
                    );
                  }),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "If already Registered then,",
                        style: GoogleFonts.solway(
                          color: Colors.black,
                          fontSize: 10.sp,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(MyRoutes.login);
                        },
                        child: Text(
                          "Login",
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
                    onPressed: () async {
                      if (_formKey.currentState?.validate() ?? false) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        authStore.signUp().then((value) => Navigator.of(context)
                            .pushReplacementNamed(MyRoutes.checkRoleScreen));
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                              content: Text(
                            'The Sign Up process has failed!',
                            style: GoogleFonts.solway(
                              color: Colors.black,
                              fontSize: 10.sp,
                            ),
                          )),
                        );
                      }
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
                                child: Text(
                                  "SIGN UP",
                                  style: GoogleFonts.solway(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    fontSize: 20.sp,
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
