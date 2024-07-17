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
      return Text(
        task.title!,
        style: TextStyle(fontSize: 10, height: 0.1),
        overflow: TextOverflow.ellipsis,
      );
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
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black), color: Colors.black),
      margin: EdgeInsets.fromLTRB(1, 0, 1, 0),
      width: double.infinity,
      child: Column(children: () {
        List<Widget> allHours = [];
        DateTime? currentTime;
        int flexSum = 0;

        if (tasks.isNotEmpty) {
          for (int i = 0; i < tasks.length; i++) {
            if (i == 0) {
              allHours.add(Expanded(
                  flex: () {
                    int tempflex = (tasks[i].dateStart!.hour * 60) +
                        tasks[i].dateStart!.minute;
                    flexSum += tempflex;
                    return tempflex;
                  }(),
                  child: Container(
                    margin: EdgeInsets.all(0.2),
                    color: Colors.black,
                    width: double.infinity,
                  )));
              allHours.add(
                Expanded(
                  flex: () {
                    Duration tempDuration =
                        tasks[i].dateEnd!.difference(tasks[i].dateStart!);

                    int tempflex = tempDuration.inMinutes;
                    flexSum += tempflex;
                    return tempflex;
                  }(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 94, 255, 0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: double.infinity,
                    child: Center(
                        child: Center(
                            child: Text(
                      tasks[i].title!,
                      style: TextStyle(height: 0.1),
                    ))),
                  ),
                ),
              );
              currentTime = tasks[i].dateStart;
            } else {
              allHours.add(Expanded(
                  flex: () {
                    Duration tempDuration =
                        tasks[i].dateStart!.difference(tasks[i - 1].dateEnd!);

                    int tempflex = tempDuration.inMinutes;
                    flexSum += tempflex;
                    return tempflex;
                  }(),
                  child: Container(
                    margin: EdgeInsets.all(0.2),
                    color: Colors.black,
                    width: double.infinity,
                  )));
              allHours.add(
                Expanded(
                  flex: () {
                    Duration tempDuration =
                        tasks[i].dateEnd!.difference(tasks[i].dateStart!);

                    int tempflex = tempDuration.inMinutes;
                    flexSum += tempflex;
                    return tempflex;
                  }(),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 94, 255, 0),
                        borderRadius: BorderRadius.all(Radius.circular(10))),
                    width: double.infinity,
                    child: Center(
                        child: Center(
                            child: Text(
                      tasks[i].title!,
                      style: TextStyle(height: 0.1),
                    ))),
                  ),
                ),
              );
            }
          }
          allHours.add(Expanded(
              flex: () {
                int tempflex = 1440 -
                    ((tasks[tasks.length - 1].dateEnd!.hour * 60) +
                        tasks[tasks.length - 1].dateEnd!.minute);
                flexSum += tempflex;
                return tempflex;
              }(),
              child: Container(
                margin: EdgeInsets.all(0.2),
                color: Colors.black,
                width: double.infinity,
              )));
        } else {
          allHours.add(Expanded(
              flex: 1,
              child: Container(
                margin: EdgeInsets.all(0.2),
                color: Colors.black,
                width: double.infinity,
              )));
        }

        return allHours;
      }()),
    );
  }
}
