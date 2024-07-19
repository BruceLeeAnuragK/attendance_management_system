import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:logger/logger.dart';
import 'package:sizer/sizer.dart';

import '../../../../provider/get_store.dart';
import '../../../../provider/store_file/auth_store.dart';

class THomePage extends StatefulWidget {
  const THomePage({super.key});

  @override
  State<THomePage> createState() => _THomePageState();
}

class _THomePageState extends State<THomePage> {
  final AuthStore authStore = getIt<AuthStore>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authStore.fetchUsername();
  }

  @override
  Widget build(BuildContext context) {
    Logger logger;
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher Home Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Observer(builder: (_) {
          Logger logger = Logger();
          logger.t("Username of Admin :- ${authStore.username.value}");
          return Text(
            authStore.username.value,
            style: GoogleFonts.solway(
              color: Colors.black,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
            ),
          );
        }),
      ),
    );
  }
}
