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
  // TIP: when developping set the following bool to true to see the clock display minutes / seconds and been updated every 13 seconds
  static const bool CLOCK_DEBUG = true;
  Timer _timer;

  int _firstD, _secondD, _thirdD, _fourthD;

  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Spacer(),
            Digit(_firstD),
            Digit(_secondD),
            Spacer(),
            Digit(_thirdD),
            Digit(_fourthD),
            Spacer(),
          ],
        ),
    );
  }

  @override
  void initState() {
    super.initState();

    // Set the initial values.
    // We display a "HI!" message during the startup
    setState(() {      
      _firstD = Digit.EMPTY;
      _secondD = Digit.H;
      _thirdD = Digit.I;
      _fourthD = Digit.EMPTY;
    });

    // Wait 3 seconds before we display the real hour
    _timer = Timer(
        Duration(seconds: 3),
        _updateTime,
      );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateTime() {
    var now = DateTime.now();
    var firstNumber = widget.model.is24HourFormat ? now.hour : now.hour % 12;
    var secondNumber = now.minute;
    // Update once per minutes or every 13 seconds if in debug mode
    var nextUpdate = Duration(minutes: 1) - Duration(seconds: now.second);
    
    // Use minute and second for debugging only
    if (CLOCK_DEBUG) {
      firstNumber = now.minute;
      secondNumber = now.second;
      nextUpdate = Duration(seconds: 13) - Duration(milliseconds: now.millisecond);
    }

    setState(() {
      _firstD = (firstNumber / 10).truncate();
      _secondD = firstNumber % 10;
      _thirdD = (secondNumber / 10).truncate();
      _fourthD = secondNumber % 10;
    });

    _timer = Timer(
      nextUpdate,
      _updateTime,
    );
  }
}