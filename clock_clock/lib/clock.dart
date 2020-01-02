import 'package:analog_clock/container_hand.dart';
import 'package:analog_clock/drawn_hand.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

class Clock extends StatelessWidget {
  const Clock(this.time);

  final double  thickness =  6;

  // The time that will be displayed by the clock
  final DateTime time;

  Widget build (BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Aiguille + cadre
            primaryColor: Colors.black,
            // Fond
            backgroundColor: Colors.white,
          )
        : Theme.of(context).copyWith(
            primaryColor: Colors.white,
            backgroundColor: Colors.black,
          );

    return Container(
      child: Container(
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(
              color: customTheme.primaryColor,
              width: 1,
            )
          )
        ),
        child: Stack(
          children: [
            DrawnHand(
              color: customTheme.primaryColor,
              thickness: thickness,
              size: 0.8,
              angleRadians: time.minute * radiansPerTick,
            ),
            DrawnHand(
              color: customTheme.primaryColor,
              thickness: thickness,
              size: 0.7,
              angleRadians: time.hour * radiansPerHour,
            ),
          ],
        ),
      ),
      width: 50,
      height: 50
    );
  }
}