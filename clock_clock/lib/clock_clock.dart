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
  int _animationDuration = 3;
  DateTime _lastUpdate = DateTime.now();

  bool get _canUpdate => (_lastUpdate.millisecondsSinceEpoch + _animationDuration * 1000) < DateTime.now().millisecondsSinceEpoch;

  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20.0),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Digit(_firstD, _animationDuration),
            Digit(_secondD, _animationDuration),
            Digit(_thirdD, _animationDuration),
            Digit(_fourthD, _animationDuration),
          ],
        ),
    );
  }

  @override
  void initState() {
    super.initState();

    setState(() {      
      _firstD = Digit.CURRENT_TIME;
      _secondD = Digit.CURRENT_TIME;
      _thirdD = Digit.CURRENT_TIME;
      _fourthD = Digit.CURRENT_TIME;
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

    updateState(Digit.EMPTY, Digit.H, Digit.I, Digit.EMPTY, 4);
    
    // Wait 3 seconds before we display the real hour
    _timer = Timer(
      Duration(seconds: 5),
      _updateDisplayWithTime,
    );
  }

  void _updateDisplayWithTime() {
    var animationDuration = 10;

    var now = DateTime.now();
    // We add the duration animation so when the animation stop when the time change
    now = now.add(Duration(seconds: animationDuration));

    var firstD = _firstD, secondD = _secondD, thirdD = _thirdD, fourthD = _fourthD;
    
    if(widget.model.location == 'demo') {
      // Display every 13 seconds
      if (DateTime.now().difference(_lastUpdate).inSeconds >= 13) {
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

    updateState(firstD, secondD, thirdD, fourthD, animationDuration);

    // Call this function every exact 1 second
    _timer = Timer(
      Duration(seconds: 1) - Duration(milliseconds: DateTime.now().millisecond),
      _updateDisplayWithTime,
    );
  }

  void updateState(int firstD, int secondD, int thirdD, int fourthD, int animationDuration) {
    if (_canUpdate) {
      if (_firstD != firstD || _secondD != secondD || _thirdD != thirdD || _fourthD != fourthD || _animationDuration != animationDuration) {
        setState(() {
          _firstD = firstD;
          _secondD = secondD;
          _thirdD = thirdD;
          _fourthD = fourthD;
          _animationDuration = animationDuration;
        });
        
        _lastUpdate = DateTime.now();
      }
    }
  }
}