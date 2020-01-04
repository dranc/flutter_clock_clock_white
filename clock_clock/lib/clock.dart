import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

class Clock extends StatelessWidget {
  const Clock(this.time);

  static final default_time = DateTime(0, 0, 0, 7, 35);

  final double  thickness =  6;

  // The time that will be displayed by the clock
  final DateTime time;

  // Define if there is something to display
  bool get isEmpty => time == null;

  DateTime get time_to_diplay => time ?? default_time;

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
  
    //double get size => 50;
    double size = 50;

    return Container(
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(
              color: customTheme.primaryColor,
              width: 1,
            )
          )
        ),
        child: Center(
          child: SizedBox.expand(
            child: CustomPaint(
              painter: _ClockPainter(
                minuteRadians: time_to_diplay.minute * radiansPerTick,
                hourRadians: time_to_diplay.hour * radiansPerHour,
                isEnable: !isEmpty,                
              ),
            ),
          ),
      ),
      width: size,
      height: size
    );
  }
}

class _ClockPainter extends CustomPainter {
  _ClockPainter({
    @required this.minuteRadians, 
    @required this.hourRadians,
    @required this.isEnable
  });
  
  double minuteRadians;
  double hourRadians;
  bool isEnable;

  double lineWidth = 6;
  double minuteLength = 0.9;
  double hourLength = 0.75;

  Color darkColor = Colors.black;
  Color lightColor = Colors.black54;

  Offset _radianToPosition(Size size, double angleRadians, double handSize) {
    final center = (Offset.zero & size).center;

    // We want to start at the top, not at the x-axis, so add pi/2.
    final angle = angleRadians - math.pi / 2.0;

    final length = size.shortestSide * 0.5 * handSize;

    return center + Offset(math.cos(angle), math.sin(angle)) * length;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = (Offset.zero & size).center;
    final linePaint = Paint()
      ..color = isEnable ? darkColor : lightColor
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.butt;

    // Draw hours hand
    final positionHour = _radianToPosition(size, hourRadians, hourLength);
    canvas.drawLine(center, positionHour, linePaint);

    // Draw minutes hand
    final positionMinute = _radianToPosition(size, minuteRadians, minuteLength);
    canvas.drawLine(center, positionMinute, linePaint);

    // Draw center pin
    canvas.drawCircle(center, lineWidth /2, linePaint);    
  }

  @override
  bool shouldRepaint(_ClockPainter oldDelegate) {
    return oldDelegate.minuteRadians != minuteRadians ||
        oldDelegate.hourRadians != hourRadians ||
        oldDelegate.isEnable != isEnable;
  }
}