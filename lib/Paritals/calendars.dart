import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/Models/all.dart';
import 'package:task_manager/Paritals/days.dart';

class WeekCalendar extends StatefulWidget {
  WeekCalendar({super.key, required this.startDay});

  DateTime startDay;

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          DateFormat("MMMM").format(widget.startDay),
          style: TextStyle(fontSize: 24),
        ),
        Container(
          child: Row(
            children: [
              Container(
                width: 100,
              ),
              Expanded(
                  child: Center(child: Text("Monday ${widget.startDay.day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Tuesday ${widget.startDay.add(Duration(days: 1)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Wednesday ${widget.startDay.add(Duration(days: 2)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Thursday ${widget.startDay.add(Duration(days: 3)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Friday ${widget.startDay.add(Duration(days: 4)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Saturday ${widget.startDay.add(Duration(days: 5)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Sunday ${widget.startDay.add(Duration(days: 6)).day}"))),
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
                      Expanded(child: Text(0.toString())),
                      for (int i = 1; i <= 24; i++) ...[
                        Spacer(),
                        Expanded(child: Text(i.toString())),
                      ]
                    ],
                  ),
                ),
                for (int i = 0; i < 7; i++)
                  Flexible(
                      child: WeekDay(
                          currentDate: widget.startDay.add(Duration(days: i))))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
