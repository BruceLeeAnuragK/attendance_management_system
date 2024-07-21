import 'package:attendence_management_system/provider/get_store.dart';
import 'package:attendence_management_system/view/components/glass_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sizer/sizer.dart';

import '../../../provider/store_file/auth_store.dart';
import '../../../provider/store_file/profile_store.dart';
import '../../utils/my_routes.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileStore profileStore = getIt<ProfileStore>();
  final AuthStore authStore = getIt<AuthStore>();

  @override
  void initState() {
    super.initState();
    profileStore.loadImageFromPreferences();
    authStore.fetchEmail();
    authStore.fetchRole();
  }

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
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          "My Profile",
          style: GoogleFonts.solway(),
        ),
        centerTitle: true,
      ),
      body: Column(
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
                            backgroundImage: profileStore.profileImage.value !=
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
            padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
            child: Row(
              children: [
                MaterialButton(
                  onPressed: () {},
                  child: Container(
                    alignment: Alignment.center,
                    height: 5.h,
                    width: 30.w,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          blurRadius: 1,
                          offset: Offset(3, 3),
                        ),
                      ],
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white,
                    ),
                    child: Text(
                      "Edit Profile",
                      style: GoogleFonts.solway(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10, right: 10),
                child: Icon(
                  Icons.mail_rounded,
                  color: Colors.black,
                  size: 25.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Observer(
                  builder: (_) {
                    return Text(
                      authStore.email.value,
                      style: GoogleFonts.solway(
                        color: Colors.blue,
                        fontSize: 15.sp,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10, right: 10),
                child: Icon(
                  Icons.group,
                  color: Colors.black,
                  size: 25.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Observer(
                  builder: (_) {
                    return Text(
                      authStore.role.value,
                      style: GoogleFonts.solway(
                        color: Colors.black,
                        fontSize: 15.sp,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 10, right: 10),
                child: Icon(
                  Icons.logout_rounded,
                  color: Colors.black,
                  size: 25.sp,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Center(
                            child: Text(
                              "Are you sure you have to Sign Out",
                              style: GoogleFonts.solway(
                                color: Colors.black,
                                fontSize: 15.sp,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton(
                                onPressed: () {
                                  authStore.logOut().then((value) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context)
                                        .pushNamed(MyRoutes.login);
                                  });
                                },
                                child: Text(
                                  "Yes",
                                  style: GoogleFonts.solway(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "No",
                                  style: GoogleFonts.solway(
                                    color: Colors.black,
                                    fontSize: 10.sp,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  child: Text(
                    "Sign Out",
                    style: GoogleFonts.solway(
                      color: Colors.black,
                      fontSize: 15.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
