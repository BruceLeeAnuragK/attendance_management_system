import 'package:attendence_management_system/provider/store_file/bottom_navigation_store.dart';
import 'package:attendence_management_system/view/components/glass_box.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

import '../../../provider/get_store.dart';

class MyAnalyticsScreen extends StatefulWidget {
  const MyAnalyticsScreen({super.key});

  @override
  State<MyAnalyticsScreen> createState() => _MyAnalyticsScreenState();
}

class _MyAnalyticsScreenState extends State<MyAnalyticsScreen>
    with TickerProviderStateMixin {
  late final TabController tabController;

  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    tabController.dispose();
    super.dispose();
  }

  final BottomNavigationStore bottomNavigationStore =
      getIt<BottomNavigationStore>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
            onPressed: () {},
          ),
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
            onTap: (index) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                bottomNavigationStore.chnageTabIndex(index: index);
              });
            },
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
            SingleChildScrollView(
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
                            borderData: FlBorderData(
                              show: false,
                            ),
                            groupsSpace: 1,
                            barGroups: [
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: 3,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: 2,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 3,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: 2,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 4,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: 5,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 5,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: 4,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ],
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
                          pieTouchData: PieTouchData(
                            enabled: true,
                          ),
                          sections: [
                            PieChartSectionData(
                                value: 4,
                                showTitle: true,
                                title: "Present\n 4",
                                titleStyle: GoogleFonts.solway(
                                    fontSize: 5.sp, color: Colors.white),
                                color: Colors.black),
                            PieChartSectionData(
                                value: 1,
                                showTitle: true,
                                title: "Absent\n 1",
                                titleStyle: GoogleFonts.solway(
                                    fontSize: 5.sp, color: Colors.white),
                                color: Colors.black.withOpacity(0.5)),
                            PieChartSectionData(
                                value: 2,
                                showTitle: true,
                                title: "half Day\n 2",
                                titleStyle: GoogleFonts.solway(
                                    fontSize: 5.sp, color: Colors.white),
                                color: Colors.black.withOpacity(0.25)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SingleChildScrollView(
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
                            borderData: FlBorderData(
                              show: false,
                            ),
                            groupsSpace: 1,
                            barGroups: [
                              BarChartGroupData(
                                x: 1,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: 3,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 2,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: 2,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 3,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: 2,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 4,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: 5,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                              BarChartGroupData(
                                x: 5,
                                barRods: [
                                  BarChartRodData(
                                    fromY: 0,
                                    toY: 4,
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                ],
                              ),
                            ],
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
                          pieTouchData: PieTouchData(
                            enabled: true,
                          ),
                          sections: [
                            PieChartSectionData(
                                value: 4,
                                showTitle: true,
                                title: "Present\n 4",
                                titleStyle: GoogleFonts.solway(
                                    fontSize: 5.sp, color: Colors.white),
                                color: Colors.black),
                            PieChartSectionData(
                                value: 1,
                                showTitle: true,
                                title: "Absent\n 1",
                                titleStyle: GoogleFonts.solway(
                                    fontSize: 5.sp, color: Colors.white),
                                color: Colors.black.withOpacity(0.5)),
                            PieChartSectionData(
                                value: 2,
                                showTitle: true,
                                title: "half Day\n 2",
                                titleStyle: GoogleFonts.solway(
                                    fontSize: 5.sp, color: Colors.white),
                                color: Colors.black.withOpacity(0.25)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }
}
