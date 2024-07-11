import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Models/all.dart';
import 'package:task_manager/Models/firebase_strings.dart';

class WeekDay extends StatefulWidget {
  WeekDay({super.key, required this.currentDate});

  DateTime currentDate;

  @override
  State<WeekDay> createState() => _WeekDayState();
}

class _WeekDayState extends State<WeekDay> {
  List<Task> tasks = [];
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  int taskCount = 0;

  Future<void> getTasks() async {
    await db
        .collection(USERS)
        .doc(auth.currentUser!.uid)
        .collection(TASKS)
        .where("dateStart",
            isGreaterThanOrEqualTo: Timestamp.fromDate(
              DateTime(widget.currentDate.year, widget.currentDate.month,
                  widget.currentDate.day, 0, 0, 0),
            ),
            isLessThanOrEqualTo: Timestamp.fromDate(DateTime(
                widget.currentDate.year,
                widget.currentDate.month,
                widget.currentDate.day,
                24,
                0,
                0)))
        .orderBy("dateStart")
        .withConverter(
            fromFirestore: Task.fromFirestore,
            toFirestore: (Task task, _) => task.toFirestore())
        .get()
        .then((value) {
      tasks = List.from(value.docs.map((doc) => doc.data()));
      if (tasks.isNotEmpty) setState(() {});
    }, onError: (e) {
      print(e);
    });
  }

  Widget? isTime(Task task, int currentTime) {
    int middle = ((task.dateStart!.hour + task.dateEnd!.hour) / 2).floor();
    if (middle == currentTime) {
      return Text(task.title!);
    }

    return null;
  }

  @override
  void initState() {
    getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.black)),
      child: Column(
        children: [
          for (int i = 0; i <= 24; i++)
            if (tasks.isNotEmpty &&
                tasks[taskCount].dateStart!.hour <= i &&
                tasks[taskCount].dateEnd!.hour > i)
              Expanded(
                  child: Container(
                      color: Colors.amber,
                      width: double.infinity,
                      child: Center(child: isTime(tasks[taskCount], i))))
            else
              Expanded(
                child: Container(
                  color: Colors.black,
                  width: double.infinity,
                ),
              )
        ],
      ),
    );
  }
}
