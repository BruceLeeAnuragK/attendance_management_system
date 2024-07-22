import 'dart:math';

import 'package:attendence_management_system/provider/get_store.dart';
import 'package:attendence_management_system/provider/store_file/auth_store.dart';
import 'package:attendence_management_system/view/components/glass_box.dart';
import 'package:attendence_management_system/view/utils/my_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:slide_to_act/slide_to_act.dart';

import '../../../../provider/store_file/profile_store.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  final AuthStore authStore = getIt<AuthStore>();
  final ProfileStore profileStore = getIt<ProfileStore>();

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    );
    animation = Tween<double>(begin: 0, end: 1).animate(animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.dismissed) {
          animationController.forward();
        } else if (status == AnimationStatus.completed) {
          animationController.repeat();
        }
      });
    animationController.forward();
    authStore.checkIfDayChanged();
    authStore.fetchUsername();
    profileStore.loadImageFromPreferences();
    profileStore.loadImageFromPreferences();
    authStore.fetchEmail();
    authStore.fetchRole();
    authStore.fetchCheckInAndOut();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat.yMMMMd();
    String formattedDate = formatter.format(now);

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
      body: Column(
        children: [
          Expanded(
            flex: -1,
            child: GlassBox(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Text(
                                "WELCOME,",
                                style: GoogleFonts.solway(
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: Observer(builder: (_) {
                                return Text(
                                  authStore.username.value,
                                  style: GoogleFonts.solway(
                                    fontSize: 15.sp,
                                    color: Colors.black,
                                  ),
                                );
                              }),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20, left: 20),
                              child: Text(
                                formattedDate,
                                style: GoogleFonts.solway(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15.sp,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 20),
                              child: StreamBuilder(
                                stream: Stream.periodic(
                                  const Duration(seconds: 1),
                                ),
                                builder: (context, snapShot) {
                                  return Container(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      DateFormat('hh:mm:ss a')
                                          .format(DateTime.now()),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Padding(
                      padding: const EdgeInsets.only(top: 5, left: 5, right: 5),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Clock In",
                                  style: GoogleFonts.solway(
                                    fontSize: 10.sp,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Observer(
                                  builder: (_) {
                                    return Text(
                                      authStore.checkInTime.value != null
                                          ? DateFormat('hh:mm:ss a').format(
                                              authStore.checkInTime.value!)
                                          : 'Not Checked In',
                                      style: GoogleFonts.solway(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 7.sp,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Clock Out",
                                  style: GoogleFonts.solway(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 10.sp,
                                  ),
                                ),
                                Observer(
                                  builder: (_) {
                                    return Text(
                                      authStore.checkOutTime.value != null
                                          ? DateFormat('hh:mm:ss a').format(
                                              authStore.checkOutTime.value!)
                                          : 'Not Checked Out',
                                      style: GoogleFonts.solway(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 7.sp,
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: Container(
                                height: 10.h,
                                width: 10.h,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                      image: AssetImage(
                                          "assets/images/clockgif.gif"),
                                      fit: BoxFit.fitWidth),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Center(
                  child: CustomPaint(
                    painter: MyCustomPainter(animation.value),
                    child: Container(
                      height: 50.h,
                      width: 100.w,
                    ),
                  ),
                ),
                Center(
                  child: Container(
                    height: 15.h,
                    width: 15.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          Colors.white,
                          Colors.black,
                        ],
                      ),
                    ),
                  ),
                ),
                Center(
                  child: InkWell(
                    radius: 5,
                    splashColor: Colors.white.withOpacity(0.5),
                    onTap: () {
                      showModalBottomSheet(
                        backgroundColor: Colors.white,
                        context: context,
                        builder: (context) {
                          return authStore.checkOutTime.value == null
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Builder(
                                      builder: (context) {
                                        GlobalKey<SlideActionState> key =
                                            GlobalKey();
                                        return Container(
                                          height: 100,
                                          width: 80.w,
                                          margin: EdgeInsets.all(5),
                                          child: Observer(builder: (_) {
                                            return SlideAction(
                                              outerColor: Colors.white,
                                              innerColor: Colors.black,
                                              sliderButtonIcon: Icon(
                                                Icons.punch_clock_rounded,
                                                color: Colors.white,
                                              ),
                                              key: key,
                                              text:
                                                  authStore.checkInTime.value ==
                                                          null
                                                      ? "Clock In"
                                                      : authStore.checkOutTime
                                                                  .value ==
                                                              null
                                                          ? "Clock Out"
                                                          : "Checked Out",
                                              textStyle: GoogleFonts.solway(
                                                color: Colors.black,
                                                fontSize: 10.sp,
                                              ),
                                              onSubmit: () {
                                                Navigator.of(context).pop();

                                                authStore.checkInAndOut(
                                                    key: key);
                                                return authStore
                                                    .fetchCheckInAndOut();
                                              },
                                            );
                                          }),
                                        );
                                      },
                                    )
                                  ],
                                )
                              : Container(
                                  margin: EdgeInsets.all(5),
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: 80.w,
                                  child: Text(
                                    "You have Completed this Day",
                                    style: GoogleFonts.solway(
                                      fontSize: 10.sp,
                                      color: Colors.black,
                                    ),
                                  ),
                                );
                        },
                      );
                    },
                    child: Observer(builder: (_) {
                      return Text(
                        authStore.checkInTime.value == null
                            ? "Clock In"
                            : authStore.checkOutTime.value == null
                                ? "Clock Out"
                                : "Checked Out",
                        style: GoogleFonts.solway(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      );
                    }),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomPainter extends CustomPainter {
  final double animationValue;

  MyCustomPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    for (int value = 10; value >= 0; value--) {
      circle(canvas, Rect.fromLTRB(0, 0, size.width, size.height),
          value + animationValue);
    }
  }

  void circle(Canvas canvas, Rect rect, double value) {
    Paint paint = Paint()
      ..color = Colors.black.withOpacity((1 - (value / 5)).clamp(.0, 1));
    double radius =
        sqrt(pow(rect.width / 2, 2) + pow(rect.height / 2, 2)) * (value / 5);
    canvas.drawCircle(rect.center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant MyCustomPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}
