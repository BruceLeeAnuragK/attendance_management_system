import 'package:cloud_firestore/cloud_firestore.dart'; // Import this to handle Timestamps
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../helper/auth_helper.dart';
import '../../../provider/get_store.dart';
import '../../../provider/store_file/auth_store.dart';
import '../../components/glass_box.dart';

class MyAnalyticsScreen extends StatefulWidget {
  const MyAnalyticsScreen({super.key});

  @override
  State<MyAnalyticsScreen> createState() => _MyAnalyticsScreenState();
}

class _MyAnalyticsScreenState extends State<MyAnalyticsScreen>
    with TickerProviderStateMixin {
  late final TabController tabController;
  final AuthStore authStore = getIt<AuthStore>();

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
    fetchData();
  }

  void fetchData() async {
    String userId = (await AuthHelper.authHelper.getCurrentUser())!.uid;
    await authStore.fetchAttendanceRecords(userId);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        title: Text(
          "My Analytics",
          style: GoogleFonts.solway(),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: tabController,
          indicatorColor: Colors.black,
          labelColor: Colors.black,
          indicatorSize: TabBarIndicatorSize.label,
          tabs: [
            Text(
              "Weekly",
              style: GoogleFonts.solway(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "Monthly",
              style: GoogleFonts.solway(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: tabController,
        children: [
          Observer(
            builder: (_) {
              // Weekly Tab Content
              DateTime now = DateTime.now();
              DateTime startOfWeek =
                  now.subtract(Duration(days: now.weekday - 1));
              List<Map<String, dynamic>> records =
                  authStore.dailyAttendanceRecords.value;
              Map<String, double> percentages =
                  authStore.calculatePercentages(records);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 50.h,
                        width: 100.w,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: BarChart(
                            BarChartData(
                              borderData: FlBorderData(show: false),
                              groupsSpace: 1,
                              barGroups: getBarChartGroups(records),
                              titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    final date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            value.toInt());
                                    final formattedDate =
                                        "${date.day}/${date.month}";
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        formattedDate,
                                        style:
                                            GoogleFonts.solway(fontSize: 10.sp),
                                      ),
                                    );
                                  },
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GlassBox(
                      child: Container(
                        height: 50.h,
                        width: 50.h,
                        child: PieChart(
                          swapAnimationCurve: Curves.bounceIn,
                          swapAnimationDuration: const Duration(seconds: 2),
                          PieChartData(
                            borderData: FlBorderData(show: false),
                            centerSpaceRadius: 40.sp,
                            sectionsSpace: 0,
                            pieTouchData: PieTouchData(enabled: true),
                            sections: getPieChartSections(percentages),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Observer(
            builder: (_) {
              // Monthly Tab Content
              List<Map<String, dynamic>> records =
                  authStore.dailyAttendanceRecords.value;
              Map<String, double> percentages =
                  authStore.calculatePercentages(records);

              return SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Container(
                        height: 50.h,
                        width: 100.w,
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: BarChart(
                            BarChartData(
                              borderData: FlBorderData(show: false),
                              groupsSpace: 1,
                              barGroups: getBarChartGroups(records),
                              titlesData: FlTitlesData(
                                  bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 40,
                                  getTitlesWidget: (value, meta) {
                                    final date =
                                        DateTime.fromMillisecondsSinceEpoch(
                                            value.toInt());
                                    final formattedDate =
                                        "${date.day}/${date.month}";
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide,
                                      child: Text(
                                        formattedDate,
                                        style:
                                            GoogleFonts.solway(fontSize: 10.sp),
                                      ),
                                    );
                                  },
                                ),
                              )),
                            ),
                          ),
                        ),
                      ),
                    ),
                    GlassBox(
                      child: Container(
                        height: 50.h,
                        width: 50.h,
                        child: PieChart(
                          swapAnimationCurve: Curves.bounceIn,
                          swapAnimationDuration: const Duration(seconds: 2),
                          PieChartData(
                            borderData: FlBorderData(show: false),
                            centerSpaceRadius: 40.sp,
                            sectionsSpace: 0,
                            pieTouchData: PieTouchData(enabled: true),
                            sections: getPieChartSections(percentages),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> getPieChartSections(
      Map<String, double> percentages) {
    return [
      PieChartSectionData(
        value: percentages['Present']!,
        showTitle: true,
        title: "Present\n ${percentages['Present']!.toStringAsFixed(1)}%",
        titleStyle: GoogleFonts.solway(fontSize: 5.sp, color: Colors.white),
        color: Colors.black,
      ),
      PieChartSectionData(
        value: percentages['Absent']!,
        showTitle: true,
        title: "Absent\n ${percentages['Absent']!.toStringAsFixed(1)}%",
        titleStyle: GoogleFonts.solway(fontSize: 5.sp, color: Colors.white),
        color: Colors.black.withOpacity(0.5),
      ),
      PieChartSectionData(
        value: percentages['HalfDay']!,
        showTitle: true,
        title: "Half Day\n ${percentages['HalfDay']!.toStringAsFixed(1)}%",
        titleStyle: GoogleFonts.solway(fontSize: 5.sp, color: Colors.white),
        color: Colors.black.withOpacity(0.25),
      ),
    ];
  }

  List<BarChartGroupData> getBarChartGroups(
      List<Map<String, dynamic>> records) {
    Map<int, int> data = {};

    for (var record in records) {
      Timestamp checkInTimestamp = record['checkIn'];
      DateTime checkInDate = checkInTimestamp.toDate();
      DateTime dateOnly =
          DateTime(checkInDate.year, checkInDate.month, checkInDate.day);
      data[dateOnly.millisecondsSinceEpoch] =
          (data[dateOnly.millisecondsSinceEpoch] ?? 0) + 1;
    }

    return data.entries.map((entry) {
      return BarChartGroupData(
        x: entry.key,
        barRods: [
          BarChartRodData(
            fromY: 0,
            toY: entry.value.toDouble(),
            color: Colors.black.withOpacity(0.5),
          ),
        ],
      );
    }).toList();
  }
}
