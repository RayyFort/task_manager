import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
          color: const Color.fromARGB(255, 41, 45, 53),
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                color: Colors.white,
                child: MaterialButton(
                    onPressed: () {
                      startDate = startDate.add(const Duration(days: -7));
                      setState(() {});
                    },
                    child: const Text("back")),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                child: Text(
                  DateFormat("MMMM").format(startDate),
                  style: const TextStyle(fontSize: 24),
                ),
              ),
              Container(
                color: Colors.white,
                child: MaterialButton(
                    onPressed: () {
                      startDate = startDate.add(const Duration(days: 7));
                      setState(() {});
                    },
                    child: const Text("forward")),
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
                          "Tuesday ${startDate.add(const Duration(days: 1)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Wednesday ${startDate.add(const Duration(days: 2)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Thursday ${startDate.add(const Duration(days: 3)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Friday ${startDate.add(const Duration(days: 4)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Saturday ${startDate.add(const Duration(days: 5)).day}"))),
              Expanded(
                  child: Center(
                      child: Text(
                          "Sunday ${startDate.add(const Duration(days: 6)).day}"))),
            ],
          ),
        ),
        Flexible(
          child: Row(
            children: [
              SizedBox(
                width: 100,
                child: Column(
                  children: [
                    for (int i = 0; i <= 23; i++)
                      Expanded(
                          child: Text(
                        i.toString(),
                        style: const TextStyle(height: 0.1),
                      )),
                  ],
                ),
              ),
              for (int i = 0; i < 7; i++)
                Flexible(child: () {
                  GlobalKey tempKey = GlobalKey();
                  WeekDay weekDay = WeekDay(
                      key: tempKey,
                      currentDate: startDate.add(Duration(days: i)));
                  return weekDay;
                }())
            ],
          ),
        ),
      ],
    );
  }
}
