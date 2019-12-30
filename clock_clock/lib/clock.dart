import 'package:analog_clock/analog_clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class Clock extends StatefulWidget {
  const Clock(this.model);

  final ClockModel model;

  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  Widget build (BuildContext context) {
    return Container(
          child: AnalogClock(widget.model),
          width: 75,
          height: 75
        );
  }
}