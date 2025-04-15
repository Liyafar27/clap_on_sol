import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'arc_word.dart';

class ClapOnSolText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 20,
          child: CustomPaint(
            size: Size(400, 150),
            painter: ArcWordPainter(
              text: 'CLAP',
              radius: 100,
              startAngle: -pi / 1.4,
              sweepAngle: pi / 1.2,
              textStyle: GoogleFonts.bungee(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 100,
          child: CustomPaint(
            size: Size(400, 100),
            painter: ArcWordPainter(
              text: 'ON',
              radius: 60,
              startAngle: -pi / 2.2,
              sweepAngle: pi / 1.4,
              textStyle: GoogleFonts.bungee(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: 160,
          child: CustomPaint(
            size: Size(400, 150),
            painter: ArcWordPainter(
              text: 'SOL',
              radius: 100,
              startAngle: -pi / 2,
              sweepAngle: pi / 1.2,
              textStyle: GoogleFonts.bungee(
                fontSize: 40,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    )
    ;
  }
}
