import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  List<Task>? tasks;

  User({this.tasks});

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    //Map<String, dynamic>? tempMap = data?['tasks'];
    return User(tasks: data?['tasks']);
  }

  Map<String, dynamic> toFirestore() {
    return {if (tasks != null) 'tasks': tasks};
  }
}

enum CalendarType { month, week, day }

class Task {
  String? title;
  DateTime? dateStart;
  DateTime? dateEnd;

  Task({this.title, this.dateStart, this.dateEnd});

  factory Task.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return Task(
        title: data?['title'],
        dateStart: (data?['dateStart'] as Timestamp).toDate(),
        dateEnd: (data?['dateEnd'] as Timestamp).toDate());
  }

  Map<String, dynamic> toFirestore() {
    return {
      if (title != null) 'title': title,
      if (dateStart != null) 'dateStart': Timestamp.fromDate(dateStart!),
      if (dateEnd != null) 'dateEnd': Timestamp.fromDate(dateEnd!)
    };
  }
}
