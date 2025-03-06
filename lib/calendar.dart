import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Models/all.dart';
import 'package:task_manager/Paritals/calendars.dart';
import 'package:task_manager/Paritals/createPopup.dart';

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
  final GlobalKey<ScaffoldState> _sKey = GlobalKey();

  @override
  void initState() {
    type = CalendarType.week;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 49, 54, 63),
      // decoration: BoxDecoration(
      //     color: Colors.white,
      //     image: DecorationImage(
      //         image: AssetImage("pexels-tuesday-temptation-190692-3780104.jpg"),
      //         fit: BoxFit.cover)),
      child: Theme(
        data: ThemeData(
            textTheme:
                const TextTheme(bodyMedium: TextStyle(color: Colors.white))),
        child: Scaffold(
            key: _sKey,
            backgroundColor: Colors.transparent,
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
                      Navigator.of(context).push(Createpopup<void>(null));
                    },
                  ),
                  ListTile(
                    title: const Text('Logout'),
                    onTap: () {
                      _signOut();
                    },
                  ),
                ],
              ),
            ),
            body: SizedBox(
              width: double.infinity,
              child: type == CalendarType.week
                  ? WeekCalendar(currentDate: currentDate, scaffoldKey: _sKey)
                  : WeekCalendar(
                      currentDate: currentDate,
                      scaffoldKey: _sKey,
                    ),
            )),
      ),
    );
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
