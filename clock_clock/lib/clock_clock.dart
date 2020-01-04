import 'dart:async';

import 'package:analog_clock/digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class ClockClock extends StatefulWidget {
  const ClockClock(this.model);

  final ClockModel model;

  @override
  _ClockClockState createState() => _ClockClockState();
}

class _ClockClockState extends State<ClockClock> {
  var _now = DateTime.now();
  static const bool CLOCK_DEBUG = true;
  Timer _timer;

  Widget build(BuildContext context) {
    var fisrtNumber = _now.hour;
    var secondNumber = _now.minute;

    // Use minute and second for debugging only
    if (CLOCK_DEBUG) {
      fisrtNumber = _now.minute;
      secondNumber = _now.second;
    }

    return Container(
      margin: const EdgeInsets.all(20.0),
      //color: Colors.amber[600],
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(),
            Digit((fisrtNumber / 10).truncate()),
            Digit(fisrtNumber % 10),
            Spacer(),
            Digit((secondNumber / 10).truncate()),
            Digit(secondNumber % 10),
            Spacer(),
          ],
        ),
    );
  }

  @override
  void initState() {
    super.initState();
    // Set the initial values.
    _updateTime();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per minutes or every 1 seconds if in debug mode
      var nextUpdate = Duration(minutes: 1) - Duration(seconds: _now.second);
      if (CLOCK_DEBUG) {
        nextUpdate = Duration(seconds: 1) - Duration(milliseconds: _now.millisecond);
      }

      _timer = Timer(
        nextUpdate,
        _updateTime,
      );
    });
  }
}