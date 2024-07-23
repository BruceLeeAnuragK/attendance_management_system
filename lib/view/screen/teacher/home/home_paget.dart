import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../../provider/get_store.dart';
import '../../../../provider/store_file/auth_store.dart';
import '../../../../provider/store_file/profile_store.dart';
import '../../../components/glass_box.dart';
import '../../../utils/my_routes.dart';
import '../users_detail_screen.dart';

class THomePage extends StatefulWidget {
  const THomePage({super.key});

  @override
  State<THomePage> createState() => _THomePageState();
}

class _THomePageState extends State<THomePage> with TickerProviderStateMixin {
  final AuthStore authStore = getIt<AuthStore>();
  final ProfileStore profileStore = getIt<ProfileStore>();
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    authStore.fetchAllUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [
            GlassBox(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Observer(
                      builder: (_) {
                        return CircleAvatar(
                          backgroundColor: Colors.grey.withOpacity(0.5),
                          radius: 50.sp,
                          backgroundImage:
                              profileStore.profileImage.value != null
                                  ? FileImage(profileStore.profileImage.value!)
                                  : AssetImage('assets/images/person.png'),
                        );
                      },
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
            Padding(
              padding: const EdgeInsets.only(left: 10, bottom: 10, top: 20),
              child: Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(MyRoutes.editProfile);
                    },
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
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 10, right: 10),
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
                          fontSize: 10.sp,
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
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 10, right: 10),
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
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 10, right: 10),
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
      ),
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Attendance App",
          style: GoogleFonts.solway(),
        ),
        centerTitle: true,
        bottom: TabBar(
          indicatorColor: Colors.black,
          controller: tabController,
          tabs: [
            Text(
              "Admins",
              style: GoogleFonts.solway(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Users",
              style: GoogleFonts.solway(
                color: Colors.black,
                fontSize: 15.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
      body: TabBarView(
        controller: tabController,
        children: [
          Observer(
            builder: (_) {
              return ListView.builder(
                itemCount: authStore.adminUsers.length,
                itemBuilder: (context, index) {
                  final admin = authStore.adminUsers[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () async {
                        await authStore.fetchDailyAttendanceRecords(
                            userId: admin.id, selectedMonth: DateTime.now());

                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserAttendancePage(
                            userModel: admin,
                          ),
                        ));
                      },
                      child: Container(
                        height: 15.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.grey.withOpacity(0.5),
                              Colors.white.withOpacity(0.99),
                            ],
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            admin.username,
                            style: GoogleFonts.solway(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            admin.email,
                            style: GoogleFonts.solway(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
          Observer(
            builder: (_) {
              return ListView.builder(
                itemCount: authStore.normalUsers.length,
                itemBuilder: (context, index) {
                  final user = authStore.normalUsers[index];
                  return Padding(
                    padding: const EdgeInsets.all(10),
                    child: GestureDetector(
                      onTap: () async {
                        await authStore.fetchDailyAttendanceRecords(
                            userId: user.id, selectedMonth: DateTime.now());
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => UserAttendancePage(
                            userModel: user,
                          ),
                        ));
                      },
                      child: Container(
                        height: 15.h,
                        width: 30.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          gradient: LinearGradient(
                            begin: Alignment.centerLeft,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.grey.withOpacity(0.5),
                              Colors.white.withOpacity(0.99),
                            ],
                          ),
                        ),
                        child: ListTile(
                          title: Text(
                            user.username,
                            style: GoogleFonts.solway(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          subtitle: Text(
                            user.email,
                            style: GoogleFonts.solway(
                              fontSize: 10.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
