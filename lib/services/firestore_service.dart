import 'dart:async';
import 'package:ark_jots/modules/auth/auth_service.dart';
import 'package:ark_jots/modules/tasks/task_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Reads all documments from the topics collection
  Future<List<Task>> getUserTasks() async {
    var ref = _db.collection('users').doc('admin').collection('tasks');
    var snapshot = await ref.get();
    var data = snapshot.docs.map((s) => s.data());
    var topics = data.map((d) => Task.fromJson(d));
    return topics.toList();
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
      // maybe use the task id as the document id
      var docRef = ref.doc(task.key);
      batch.set(docRef, task.toJson());
    }

    await batch.commit();
  }

  // Fetch the user id
  Future<String> getUserId() async {
    var user = AuthService().user;
    return user?.uid ?? '';
  }
}
