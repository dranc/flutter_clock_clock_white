import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute, respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

/// The smallest widget that will be display the time (for a clock in a digit). 
/// This widget was build on top of the analof clock given with the original repo
/// I'm not sure there is a lot of the original code left here.
class Clock extends StatefulWidget {
  Clock(DateTime time, double size, int animationDuration, bool isLight) {
    this.time = time;
    this.size = size;
    this.animationDuration = animationDuration;
    if (!isEnable) {
      this.color = Colors.grey;
    } else {
      this.color = isLight ? Colors.grey[900] : Colors.grey[50];
    }
  }

  State<StatefulWidget> createState() => _ClockState();

  /// The time that will be displayed by the clock
  DateTime time;
  double size;
  int animationDuration;
  Color color;

  /// If there is no time to display, the clock is considered as disable and will be in grey.
  bool get isEnable => time != null;
}

/// The state of the clock the will evolve during the animation.
/// We will track the hour to display, the minute to display and the color to use
/// We did'nt use a time variable because the time that is displayed is not a 'real' time
/// For exemple, if you display 00:30, the hour hand is left in the 00 (on top of the clock)
/// In a real world, the hand should be a little on the right, just between 0 and 1.
/// We don't want a display like that so we don't use a time variable to track what is display in this state. 
class _ClockState extends State<Clock> with TickerProviderStateMixin {
  // The two following var are the angle in radian that we target
  double hourToDisplay;
  double minuteToDisplay;
  Color colorToDisplay;
  
  Animation<double> animationHour;
  Animation<double> animationMinute;
  Animation<Color> animationColor;

  DateTime timeOrDefault(DateTime t)  {
    return t == null ? DateTime(0, 0, 0, 7, 35) : DateTime(0, 0, 0, t.hour, t.minute);
  }

  double toHoursRadian(DateTime t) {
    return t.hour * radiansPerHour;
  }

  double toMinutesRadian(DateTime t) {
    return (60 * t.hour + t.minute) * radiansPerTick;
  }

  void didUpdateWidget(Clock oldClock) {
    super.didUpdateWidget(oldClock);

    var controller = AnimationController(duration: Duration(seconds: widget.animationDuration), vsync: this);

    var t1 = timeOrDefault(oldClock.time);
    var t2 = timeOrDefault(widget.time);

    if (t1.isAfter(t2) || // If old time is after next time
    (t1 != t2 && t2.difference(t1).inHours < 6)) { // If difference are less than a half clock turn
      t2 = t2.add(Duration(hours: 12)); // Add a full turn
    }

    var hourBefore = toHoursRadian(t1);
    var minuteBefore = toMinutesRadian(t1);

    var hourAfter = toHoursRadian(t2);
    var minuteAfter = toMinutesRadian(t2);

    final Animation curve = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    animationHour = Tween(begin: hourBefore, end: hourAfter).animate(curve)
      ..addListener(() { setState(() { }); })
      ;
    animationMinute = Tween(begin: minuteBefore, end: minuteAfter).animate(curve)
      ..addListener(() { setState(() { }); })
      ;
    animationColor = ColorTween(begin: oldClock.color, end: widget.color).animate(curve)
      ..addListener(() { setState(() { }); })
      ;

    controller.forward();
  }

  void initState() {
    super.initState();
  }

  Widget build (BuildContext context) {    
    var light = Theme.of(context).brightness == Brightness.light;
    var color = light ? Colors.grey[900] : Colors.grey[50];
    
    return Container(
        decoration: ShapeDecoration(
          shape: CircleBorder(
            side: BorderSide(
              color: color,
              width: 1,
            )
          )
        ),
        child: SizedBox.expand(
          child: CustomPaint(
            painter: _ClockPainter(
              isEmpty: animationMinute == null || animationHour == null,
              minuteRadians: animationMinute != null ? animationMinute.value : 0,
              hourRadians: animationHour != null ? animationHour.value : 0,
              color: animationColor != null ? animationColor.value : Colors.grey,
            ),
          ),
        ),
      width: widget.size,
      height: widget.size,
    );
  }
}

class _ClockPainter extends CustomPainter {
  _ClockPainter({
    @required this.isEmpty,
    @required this.minuteRadians, 
    @required this.hourRadians,
    @required this.color,
  });

  bool isEmpty;
  
  double minuteRadians;
  double hourRadians;

  double lineWidth = 6;
  double minuteLength = 0.9;
  double hourLength = 0.8;

  Color color = Colors.grey[900];

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
      ..color = color
      ..strokeWidth = lineWidth
      ..strokeCap = StrokeCap.butt;

    if (!isEmpty) {
      // Draw hours hand
      final positionHour = _radianToPosition(size, hourRadians, hourLength);
      canvas.drawLine(center, positionHour, linePaint);

      // Draw minutes hand
      final positionMinute = _radianToPosition(size, minuteRadians, minuteLength);
      canvas.drawLine(center, positionMinute, linePaint);

      // Draw center pin
      canvas.drawCircle(center, lineWidth /2, linePaint);
    }
  }

  @override
  bool shouldRepaint(_ClockPainter oldDelegate) {
    return oldDelegate.minuteRadians != minuteRadians ||
        oldDelegate.hourRadians != hourRadians || 
        oldDelegate.color != color;
  }
}