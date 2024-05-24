import 'dart:async';
import 'package:ark_jots/modules/auth/auth_service.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:ark_jots/utils/tools.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Reads all documments from the topics collection
  Future<List<Task>> getUserTasks() async {
    final user = AuthService().user!;

    var ref = _db.collection('users').doc(user.uid).collection('tasks');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var tasks = data.map((d) => Task.fromJson(d)).toList();
    return tasks;
  }

  /// Retrieves a single quiz document
  // Future<Quiz> getQuiz(String quizId) async {
  //   var ref = _db.collection('quizzes').doc(quizId);
  //   var snapshot = await ref.get();
  //   return Quiz.fromJson(snapshot.data() ?? {});
  // }

  // Stream<Report> streamReport() {
  //   return AuthService().userStream.switchMap((user) {
  //     if (user != null) {
  //       var ref = _db.collection('reports').doc(user.uid);
  //       return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
  //     } else {
  //       return Stream.fromIterable([Report()]);
  //     }
  //   });
  // }

  /// Uploads all tasks to Firestore
  Future<void> uploadTasks(List<Task> tasks) async {
    final user = AuthService().user!;

    var ref = _db.collection('users').doc(user.uid).collection('tasks');
    var batch = _db.batch();

    for (var task in tasks) {
      // Firestore generates a unique id for the document if one is not present
      var docRef;

      if (task.id == null) {
        docRef = ref.doc();
        // Update the task id with the Firestore id
        task.id = docRef.id;
        print('Task ID: ${task.id}');
        task.save();
      } else {
        docRef = ref.doc(task.id);
      }
      // Convert the Task object to a map
      var taskMap = task.toJson();

      // Convert each Subtask object in the subtasks list to a map
      taskMap['subtasks'] =
          task.subtasks.map((subtask) => subtask.toJson()).toList();

      batch.set(docRef, taskMap);
    }

    // Add a last update timestamp to the document
    batch.set(
      _db.collection('users').doc(user.uid),
      {'lastUpdate': FieldValue.serverTimestamp()},
      SetOptions(merge: true),
    );

    await batch.commit();
  }

  // Retrieve the last update timestamp from Firestore
  Future<String> getLastUpdate() async {
    final user = AuthService().user!;

    var ref = _db.collection('users').doc(user.uid);
    var snapshot = await ref.get();
    var data = snapshot.data();
    if (data != null && data['lastUpdate'] != null) {
      // return (data['lastUpdate'] as Timestamp).toDate();
      return Tools.formatDateTime((data['lastUpdate'] as Timestamp).toDate());
    }
    return "Nunca";
  }
}
