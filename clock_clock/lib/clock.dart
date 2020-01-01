import 'package:analog_clock/analog_clock.dart';
import 'package:analog_clock/container_hand.dart';
import 'package:analog_clock/drawn_hand.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_clock_helper/model.dart';
import 'package:intl/intl.dart';

class Clock extends StatelessWidget {
  const Clock(this.time);

  // The time that will be displayed by the clock
  final DateTime time;

  Widget build (BuildContext context) {
    final customTheme = Theme.of(context).brightness == Brightness.light
        ? Theme.of(context).copyWith(
            // Hour hand.
            primaryColor: Color(0xFF4285F4),
            // Minute hand.
            highlightColor: Color(0xFF8AB4F8),
            // Second hand.
            accentColor: Color(0xFF669DF6),
            backgroundColor: Color(0xFFD2E3FC),
          )
        : Theme.of(context).copyWith(
            primaryColor: Color(0xFFD2E3FC),
            highlightColor: Color(0xFF4285F4),
            accentColor: Color(0xFF8AB4F8),
            backgroundColor: Color(0xFF3C4043),
          );

    return Container(
          child: Container(
            color: customTheme.backgroundColor,
            child: Stack(
              children: [
                DrawnHand(
                  color: customTheme.highlightColor,
                  thickness: 16,
                  size: 0.9,
                  angleRadians: time.minute * radiansPerTick,
                ),
                // Example of a hand drawn with [Container].
                ContainerHand(
                  color: Colors.transparent,
                  size: 0.5,
                  angleRadians: time.hour * radiansPerHour,
                  child: Transform.translate(
                    offset: Offset(0.0, -60.0),
                    child: Container(
                      width: 32,
                      height: 150,
                      decoration: BoxDecoration(
                        color: customTheme.primaryColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
      width: 50,
      height: 50
    );
  }
}