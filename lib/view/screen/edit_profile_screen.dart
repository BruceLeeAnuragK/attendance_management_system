import 'dart:ui';

import 'package:attendence_management_system/provider/store_file/auth_store.dart';
import 'package:attendence_management_system/provider/store_file/password_store.dart';
import 'package:attendence_management_system/view/utils/my_routes.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../provider/get_store.dart';
import '../../provider/store_file/profile_store.dart';
import '../components/glass_box.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

final AuthStore authStore = getIt<AuthStore>();
final PasswordStore passwordStore = getIt<PasswordStore>();
final ProfileStore profileStore = getIt<ProfileStore>();

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _editformKey = GlobalKey<FormState>();

  Future<void> showPicker(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Photo Library'),
                onTap: () {
                  profileStore.pickImage(ImageSource.gallery);
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Camera'),
                onTap: () {
                  profileStore.pickImage(ImageSource.camera);
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Edit Profile",
          style: GoogleFonts.solway(),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Observer(builder: (context) {
              if (profileStore.profileImage.value != null) {
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushNamed(MyRoutes.profile);
                  },
                  child: Container(
                    height: 5.h,
                    width: 5.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(profileStore.profileImage.value!),
                      ),
                    ),
                  ),
                );
              } else {
                return IconButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(MyRoutes.profile);
                  },
                  icon: const Icon(
                    Icons.person,
                    color: Colors.black,
                  ),
                );
              }
            }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GlassBox(
              child: Center(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          Observer(builder: (_) {
                            return CircleAvatar(
                              backgroundColor: Colors.grey.withOpacity(0.5),
                              radius: 50.sp,
                              backgroundImage: profileStore
                                          .profileImage.value !=
                                      null
                                  ? FileImage(profileStore.profileImage.value!)
                                  : AssetImage('assets/images/person.png'),
                            );
                          }),
                          FloatingActionButton(
                            backgroundColor: Colors.white,
                            mini: true,
                            child: Icon(Icons.add),
                            onPressed: () {
                              showPicker(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Observer(
                        builder: (_) {
                          return Text(
                            authStore.username.value,
                            style: GoogleFonts.solway(
                                fontSize: 15.sp,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _editformKey,
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
                                initialValue: authStore.username.value,
                                onChanged: (val) {
                                  authStore.updateUsername(val);
                                },
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
                                initialValue: authStore.email.value,
                                onChanged: (val) {
                                  authStore.updateEmail(val);
                                },
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
                                  onChanged: (val) {
                                    authStore.updatePassword(val);
                                  },
                                  initialValue: "password",
                                  validator: (value) {
                                    if (value!.length <= 6) {
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
                                    labelText: "New password",
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
                          value: authStore.role.value,
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
                            authStore.updateRole(value!);
                          },
                        ),
                      );
                    }),
                    MaterialButton(
                      onPressed: () async {
                        if (_editformKey.currentState?.validate() ?? false) {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return Text("Your data is Edited Successfully!!");
                            },
                          );
                          Navigator.of(context)
                              .pushReplacementNamed(MyRoutes.checkRoleScreen);
                        } else {
                          showAdaptiveDialog(
                            context: context,
                            builder: (context) {
                              return Text("Your data is Failed to Edit!!");
                            },
                          );
                          Navigator.of(context).pop();
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
                                    "Edit",
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
            ),
          ],
        ),
      ),
    );
  }
}
