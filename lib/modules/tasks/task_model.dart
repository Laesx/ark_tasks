import 'dart:convert';

import 'package:ark_jots/models/priority.dart';
import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  DateTime createdAt;
  @HiveField(4)
  DateTime lastUpdated;
  @HiveField(5)
  bool isComplete = false;
  // Tags
  // Priority
  @HiveField(6)
  Priority priority;
  // Due Date
  @HiveField(7)
  DateTime? dueDate;
  // Start Date in case it's a project or event
  @HiveField(8)
  DateTime? startDate;
  // Reminder Dates
  @HiveField(12)
  DateTime? reminder;
  // Notes
  @HiveField(10)
  String? notes;
  @HiveField(11)
  List<Subtask> subtasks = [];
  // Field 9 was for the reminders list.

  Task({
    this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.lastUpdated,
    this.isComplete = false,
    this.priority = Priority.medium,
    this.dueDate,
    this.startDate,
    this.reminder,
    this.notes,
    //this.subtasks = const [],
  });

  factory Task.fromJson(String str) => Task.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Task.fromMap(Map<String, dynamic> json) => Task(
        id: json["id"],
        title: json["title"],
        description: json["data"],
        createdAt: DateTime.parse(json["created_at"]),
        lastUpdated: DateTime.parse(json["last_updated"]),
        isComplete: json["isComplete"],
        priority: priorityFromString(json["priority"]),
        dueDate: DateTime.parse(json["due_date"]),
        startDate: DateTime.parse(json["start_date"]),
        reminder: DateTime.parse(json["reminders"]),
        notes: json["notes"],
      );

  // This is never used in the app I think.
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "data": description,
        "created_at": createdAt.toIso8601String(),
        "last_updated": lastUpdated.toIso8601String(),
        "isComplete": isComplete,
        "priority": priority.toString(),
        "due_date": dueDate?.toIso8601String(),
        "start_date": startDate?.toIso8601String(),
        "reminders": reminder?.toIso8601String(),
        "notes": notes,
      };
}

@HiveType(typeId: 2)
class Subtask extends HiveObject {
  @HiveField(0)
  bool isComplete;
  @HiveField(1)
  String title;

  Subtask({
    this.isComplete = false,
    required this.title,
  });
}
