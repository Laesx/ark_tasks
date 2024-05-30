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

  /// Uploads all tasks to Firestore
  Future<void> uploadTasks(List<Task> tasks) async {
    final user = AuthService().user!;

    var ref = _db.collection('users').doc(user.uid).collection('tasks');
    // Delete all documents in the collection before uploading the new ones
    var snapshot = await ref.get();
    // Create a list of delete operations
    var deleteOperations =
        snapshot.docs.map((doc) => doc.reference.delete()).toList();
    // Wait for all delete operations to complete
    await Future.wait(deleteOperations);

    var batch = _db.batch();

    for (var task in tasks) {
      // Firestore generates a unique id for the document if one is not present
      var docRef;

      if (task.id == null) {
        docRef = ref.doc();
        // Update the task id with the Firestore id
        task.id = docRef.id;
        // print('Task ID: ${task.id}');
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
