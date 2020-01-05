import 'package:analog_clock/clock.dart';
import 'package:flutter/material.dart';

class Digit extends StatelessWidget {
  const Digit(this.digit);

  // Number displayed when showing the welcome letter
  static const int EMPTY =  -1;
  static const int H =  98;
  static const int I = 99;
  
  final int digit;

  Widget build(BuildContext context){
    var display = _getDisplay();
    return Container(
      //color: Colors.red,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Row>[
          Row(
            children: <Widget>[
              Clock(display[0]),
              Clock(display[1])
            ]
          ),
          Row(
            children: <Widget>[
                Clock(display[2]),
                Clock(display[3])         
            ]
          ),
          Row(
            children: <Widget>[
                Clock(display[4]),
                Clock(display[5])         
            ]
          )
        ]
      ),
    );
  }

  DateTime _getTime(int hours, int minutes) {
    var now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hours ?? 22, minutes ?? 50);
  }

  List<DateTime> _getDisplay() {
    switch (digit) {
      case 0:
        return [
          _getTime(3, 30),  _getTime(9, 30),
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
          _getTime(0, 15),  _getTime(6, 45),
          _getTime(0, 15),  _getTime(0, 45)];
        break;
      case 7:
        return [
          _getTime(3, 15),  _getTime(9, 30),
          null,             _getTime(0, 30),
          null,             _getTime(0, 0)];
        break;
      case 8:
        return [
          _getTime(3, 30),  _getTime(9, 30),
          _getTime(0, 15),  _getTime(0, 45),
          _getTime(0, 15),  _getTime(0, 45)];
        break;
      case 9:
        return [
          _getTime(3, 30),  _getTime(9, 30),
          _getTime(0, 15),  _getTime(0, 45),
          _getTime(3, 15),  _getTime(0, 45)];
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