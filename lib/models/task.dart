import 'dart:convert';

import 'package:ark_jots/models/priority.dart';

class Task {
  int id;
  String title;
  String? description;
  DateTime createdAt;
  DateTime lastUpdated;
  bool isComplete = false;
  // Tags
  // Priority
  Priority? priority;
  // Due Date
  DateTime? dueDate;
  // Start Date in case it's a project or event
  DateTime? startDate;
  // Reminder Dates
  List<DateTime>? reminders;
  // Notes
  String? notes;

  Task({
    required this.id,
    required this.title,
    this.description,
    required this.createdAt,
    required this.lastUpdated,
    this.isComplete = false,
    this.priority,
    this.dueDate,
    this.startDate,
    this.reminders,
    this.notes,
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
        priority: Priority.fromValue(json["priority"]),
        dueDate: DateTime.parse(json["due_date"]),
        startDate: DateTime.parse(json["start_date"]),
        reminders: List<DateTime>.from(
            json["reminders"].map((x) => DateTime.parse(x))),
        notes: json["notes"],
      );

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
        "reminders": List<dynamic>.from(
            reminders?.map((x) => x.toIso8601String()) ??
                []), // This is a null check operator
        "notes": notes,
      };
}
