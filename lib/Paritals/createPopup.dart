import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:task_manager/Models/all.dart';
import 'package:task_manager/Models/firebase_strings.dart';

class Createpopup<T> extends PopupRoute<T> {
  TextEditingController titleController = TextEditingController();
  DateTime? startDate = null;
  DateTime? endDate = null;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Color? get barrierColor => Colors.black.withAlpha(0x50);

  // This allows the popup to be dismissed by tapping the scrim or by pressing
  // the escape key on the keyboard.
  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => 'Create Task';

  @override
  Duration get transitionDuration => const Duration(milliseconds: 300);

  Future<void> CreateTask() async {
    await db
        .collection(USERS)
        .doc(auth.currentUser!.uid)
        .collection(TASKS)
        .withConverter(
          fromFirestore: Task.fromFirestore,
          toFirestore: (value, options) => value.toFirestore(),
        )
        .add(Task(
            title: titleController.text,
            dateStart: startDate,
            dateEnd: endDate))
        .then(
      (value) {
        print("success adding task");
      },
      onError: (e) {
        print(e);
      },
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.fromLTRB(500, 250, 500, 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Dialog(
        child: Column(
          children: <Widget>[
            Text('Create Task',
                style: Theme.of(context).textTheme.headlineSmall),
            Text("title"),
            TextField(
              controller: titleController,
            ),
            MaterialButton(
              onPressed: () async {
                startDate = await showOmniDateTimePicker(context: context);
              },
              child: Text("start date"),
            ),
            MaterialButton(
              onPressed: () async {
                endDate = await showOmniDateTimePicker(context: context);
              },
              child: Text("end date"),
            ),
            Spacer(),
            MaterialButton(
              onPressed: () async {
                await CreateTask();
              },
              child: Text("send"),
            )
          ],
        ),
      ),
    );
  }
}
