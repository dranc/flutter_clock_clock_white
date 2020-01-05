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
  // TIP: when developping set the following bool to true to see the clock display minutes / seconds and been updated every 13 seconds
  static const bool CLOCK_DEBUG = true;
  Timer _timer;

  Widget build(BuildContext context) {
    var firstNumber = widget.model.is24HourFormat ? _now.hour : _now.hour % 12;
    var secondNumber = _now.minute;

    // Use minute and second for debugging only
    if (CLOCK_DEBUG) {
      firstNumber = _now.minute;
      secondNumber = _now.second;
    }

    return Container(
      margin: const EdgeInsets.all(20.0),
      //color: Colors.amber[600],
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(),
            Digit((firstNumber / 10).truncate()),
            Digit(firstNumber % 10),
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
      // Update once per minutes or every 13 seconds if in debug mode
      var nextUpdate = Duration(minutes: 1) - Duration(seconds: _now.second);
      if (CLOCK_DEBUG) {
        nextUpdate = Duration(seconds: 13) - Duration(milliseconds: _now.millisecond);
      }

      _timer = Timer(
        nextUpdate,
        _updateTime,
      );
    });
  }
}