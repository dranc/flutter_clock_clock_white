import 'dart:math';

import 'package:analog_clock/clock.dart';
import 'package:flutter/material.dart';

class Digit extends StatelessWidget {
  Digit(this.digit, this.animationDuration);

  // Number displayed when showing the welcome letter
  static const int EMPTY =  -1;
  static const int H =  98;
  static const int I = 99;
  static const int NOON = 100;
  static const int CURRENT_TIME = 101;
  
  final int digit;
  final int animationDuration;

  Widget build(BuildContext context){
    var display = _getDisplay();

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        double size = constraints.maxHeight / 5;
        return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Row>[
              Row(
                children: <Widget>[
                  Clock(display[0], size, animationDuration),
                  Clock(display[1], size, animationDuration),
                ]
              ),
              Row(
                children: <Widget>[
                    Clock(display[2], size, animationDuration),
                    Clock(display[3], size, animationDuration),      
                ]
              ),
              Row(
                children: <Widget>[
                    Clock(display[4], size, animationDuration),
                    Clock(display[5], size, animationDuration),       
                ]
              )
            ]
          );
      },
    );
  }

  DateTime _getTime(int hours, int minutes) {
    return DateTime(0, 0, 0, hours % 12, minutes);
  }

  List<DateTime> _getDisplay() {
    switch (digit) {
      case 0:
        return [
          _getTime(6, 15),  _getTime(6, 45),
          _getTime(0, 30),  _getTime(0, 30),
          _getTime(0, 15),  _getTime(0, 45)];
        break;
      case 1:
        return [
          null,             _getTime(6, 30),
          null,             _getTime(0, 30),
          null,             _getTime(0, 0)];
        break;
      case 2:
        return [
          _getTime(3, 15),  _getTime(6, 45),
          _getTime(6, 15),  _getTime(0, 45),
          _getTime(0, 15),  _getTime(9, 45)];
        break;
      case 3:
        return [
          _getTime(3, 15),  _getTime(6, 45),
          _getTime(3, 15),  _getTime(0, 30),
          _getTime(3, 15),  _getTime(0, 45)];
        break;
      case 4:
        return [
          _getTime(6, 30),  _getTime(6, 30),
          _getTime(0, 15),  _getTime(0, 45),
          null,             _getTime(0, 0)];
        break;
      case 5:
        return [
          _getTime(6, 15),  _getTime(9, 45),
          _getTime(0, 15),  _getTime(6, 45),
          _getTime(3, 15),  _getTime(0, 45)];
        break;
      case 6:
        return [
          _getTime(6, 15),  _getTime(9, 45),
          _getTime(6, 15),  _getTime(6, 45),
          _getTime(0, 15),  _getTime(0, 45)];
        break;
      case 7:
        return [
          _getTime(3, 15),  _getTime(6, 45),
          null,             _getTime(6, 00),
          null,             _getTime(0, 0)];
        break;
      case 8:
        return [
          _getTime(3, 30),  _getTime(9, 30),
          _getTime(3, 0),   _getTime(9, 0),
          _getTime(0, 15),  _getTime(0, 45)];
        break;
      case 9:
        return [
          _getTime(3, 30),  _getTime(9, 30),
          _getTime(3, 0),   _getTime(9, 0),
          _getTime(3, 15),  _getTime(9, 0)];
        break;
      case H:
        return [
          _getTime(6, 30),  _getTime(6, 30),
          _getTime(3, 0),   _getTime(9, 0),
          _getTime(0, 0),   _getTime(0, 0)];
        break;
      case I:
        return [
          _getTime(6, 30),  _getTime(6, 30),
          _getTime(0, 30),  _getTime(0, 0),
          _getTime(0, 0),   _getTime(0, 0)];
        break;
      case NOON:
        return [
          _getTime(0, 0),  _getTime(0, 0),
          _getTime(0, 0),  _getTime(0, 0),
          _getTime(0, 0),  _getTime(0, 0)];
        break;
      case CURRENT_TIME:
        // In this particular case, we return the current with a random number of hour added to it. All clock will be true in a specific time zone.
        var now = DateTime.now();
        return [
          _getTime(now.hour + Random().nextInt(12), now.minute),
          _getTime(now.hour + Random().nextInt(12), now.minute),
          _getTime(now.hour + Random().nextInt(12), now.minute),
          _getTime(now.hour + Random().nextInt(12), now.minute),
          _getTime(now.hour + Random().nextInt(12), now.minute),
          _getTime(now.hour + Random().nextInt(12), now.minute)];
        break;
      case EMPTY:
        return [
          null,             null,
          null,             null,
          null,             null];
        break;
      default:
        throw Exception('$digit is not supported by the digit widget.');
        break;
    }
  }
}