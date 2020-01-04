import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

class Clock extends StatefulWidget {
  const Clock(this.time);

  State<StatefulWidget> createState() => _ClockState();

  // The time that will be displayed by the clock
  final DateTime time;
}

class _ClockState extends State<Clock> with TickerProviderStateMixin {
  // Define if there is something to display
  bool get isEmpty => widget.time == null;

  DateTime timeToDisplay;
  
  Animation<int> animation;

  void didUpdateWidget(Clock oldClock) {
    super.didUpdateWidget(oldClock);

    var controller = AnimationController(
        duration: Duration(milliseconds: 500), vsync: this);

    var t1 = oldClock.time ?? DateTime(0, 0, 0, 7, 35); 
    var t2 = widget.time ?? DateTime(0, 0, 0, 7, 35);

    var begin = t1.hour * 60 +  t1.minute;
    var end = t2.hour * 60 +  t2.minute;

    animation = IntTween(begin: begin, end: end).animate(controller)
      ..addListener(() {
        setState(() {
          timeToDisplay = DateTime(0, 0, 0, (animation.value / 60).truncate(), (animation.value % 60).truncate());
        });
      });

    controller.forward();
  }

  void initState() {
    super.initState();
  }

  Widget build (BuildContext context) {  
    //double get size => 50;
    double size = 50;

    var t = timeToDisplay ?? DateTime(0, 0, 0, 7, 35);

    return Container(
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(
              color: Colors.grey,
              width: 1,
            )
          )
        ),
        child: SizedBox.expand(
          child: CustomPaint(
            painter: _ClockPainter(
              minuteRadians: t.minute * radiansPerTick,
              hourRadians: t.hour * radiansPerHour,
              isEnable: !isEmpty,                
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
  Color lightColor = Colors.grey;

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