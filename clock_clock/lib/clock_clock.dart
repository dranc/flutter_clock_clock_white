import 'dart:async';

import 'package:analog_clock/clock.dart';
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
  Timer _timer;

  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      /*
      Digit((_now.hour / 10).truncate()),
      Digit(_now.hour % 10),
      Text(':'),
      */
      Digit((_now.minute / 10).truncate()),
      Digit(_now.minute % 10),
      Text(':'),
      Digit((_now.second / 10).truncate()),
      Digit(_now.second % 10),
    ],);    
  }

  @override
  void initState() {
    super.initState();
    widget.model.addListener(_updateModel);
    // Set the initial values.
    _updateTime();
    _updateModel();
  }

  @override
  void dispose() {
    _timer?.cancel();
    widget.model.removeListener(_updateModel);
    super.dispose();
  }

  void _updateModel() {
    setState(() {
      
    });
  }

  void _updateTime() {
    setState(() {
      _now = DateTime.now();
      // Update once per second. Make sure to do it at the beginning of each
      // new second, so that the clock is accurate.
      _timer = Timer(
        Duration(seconds: 1) - Duration(milliseconds: _now.millisecond),
        _updateTime,
      );
    });
  }
}