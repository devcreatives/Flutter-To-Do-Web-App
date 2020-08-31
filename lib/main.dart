import 'package:flutter/material.dart';
import 'package:flutter_todo_web_app/views/signin.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ToDo Web App',
      theme: ThemeData(
        fontFamily: "OverpassRegular",
        primaryColor: Color(0xff3185FC),
        scaffoldBackgroundColor: Color(0xffFFFAFF),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SignIn(),
    );
  }
}
