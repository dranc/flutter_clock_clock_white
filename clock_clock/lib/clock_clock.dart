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
  Timer _timer;
  int _firstD, _secondD, _thirdD, _fourthD;

  Widget build(BuildContext context) {
    return Container(
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Digit(_firstD),
            Digit(_secondD),
            Digit(_thirdD),
            Digit(_fourthD),
          ],
        ),
    );
  }

  @override
  void initState() {
    super.initState();

    setState(() {      
      _firstD = Digit.NOON;
      _secondD = Digit.NOON;
      _thirdD = Digit.NOON;
      _fourthD = Digit.NOON;
    });

    _timer = Timer(
      Duration(milliseconds: 500),
      _reset,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _reset() {
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
      Duration(seconds: 13),
      _updateDisplay,
    );
  }

  void _updateDisplay() {
    var now = DateTime.now();
    var firstD = _firstD, secondD = _secondD, thirdD = _thirdD, fourthD = _fourthD;

    if(widget.model.location == 'demo') {
      // Display every 13 seconds
      if (now.second % 13 == 0) {
        var firstNumber = now.minute;
        var secondNumber = now.second;
        firstD = (firstNumber / 10).truncate();
        secondD = firstNumber % 10;
        thirdD = (secondNumber / 10).truncate();
        fourthD = secondNumber % 10;
      }
    } else if (RegExp('^demo-\\d{4}\$', caseSensitive: true, multiLine: false).hasMatch(widget.model.location)) {
      // Display what have been filled by user
      var value = widget.model.location.substring(5);
      firstD = int.parse(value.substring(0, 1));
      secondD = int.parse(value.substring(1, 2));
      thirdD = int.parse(value.substring(2, 3));
      fourthD = int.parse(value.substring(3, 4));
    } else {
      // Default display normal hour being carrefull about format (12/24)
      var firstNumber = widget.model.is24HourFormat ? now.hour : now.hour % 12;
      var secondNumber = now.minute;
      firstD = (firstNumber / 10).truncate();
      secondD = firstNumber % 10;
      thirdD = (secondNumber / 10).truncate();
      fourthD = secondNumber % 10;
    }

    // Update the state if something change
    if (_firstD != firstD || _secondD != secondD || _thirdD != thirdD || _fourthD != fourthD) {
      setState(() {
        _firstD = firstD;
        _secondD = secondD;
        _thirdD = thirdD;
        _fourthD = fourthD;
      });
    }

    // Call this function every exact 1 second
    _timer = Timer(
      Duration(seconds: 1) - Duration(milliseconds: DateTime.now().millisecond),
      _updateDisplay,
    );
  }
}