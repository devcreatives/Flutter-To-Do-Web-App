import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_web_app/views/signin.dart';

class Widgets {
  Widget mainAppBar({BuildContext context, bool isHome = false}) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Image.asset(
        "assets/images/logo.png",
        height: 35,
      ),
      centerTitle: false,
      elevation: 0.0,
      actions: [
        isHome
            ? IconButton(
                icon: Icon(Icons.logout),
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                })
            : Container(),
      ],
    );
  }
}
