import 'dart:async';

import 'package:analog_clock/digit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

/// This is the main widget of the clock, it will contains 4 digits displayed with six clocks
/// The widget is updated every second to know what are the digits we need to display.
class ClockClock extends StatefulWidget {
  const ClockClock(this.model);

  final ClockModel model;

  @override
  _ClockClockState createState() => _ClockClockState();
}

/// Ths state of the clock.
class _ClockClockState extends State<ClockClock> {
  Timer _timer;
  int _firstD, _secondD, _thirdD, _fourthD;
  int _animationDuration = 0;
  DateTime _lastUpdate = DateTime.now();
  int _rebuildCounter = 0;

  /// To avoid flsahing start, we use opacity animation for the first build only
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(seconds: 2),
      opacity: _rebuildCounter++ > 0 ? 1 : 0,
      child: Container(
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
      ),
    );
  }

  /// At the begining, we display the current time without the digits. Then it will diplsay the hi message
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
      _hi,
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// Display the Hi animation and the display the time with the clocks
  void _hi() {
    // Set the initial values.
    // We display a "HI!" message during the startup

    updateState(Digit.EMPTY, Digit.H, Digit.I, Digit.EMPTY, 4);
    
    // Wait 3 seconds before we display the real hour
    _timer = Timer(
      Duration(seconds: 5),
      _updateDisplayWithTime,
    );
  }

  /// This function will display the time with the clocks. There is different modes that will be choosed here.
  /// The following different role, was for development purpose but I left them also for demo.
  /// If the widget.model.location is 'demo', we will display miutes/seconds and update every 13 seconds.
  /// If the widget.model.location is 'demo-XXXX' where X is a digit, it will displayed the 'XXXX'
  /// 
  /// In every other case, we display the current time.
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

  /// Funciton tat manage the update of the state. We check that the last animation is already ended before updating the state.
  void updateState(int firstD, int secondD, int thirdD, int fourthD, int animationDuration) {    
    /// To avoid multiple animations launch at the same time (for exemple if the time updated before the welcome message finished),
    /// we check that the previous animation is finished before updating.
    /// In result, in a really rare case, the hour displayed can be false during some seconds.
    bool canUpdate = (_lastUpdate.millisecondsSinceEpoch + _animationDuration * 1000) < DateTime.now().millisecondsSinceEpoch;
    if (canUpdate) {
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