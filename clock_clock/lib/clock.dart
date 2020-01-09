import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'dart:math' as math;
import 'package:vector_math/vector_math_64.dart' show radians;

/// Total distance traveled by a second or a minute hand, each second or minute,
/// respectively.
final radiansPerTick = radians(360 / 60);

/// Total distance traveled by an hour hand, each hour, in radians.
final radiansPerHour = radians(360 / 12);

final defaultHour = DateTime(0, 0, 0, 7, 35);

class Clock extends StatefulWidget {
  const Clock(this.time, this.size, this.animationDuration);

  State<StatefulWidget> createState() => _ClockState();

  // The time that will be displayed by the clock
  final DateTime time;

  final double size;

  final int animationDuration;
}

class _ClockState extends State<Clock> with TickerProviderStateMixin {
  // Define if there is something to display
  bool get isEmpty => widget.time == null;

  DateTime timeToDisplay;
  
  Animation<int> animation;

  void didUpdateWidget(Clock oldClock) {
    super.didUpdateWidget(oldClock);

    var controller = AnimationController(duration: Duration(seconds: widget.animationDuration), vsync: this);

    var t1 = oldClock.time ?? defaultHour; 
    var t2 = widget.time ?? defaultHour;

    var begin = t1.hour * 60 +  t1.minute;
    var end = t2.hour * 60 +  t2.minute;
    // If end is "before" begin, we add a full round of the clock
    if (begin > end) {
      end += 12 * 60;
    }

    final Animation curve = CurvedAnimation(parent: controller, curve: Curves.easeInOut);
    animation = IntTween(begin: begin, end: end).animate(curve)
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
    var t = timeToDisplay ?? defaultHour;
    var wt = widget.time ?? defaultHour;

    
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
              minuteRadians: t.minute * radiansPerTick,
              hourRadians: (wt.hour == t.hour || t.hour - wt.hour == 12) ? // Want to display the same hour
                                t.hour * radiansPerHour : // Only display hour
                                (t.hour + t.minute/60) * radiansPerHour, // Display hour and the little extra due to the minutes
              isEnable: !isEmpty,
              color: color
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
    @required this.minuteRadians, 
    @required this.hourRadians,
    @required this.isEnable,
    @required this.color,
  });
  
  double minuteRadians;
  double hourRadians;
  bool isEnable;

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
      ..color = isEnable ? color : Colors.grey
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