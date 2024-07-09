import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String? uid;

  User({this.uid});

  factory User.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();
    return User(uid: data?['uid']);
  }

  Map<String, dynamic> toFirestore() {
    return {if (uid != null) 'uid': uid};
  }
}
