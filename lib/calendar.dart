import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Models/all.dart';
import 'package:task_manager/Models/firebase_strings.dart';
import 'package:task_manager/Paritals/calendars.dart';
import 'package:task_manager/Paritals/days.dart';
import 'Models/all.dart' as all;

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late CalendarType type;
  DateTime currentDate = DateTime.now();
  List<Task> tasks = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    type = CalendarType.week;
    getTasks();
    super.initState();
  }

  Future<void> getTasks() async {
    switch (type) {
      case CalendarType.week:
        await db
            .collection(USERS)
            .doc(auth.currentUser!.uid)
            .collection(TASKS)
            .withConverter(
                fromFirestore: Task.fromFirestore,
                toFirestore: (Task task, _) => task.toFirestore())
            .get()
            .then((value) {
          tasks = List.from(value.docs.map((doc) => doc.data()));
        }, onError: (e) {
          print(e);
        });
      case CalendarType.month:
      // TODO: Handle this case.
      case CalendarType.day:
      // TODO: Handle this case.
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "Calendar",
            style: TextStyle(fontSize: 32),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          child: type == CalendarType.week
              ? WeekCalendar(currentDate)
              : WeekCalendar(currentDate),
        ));
  }
}
