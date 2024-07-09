import 'package:flutter/material.dart';

Widget weekDay(int day) {
  return Column(
    children: [
      Text(day.toString()),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 40)],
          color: Colors.white,
        ),
      )),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 40)],
          color: Colors.white,
        ),
      )),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 40)],
          color: Colors.white,
        ),
      )),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 40)],
          color: Colors.white,
        ),
      )),
      Expanded(
          child: Container(
        decoration: BoxDecoration(
          boxShadow: [BoxShadow(color: Colors.black, blurRadius: 40)],
          color: Colors.white,
        ),
      )),
    ],
  );
}
