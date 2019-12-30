import 'package:analog_clock/analog_clock.dart';
import 'package:analog_clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clock_helper/model.dart';

class NumberClock extends StatefulWidget {
  const NumberClock(this.model);

  final ClockModel model;

  @override
  _NumberClockState createState() => _NumberClockState();
}

class _NumberClockState extends State<NumberClock> {
  var _now = DateTime.now();

  Widget build(BuildContext context) {
    return Column(children: <Row>[
      Row(children: <Widget>[
        Clock(widget.model),
        Clock(widget.model)
      ]),
      Row(children: <Widget>[
        Clock(widget.model),
        Clock(widget.model)
      ]),
      Row(children: <Widget>[
        Clock(widget.model),
        Clock(widget.model)
      ])
    ]);
  }
}