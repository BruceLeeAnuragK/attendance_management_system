import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/auth_helper.dart';
import '../../../provider/get_store.dart';
import '../../../provider/store_file/auth_store.dart';

class MyAttendance extends StatefulWidget {
  const MyAttendance({super.key});

  @override
  State<MyAttendance> createState() => _MyAttendanceState();
}

class _MyAttendanceState extends State<MyAttendance> {
  final AuthStore authStore = getIt<AuthStore>();

  @override
  void initState() {
    super.initState();
    User? currentUser = AuthHelper.authHelper.getCurrentUser();
    if (currentUser != null) {
      authStore.fetchAttendanceRecords(currentUser.uid);
    }
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
          "My Attendance",
          style: GoogleFonts.solway(),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Observer(
                    builder: (_) {
                      return Text(
                        authStore.selectedMonth.value,
                        style: GoogleFonts.solway(
                          fontSize: 10.sp,
                        ),
                      );
                    },
                  ),
                  TextButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );

                      if (pickedDate != null) {
                        final String newMonth =
                            DateFormat('MMMM yyyy').format(pickedDate);
                        authStore.setSelectedMonth(newMonth);
                        User? currentUser =
                            AuthHelper.authHelper.getCurrentUser();
                        if (currentUser != null) {
                          authStore.fetchAttendanceRecords(currentUser.uid);
                        }
                      }
                    },
                    child: Text(
                      "Change Month",
                      style: GoogleFonts.solway(
                        fontSize: 10.sp,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Observer(
              builder: (_) {
                return ListView.builder(
                  shrinkWrap: true,
                  physics: AlwaysScrollableScrollPhysics(),
                  itemCount: authStore.dailyAttendanceRecords.value.length,
                  itemBuilder: (context, index) {
                    final record =
                        authStore.dailyAttendanceRecords.value[index];
                    final checkIn = record['checkIn'] != null
                        ? DateFormat('hh:mm a')
                            .format((record['checkIn'] as Timestamp).toDate())
                        : 'Not Checked In';
                    final checkOut = record['checkout'] != null
                        ? DateFormat('hh:mm a')
                            .format((record['checkout'] as Timestamp).toDate())
                        : 'Not Checked Out';

                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
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
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  DateFormat('EEE dd').format(
                                      (record['date'] as Timestamp).toDate()),
                                  style: GoogleFonts.solway(
                                    fontSize: 15.sp,
                                  ),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              flex: 2,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Check In",
                                        style: GoogleFonts.solway(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        checkIn,
                                        style: GoogleFonts.solway(
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "Check Out",
                                        style: GoogleFonts.solway(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        checkOut,
                                        style: GoogleFonts.solway(
                                          fontSize: 10.sp,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
