import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:super_context_menu/super_context_menu.dart';
import 'package:task_manager/Models/all.dart';
import 'package:task_manager/Models/firebase_strings.dart';
import 'package:task_manager/Paritals/createPopup.dart';

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
  List<Widget> tasksWidget = [];
  int? currentHover;

  Future<void> DeleteTask(String id, int pos) async {
    await db
        .collection(USERS)
        .doc(auth.currentUser!.uid)
        .collection(TASKS)
        .doc(id)
        .delete()
        .then((doc) {
      tasks.removeAt(pos);
      setState(() {});
      //deleted
    }, onError: (e) {
      //not deleted
    });
  }

  Future<void> getTasks() async {
    tasks = List.empty();
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
      if (tasks.isNotEmpty) {
        setupTasks();
      }
    }, onError: (e) {
      print(e);
    });
  }

  Widget? isTime(Task task, int currentTime) {
    int middle = ((task.dateStart!.hour + task.dateEnd!.hour) / 2).floor();
    if (middle == currentTime) {
      return Text(
        task.title!,
        style: const TextStyle(fontSize: 10, height: 0.1),
        overflow: TextOverflow.ellipsis,
      );
    }

    return null;
  }

  void setupTasks() {
    List<Widget> allHours = [];
    DateTime? currentTime;
    int flexSum = 0;
    for (int i = 0; i < tasks.length; i++) {
      if (i == 0) {
        allHours.add(Expanded(
            flex: () {
              int tempflex =
                  (tasks[i].dateStart!.hour * 60) + tasks[i].dateStart!.minute;
              flexSum += tempflex;
              return tempflex;
            }(),
            child: Container(
              margin: const EdgeInsets.all(0.2),
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
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 52, 184),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: double.infinity,
              child: ContextMenuWidget(
                child: MouseRegion(
                  cursor: SystemMouseCursors.basic,
                  onEnter: (event) {
                    setState(() {
                      currentHover = i;
                      setupTasks();
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      currentHover = null;
                      setupTasks();
                    });
                  },
                  child: Center(
                      child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Text(
                        tasks[i].title!,
                        style: const TextStyle(height: 0.1),
                      ),
                      if (currentHover == i)
                        Positioned(
                            bottom: -30,
                            child: Container(
                              color: Colors.white,
                              child: Text(
                                "${tasks[i].dateStart!.hour}h${tasks[i].dateStart!.minute.toString().padLeft(2, '0')} - ${tasks[i].dateEnd!.hour}h${tasks[i].dateEnd!.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(color: Colors.black),
                              ),
                            ))
                    ],
                  )),
                ),
                menuProvider: (_) {
                  return Menu(children: [
                    MenuAction(
                        title: "Delete",
                        callback: () {
                          DeleteTask(tasks[i].id!, i);
                        }),
                    MenuAction(
                        title: "Modify",
                        callback: () {
                          Navigator.of(context)
                              .push(Createpopup<void>(tasks[i]));
                        })
                  ]);
                },
              ),
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
              margin: const EdgeInsets.all(0.2),
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
              decoration: const BoxDecoration(
                  color: Color.fromARGB(255, 0, 52, 184),
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              width: double.infinity,
              child: ContextMenuWidget(
                child: MouseRegion(
                  cursor: SystemMouseCursors.basic,
                  onEnter: (event) {
                    setState(() {
                      currentHover = i;
                      setupTasks();
                    });
                  },
                  onExit: (event) {
                    setState(() {
                      currentHover = null;
                      setupTasks();
                    });
                  },
                  child: Center(
                      child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Text(
                        tasks[i].title!,
                        style: const TextStyle(height: 0.1),
                      ),
                      if (currentHover == i)
                        Positioned(
                            bottom: -30,
                            child: Container(
                              color: Colors.white,
                              child: Text(
                                "${tasks[i].dateStart!.hour}h${tasks[i].dateStart!.minute.toString().padLeft(2, '0')} - ${tasks[i].dateEnd!.hour}h${tasks[i].dateEnd!.minute.toString().padLeft(2, '0')}",
                                style: const TextStyle(color: Colors.black),
                              ),
                            )),
                    ],
                  )),
                ),
                menuProvider: (_) {
                  return Menu(children: [
                    MenuAction(
                        title: "Delete",
                        callback: () {
                          DeleteTask(tasks[i].id!, i);
                        }),
                    MenuAction(
                        title: "Modify",
                        callback: () {
                          Navigator.of(context)
                              .push(Createpopup<void>(tasks[i]));
                        })
                  ]);
                },
              ),
            ),
          ),
        );
      }
      setState(() {});
    }
    allHours.add(Expanded(
        flex: () {
          if (tasks.length > 0) {
            int tempflex = 1440 -
                ((tasks[tasks.length - 1].dateEnd!.hour * 60) +
                    tasks[tasks.length - 1].dateEnd!.minute);
            flexSum += tempflex;
            return tempflex;
          }
          return 1;
        }(),
        child: Container(
          margin: const EdgeInsets.all(0.2),
          color: Colors.black,
          width: double.infinity,
        )));
    allHours = List.from(allHours.reversed);
    tasksWidget = allHours;
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
      margin: const EdgeInsets.fromLTRB(1, 0, 1, 0),
      width: double.infinity,
      child: Column(
          verticalDirection: VerticalDirection.up,
          children: () {
            if (tasksWidget.isNotEmpty) {
              return tasksWidget;
            }
            return List<Widget>.filled(
                1,
                Expanded(
                    flex: 1,
                    child: Container(
                      margin: const EdgeInsets.all(0.2),
                      color: Colors.black,
                      width: double.infinity,
                    )));
          }()),
    );
  }
}
