import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:task_manager/Paritals/createPopup.dart';

class DateSelector extends StatefulWidget {
  DateSelector({super.key});

  @override
  State<StatefulWidget> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime? startDate = DateTime.now();
  DateTime? endDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: Text(startDate.toString())),
            Text(endDate.toString())
          ],
        ),
        onTap: () {
          Navigator.of(context).push(Selector()).then((value) {
            value = value as TaskCreationTransition;
            startDate = value?.startDate;
            endDate = value?.endDate;
            taskCreationNotification(startDate!, endDate!).dispatch(context);
            setState(() {});
          });
        });
  }
}

class Selector<T> extends PopupRoute<T> {
  DateTime date = DateTime.now();

  @override
  Color? get barrierColor => Color(0x88000000);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "selector";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FractionallySizedBox(
      alignment: Alignment.center,
      heightFactor: 0.5,
      widthFactor: 0.5,
      child: Scaffold(
          body: Container(
        padding: EdgeInsets.all(10),
        child: Column(children: [
          CalendarDatePicker(
              currentDate: DateTime.now(),
              initialDate: date,
              firstDate: (DateTime.now().subtract(Duration(days: 36500))),
              lastDate: (DateTime.now().add(Duration(days: 36500))),
              onDateChanged: (DateTime dateInput) {
                date = dateInput;
              }),
          Spacer(),
          MaterialButton(
            color: const Color.fromARGB(255, 86, 204, 101),
            onPressed: () async {
              final completer = Completer();
              final result = await Navigator.of(context).pushReplacement(
                  TimeSelector<TaskCreationTransition>(this.date),
                  result: completer.future);
              completer.complete(result);
            },
            child: Text("Next"),
          ),
          Spacer(),
        ]),
      )),
    );
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 100);
}

class TimeSelector<T> extends PopupRoute<T> {
  TimeSelector(DateTime chosenDate) {
    dateBase = chosenDate;
  }

  late DateTime dateBase;

  DateTime startTime = DateTime.now();
  DateTime endTime = DateTime.now();
  TextEditingController startHourController = new TextEditingController();
  TextEditingController startMinuteController = new TextEditingController();
  TextEditingController endHourController = new TextEditingController();
  TextEditingController endMinuteController = new TextEditingController();

  @override
  Color? get barrierColor => Color(0x88000000);

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => "TimeSelector";

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return FractionallySizedBox(
        alignment: Alignment.center,
        heightFactor: 0.5,
        widthFactor: 0.5,
        child: Scaffold(
          body: Container(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Spacer(),
                Text("Start time"),
                Container(
                  child: Row(
                    children: [
                      Spacer(),
                      Flexible(
                        child: TextField(
                            controller: startHourController,
                            decoration: InputDecoration(hintText: "HH")),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: TextField(
                              controller: startMinuteController,
                              decoration: InputDecoration(hintText: "MM")),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(),
                Text("End time"),
                Container(
                  child: Row(
                    children: [
                      Spacer(),
                      Container(
                        child: Flexible(
                          child: TextField(
                              controller: endHourController,
                              decoration: InputDecoration(hintText: "HH")),
                        ),
                      ),
                      Flexible(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                          child: TextField(
                              controller: endMinuteController,
                              decoration: InputDecoration(hintText: "MM")),
                        ),
                      ),
                      Spacer(),
                    ],
                  ),
                ),
                Spacer(),
                Container(
                  child: Row(
                    children: [
                      Spacer(),
                      MaterialButton(
                        color: const Color.fromARGB(255, 86, 204, 101),
                        onPressed: () {},
                        child: Text("Back"),
                      ),
                      Spacer(),
                      MaterialButton(
                        color: const Color.fromARGB(255, 86, 204, 101),
                        onPressed: () {
                          DateTime startDate = DateTime(
                              dateBase.year,
                              dateBase.month,
                              dateBase.day,
                              int.parse(startHourController.text),
                              int.tryParse(startMinuteController.text) ?? 0);
                          DateTime endDate = DateTime(
                              dateBase.year,
                              dateBase.month,
                              dateBase.day,
                              int.parse(endHourController.text),
                              int.tryParse(endMinuteController.text) ?? 0);

                          taskCreationNotification(startDate, endDate)
                              .dispatch(context);

                          Navigator.pop(context,
                              new TaskCreationTransition(startDate, endDate));
                        },
                        child: Text("Done"),
                      ),
                      Spacer()
                    ],
                  ),
                ),
                Spacer()
              ],
            ),
          ),
        ));
  }

  @override
  Duration get transitionDuration => Duration(milliseconds: 300);
}
