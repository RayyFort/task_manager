import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Models/firebase_strings.dart';
import 'package:task_manager/calendar.dart';
import 'Models/all.dart' as all;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<UserCredential?> signInWithGoogle() async {
    // Create a new provider
    GoogleAuthProvider googleProvider = GoogleAuthProvider();

    googleProvider
        .addScope('https://www.googleapis.com/auth/contacts.readonly');
    googleProvider.setCustomParameters(
        {'prompt': 'select_account', 'login_hint': 'user@example.com'});

    // Once signed in, return the UserCredential
    try {
      UserCredential credentials =
          await FirebaseAuth.instance.signInWithPopup(googleProvider);
      if (credentials.user != null &&
          credentials.additionalUserInfo!.isNewUser) {
        all.User user = all.User();
        db
            .collection(USERS)
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set(<String, dynamic>{}).then(
                (documentSnapshot) => print("Added new user"));
      }
      return credentials;
    } catch (e) {
      //e.code="popup-closed-by-user"
      return null;
    }

    // Or use signInWithRedirect
    // return await FirebaseAuth.instance.signInWithRedirect(googleProvider);
  }

  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const Calendar(),
          ),
        );
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
              image: AssetImage(
                  "../../assets/pexels-tuesday-temptation-190692-3780104.jpg"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    "Task Manager",
                    style: TextStyle(
                        fontSize: 60,
                        fontFamily: "Bodoni",
                        color: Colors.white),
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(14)),
                    color: Color.fromARGB(255, 245, 242, 255)),
                child: MaterialButton(
                  padding: EdgeInsets.fromLTRB(0, 15, 0, 15),
                  onPressed: () async {
                    UserCredential? credentials = await signInWithGoogle();
                    if (credentials?.user != null) {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const Calendar(),
                        ),
                      );
                    }
                    int i = 1;
                  },
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(
                          "../../customIcons/googleIcon.png",
                          scale: 12.5,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                          child: Text(
                            "Login",
                            style: TextStyle(color: Colors.black, fontSize: 15),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
