import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Models/all.dart';
import 'package:task_manager/Models/firebase_strings.dart';
import 'package:task_manager/Paritals/calendars.dart';
import 'package:task_manager/Paritals/createPopup.dart';
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
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    type = CalendarType.week;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 65, 65, 65),
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     image: DecorationImage(
      //         image: AssetImage("pexels-tuesday-temptation-190692-3780104.jpg"),
      //         fit: BoxFit.cover)),
      child: Theme(
        data: ThemeData(
            textTheme: TextTheme(bodyMedium: TextStyle(color: Colors.white))),
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.white,
              title: const Text(
                "Calendar",
                style: TextStyle(fontSize: 32),
              ),
              centerTitle: true,
            ),
            drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  const DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                    ),
                    child: Text('Drawer Header'),
                  ),
                  ListTile(
                    title: const Text('Add task'),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(Createpopup<void>());
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            body: Container(
              width: double.infinity,
              child: type == CalendarType.week
                  ? WeekCalendar(currentDate: currentDate)
                  : WeekCalendar(currentDate: currentDate),
            )),
      ),
    );
  }
}
