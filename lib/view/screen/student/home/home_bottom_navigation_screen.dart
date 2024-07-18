import 'package:attendence_management_system/provider/store_file/bottom_navigation_store.dart';
import 'package:attendence_management_system/view/screen/student/analytics_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:sizer/sizer.dart';

import '../../../../provider/get_store.dart';
import '../attendance_screen.dart';
import '../home_screen.dart';

class HomeBottomNavigationScreen extends StatefulWidget {
  const HomeBottomNavigationScreen({super.key});

  @override
  State<HomeBottomNavigationScreen> createState() =>
      _HomeBottomNavigationScreenState();
}

class _HomeBottomNavigationScreenState
    extends State<HomeBottomNavigationScreen> {
  List pages = [
    const MyAttendance(),
    Observer(builder: (context) {
      return const HomePage();
    }),
    const MyAnalyticsScreen(),
  ];
  final BottomNavigationStore bottomNavigationStore =
      getIt<BottomNavigationStore>();

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (_) {
      return Scaffold(
        body: pages[bottomNavigationStore.currentIndex.value],
        bottomNavigationBar: CurvedNavigationBar(
          index: bottomNavigationStore.currentIndex.value,
          backgroundColor: Colors.transparent,
          buttonBackgroundColor: Colors.white,
          color: Colors.grey.withOpacity(0.3),
          items: <Widget>[
            bottomNavigationStore.currentIndex.value == 0
                ? Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black,
                    size: 25.sp,
                  )
                : Icon(
                    Icons.calendar_today_outlined,
                    color: Colors.black,
                    size: 25.sp,
                  ),
            Icon(
              Icons.home_outlined,
              color: Colors.black,
              size: 25.sp,
            ),
            Icon(
              Icons.trending_up,
              color: Colors.black,
              size: 25.sp,
            ),
          ],
          onTap: (index) {
            bottomNavigationStore.changeIndex(index: index);
          },
        ),
      );
    });
  }
}
