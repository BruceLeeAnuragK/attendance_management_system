import 'package:attendence_management_system/provider/store_file/date_store.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:timer_builder/timer_builder.dart';

class Timer extends StatefulWidget {
  const Timer({super.key});

  @override
  State<Timer> createState() => _TimerState();
}

class _TimerState extends State<Timer> {
  @override
  Widget build(BuildContext context) {
    final DateStore dateStore = GetIt.instance<DateStore>();
    return TimerBuilder.periodic(
      const Duration(seconds: 1),
      builder: (context) {
        return Text(
          dateStore.formattedDate.value,
          style: const TextStyle(
              color: Color(0xff2d386b),
              fontSize: 30,
              fontWeight: FontWeight.w700),
        );
      },
    );
  }
}
