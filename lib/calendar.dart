import 'package:flutter/material.dart';
import 'package:task_manager/Models/all.dart';
import 'package:task_manager/Paritals/calendars.dart';
import 'package:task_manager/Paritals/days.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late CalendarType type;

  @override
  void initState() {
    type = CalendarType.week;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text("Calendar"),
          centerTitle: true,
        ),
        body: Container(
          child: type == CalendarType.week ? WeekCalendar(1) : WeekCalendar(1),
        ));
  }
}
