import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GlassBox extends StatefulWidget {
  const GlassBox({super.key, required this.child});

  final Widget child;

  @override
  State<GlassBox> createState() => _GlassBoxState();
}

class _GlassBoxState extends State<GlassBox> {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: SizedBox(
        height: 30.h,
        width: 100.w,
        child: Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2,
                sigmaY: 2,
              ),
              child: Container(),
            ),
            Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                ),
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.grey.withOpacity(0.4),
                    Colors.white.withOpacity(0.1),
                    Colors.grey.withOpacity(0.4),
                  ],
                ),
              ),
            ),
            Container(
              child: widget.child,
            ),
          ],
        ),
      ),
    );
  }
}
