import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/Paritals/days.dart';

Widget WeekCalendar(DateTime startDay) {
  return Column(
    children: [
      Text(
        DateFormat("MMMM").format(startDay),
        style: TextStyle(fontSize: 24),
      ),
      Container(
        child: Row(
          children: [
            Container(
              width: 100,
            ),
            Expanded(child: Center(child: Text("Monday ${startDay.day}"))),
            Expanded(
                child: Center(
                    child: Text(
                        "Tuesday ${startDay.add(Duration(days: 1)).day}"))),
            Expanded(
                child: Center(
                    child: Text(
                        "Wednesday ${startDay.add(Duration(days: 2)).day}"))),
            Expanded(
                child: Center(
                    child: Text(
                        "Thursday ${startDay.add(Duration(days: 3)).day}"))),
            Expanded(
                child: Center(
                    child:
                        Text("Friday ${startDay.add(Duration(days: 4)).day}"))),
            Expanded(
                child: Center(
                    child: Text(
                        "Saturday ${startDay.add(Duration(days: 5)).day}"))),
            Expanded(
                child: Center(
                    child:
                        Text("Sunday ${startDay.add(Duration(days: 6)).day}"))),
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
              for (int i = 0; i < 7; i++) Flexible(child: weekDay())
            ],
          ),
        ),
      ),
    ],
  );
}
