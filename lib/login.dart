import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:task_manager/Models/firebase_strings.dart';
import 'package:task_manager/day.dart';
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
        all.User user = all.User(uid: credentials.user!.uid);
        db
            .collection(USERS)
            .add(user.toFirestore())
            .then((documentSnapshot) => print("Added new user"));
      }
      return credentials;
    } catch (e) {
      //code="popup-closed-by-user"
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
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Login"),
        centerTitle: true,
      ),
      body: MaterialButton(
        onPressed: () async {
          UserCredential? credentials = await signInWithGoogle();
          if (credentials?.user != null) {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const Day(),
              ),
            );
          }
          int i = 1;
        },
        child: const Text("login"),
      ),
    );
  }
}
