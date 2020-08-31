import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseServices {
  void uploadUserInfo(String userId, Map userMap) {
    Firestore.instance
        .collection("users")
        .document(userId)
        .setData(userMap)
        .catchError((e) {
      print(e.toString());
    });
  }

  void createTask(String userId, Map taskMap) {
    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("tasks")
        .add(taskMap);
  }

  // Future<Stream<QuerySnapshot>> getTasks(String userId) async {
  //   return await Firestore.instance
  //       .collection("users")
  //       .document(userId)
  //       .collection("tasks")
  //       .snapshots();
  // }

  void updateTask(String userId, Map taskMap, String documentId) {
    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("tasks")
        .document(documentId)
        .setData(taskMap, merge: true);
  }

  void deleteTask(String userId, String documentId) {
    Firestore.instance
        .collection("users")
        .document(userId)
        .collection("tasks")
        .document(documentId)
        .delete()
        .catchError((e) {
      print(e.toString());
    });
  }
}
