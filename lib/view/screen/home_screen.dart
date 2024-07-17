import 'package:attendence_management_system/view/components/glass_box.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    var now = DateTime.now();
    var formatter = DateFormat.yMMMMd();
    String formattedDate = formatter.format(now);

    return Scaffold(
      drawer: Drawer(
        child: Column(
          children: [],
        ),
      ),
      appBar: AppBar(
        title: const Text("Attendance App"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            GlassBox(
              child: Column(
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
                    child: Text(
                      "Anurag Kanade",
                      style: GoogleFonts.solway(
                        fontSize: 15.sp,
                      ),
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    formattedDate,
                    style: GoogleFonts.solway(
                      fontWeight: FontWeight.bold,
                      fontSize: 15.sp,
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
