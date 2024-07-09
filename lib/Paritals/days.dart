import 'package:flutter/material.dart';

Widget weekDay(int day) {
  return Container(
    decoration: BoxDecoration(border: Border.all(color: Colors.black)),
    child: Column(
      children: [
        Text(day.toString()),
        Expanded(
            child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
          ),
        )),
      ],
    ),
  );
}
