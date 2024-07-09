import 'package:flutter/material.dart';
import 'package:task_manager/Paritals/days.dart';

Widget WeekCalendar(int startDay) {
  return Column(
    children: [
      Container(
        child: Row(
          children: [
            Container(
              width: 100,
            ),
            Expanded(
                child: Center(child: Text("Monday ${(startDay).toString()}"))),
            Expanded(
                child: Center(
                    child: Text("Tuesday ${(startDay + 1).toString()}"))),
            Expanded(
                child: Center(
                    child: Text("Wednesday ${(startDay + 2).toString()}"))),
            Expanded(
                child: Center(
                    child: Text("Thursday ${(startDay + 3).toString()}"))),
            Expanded(
                child:
                    Center(child: Text("Friday ${(startDay + 4).toString()}"))),
            Expanded(
                child: Center(
                    child: Text("Saturday ${(startDay + 5).toString()}"))),
            Expanded(
                child:
                    Center(child: Text("Sunday ${(startDay + 6).toString()}"))),
          ],
        ),
      ),
      Container(
        child: Flexible(
          child: Row(
            children: [
              Container(
                width: 100,
                child: Column(
                  children: [
                    for (int i = 1; i <= 24; i++)
                      Expanded(child: Center(child: Text(i.toString())))
                  ],
                ),
              ),
              for (int i = startDay; i < startDay + 7; i++)
                Flexible(child: weekDay())
            ],
          ),
        ),
      ),
    ],
  );
}
