import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_todo_web_app/helper_functions/helper_functions.dart';
import 'package:flutter_todo_web_app/services/database.dart';
import 'package:flutter_todo_web_app/widgets/widget.dart';

class Home extends StatefulWidget {
  String userEmail;
  String username;
  Home({this.userEmail, this.username});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String date;
  String currentUserId;
  TextEditingController taskEdittingControler = new TextEditingController();

  DatabaseServices databaseServices = new DatabaseServices();
  Stream taskStream;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var now = DateTime.now();
    date =
        "${HelperFunctions.getWeek(now.weekday)} ${HelperFunctions.getYear(now.month)} ${now.day}";

    _getCurrentUserId();

    // databaseServices.getTasks(currentUserId).then((value) {
    //   taskStream = value;
    //   setState(() {});
    // });
  }

  void _getCurrentUserId() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    setState(() {
      currentUserId = user.uid;
    });
  }

  void _addTask() {
    Map<String, dynamic> taskMap = {
      "task": taskEdittingControler.text,
      "isCompleted": false,
      "timestamp": DateTime.now()
    };

    databaseServices.createTask(currentUserId, taskMap);
    taskEdittingControler.clear();
    setState(() {});
  }

  Widget taskList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("users")
          .document(currentUserId)
          .collection("tasks")
          .orderBy("timestamp", descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
            padding: EdgeInsets.only(top: 16),
            itemCount: snapshot.data.documents.length,
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemBuilder: (context, index) {
              return TaskTile(
                currentUserId,
                snapshot.data.documents[index].data["isCompleted"],
                snapshot.data.documents[index].data["task"],
                snapshot.data.documents[index].documentID,
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Widgets().mainAppBar(context: context, isHome: true),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: 800.0,
            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "My Day",
                  style: TextStyle(
                    fontSize: 18,
                  ),
                ),
                Text("$date"),
                SizedBox(
                  height: 30.0,
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        focusNode: FocusNode(),
                        keyboardType: TextInputType.multiline,
                        controller: taskEdittingControler,
                        decoration: InputDecoration(hintText: "task"),
                        onChanged: (val) {
                          // taskEdittingControler.text = val;
                          setState(() {});
                        },
                      ),
                    ),
                    SizedBox(
                      width: 6,
                    ),
                    taskEdittingControler.text.isNotEmpty
                        ? GestureDetector(
                            onTap: _addTask,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 5),
                              child: Text("ADD"),
                            ),
                          )
                        : Container(),
                  ],
                ),
                SizedBox(height: 30.0),
                taskList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class TaskTile extends StatefulWidget {
  final currentUserId;
  final bool isCompleted;
  final String task;
  final String documentId;
  TaskTile(this.currentUserId, this.isCompleted, this.task, this.documentId);

  @override
  _TaskTileState createState() => _TaskTileState();
}

class _TaskTileState extends State<TaskTile> {
  void _updateTask() {
    Map<String, dynamic> taskMap = {"isCompleted": !widget.isCompleted};

    DatabaseServices()
        .updateTask(widget.currentUserId, taskMap, widget.documentId);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: _updateTask,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black87, width: 1),
                        borderRadius: BorderRadius.circular(30)),
                    child: widget.isCompleted
                        ? Icon(
                            Icons.check,
                            color: Colors.green,
                          )
                        : Container(),
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Expanded(
                  child: Text(
                    widget.task,
                    style: TextStyle(
                        color: widget.isCompleted
                            ? Colors.black87
                            : Colors.black87.withOpacity(0.7),
                        fontSize: 17,
                        decoration: widget.isCompleted
                            ? TextDecoration.lineThrough
                            : TextDecoration.none),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            width: 4.0,
          ),
          GestureDetector(
            onTap: () {
              DatabaseServices()
                  .deleteTask(widget.currentUserId, widget.documentId);
            },
            child: Icon(Icons.close,
                size: 13, color: Colors.black87.withOpacity(0.7)),
          )
        ],
      ),
    );
  }
}
