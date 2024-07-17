import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_manager/Models/all.dart';
import 'package:task_manager/Paritals/days.dart';

class WeekCalendar extends StatefulWidget {
  WeekCalendar({super.key, required this.currentDate});

  DateTime currentDate;

  @override
  State<WeekCalendar> createState() => _WeekCalendarState();
}

class _WeekCalendarState extends State<WeekCalendar> {
  late DateTime startDate;

  DateTime mostRecentMonday(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 1));

  @override
  void initState() {
    startDate = mostRecentMonday(widget.currentDate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          child: Row(
            children: [
              MaterialButton(
                  onPressed: () {
                    startDate = startDate.add(Duration(days: -7));
                    setState(() {});
                  },
                  child: Text("back")),
              MaterialButton(
                  onPressed: () {
                    startDate = startDate.add(Duration(days: 7));
                    setState(() {});
                  },
                  child: Text("forward")),
              Text(
                DateFormat("MMMM").format(startDate),
                style: TextStyle(fontSize: 24),
              ),
            ],
          ),
        ),
        Container(
          child: Row(
            children: [
              Container(
                width: 100,
              ),
              Expanded(child: Center(child: Text("Monday ${startDate.day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Tuesday ${startDate.add(Duration(days: 1)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Wednesday ${startDate.add(Duration(days: 2)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Thursday ${startDate.add(Duration(days: 3)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Friday ${startDate.add(Duration(days: 4)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Saturday ${startDate.add(Duration(days: 5)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Sunday ${startDate.add(Duration(days: 6)).day}"))),
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
                      for (int i = 0; i <= 23; i++)
                        Expanded(
                            child: Text(
                          i.toString(),
                          style: TextStyle(height: 0.1),
                        )),
                    ],
                  ),
                ),
                for (int i = 0; i < 7; i++)
                  Flexible(
                      child: WeekDay(
                          currentDate: startDate.add(Duration(days: i))))
              ],
            ),
          ),
        ),
      ],
    );
  }
}
