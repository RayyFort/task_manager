import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:omni_datetime_picker/omni_datetime_picker.dart';
import 'package:task_manager/Models/all.dart';
import 'package:task_manager/Models/firebase_strings.dart';
import 'package:task_manager/Paritals/dateSelector.dart';

class Createpopup<T> extends PopupRoute<T> {
  TextEditingController titleController = TextEditingController();
  String? taskId = null;

  Createpopup(Task? task) {
    if (task != null) {
      print(task.title);
      taskId = task.id;
      startDate = task.dateStart;
      endDate = task.dateEnd;
      titleController.text = task.title!;
    }
  }

  DateTime? startDate;
  DateTime? endDate;
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
    if (taskId != null) {
      await db
          .collection(USERS)
          .doc(auth.currentUser!.uid)
          .collection(TASKS)
          .doc(taskId)
          .withConverter(
            fromFirestore: Task.fromFirestore,
            toFirestore: (value, options) => value.toFirestore(),
          )
          .update({
        "title": titleController.text,
        "dateStart": startDate,
        "dateEnd": endDate
      }).then(
        (value) {
          print("success adding task");
        },
        onError: (e) {
          print(e);
        },
      );
    } else {
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
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: const EdgeInsets.fromLTRB(500, 250, 500, 250),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Dialog(
        child: Column(
          children: <Widget>[
            Text('Create Task',
                style: Theme.of(context).textTheme.headlineSmall),
            const Text("title"),
            TextField(
              controller: titleController,
            ),
            NotificationListener<taskCreationNotification>(
              child: DateSelector(
                dateStart: this.startDate,
                dateEnd: this.endDate,
              ),
              onNotification: (n) {
                this.startDate = n.startDate;
                this.endDate = n.endDate;
                return true;
              },
            ),
            const Spacer(),
            MaterialButton(
              onPressed: () async {
                await CreateTask();
              },
              child: const Text("send"),
            ),
          ],
        ),
      ),
    );
  }
}

class taskCreationNotification extends Notification {
  final DateTime startDate;
  final DateTime endDate;
  taskCreationNotification(this.startDate, this.endDate);
}

class TaskCreationTransition {
  final DateTime startDate;
  final DateTime endDate;
  TaskCreationTransition(this.startDate, this.endDate);
}
