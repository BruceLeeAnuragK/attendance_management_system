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
    authStore.fetchUsername();
    authStore.fetchCheckInTime();
    authStore.fetchCheckOutTime();
    profileStore.loadImageFromPreferences();
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
      drawer: const Drawer(
        child: Column(
          children: [],
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
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Center(
                              child: Text(
                                "Select any one Check in option",
                                style: GoogleFonts.solway(
                                  fontSize: 10.sp,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Card(
                                  child: IconButton(
                                    onPressed: () async {
                                      Navigator.of(context).pop();
                                      if (authStore.checkInTime.value == null) {
                                        authStore.checkIn();
                                        await authStore.fetchCheckInTime();
                                      } else if (authStore.checkOutTime.value ==
                                          null) {
                                        authStore.checkOut();
                                        await authStore.fetchCheckOutTime();
                                      }
                                    },
                                    icon: Icon(
                                      Icons.punch_clock_rounded,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                                Card(
                                  child: IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.qr_code_2_rounded,
                                      color: Colors.black,
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
                    ),
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
