import 'package:ark_jots/models/priority.dart';
import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';

part 'task_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 1)
class Task extends HiveObject {
  @HiveField(0)
  String? id;
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

  void updateWith(Task other) {
    id = other.id;
    title = other.title;
    description = other.description;
    createdAt = other.createdAt;
    lastUpdated = other.lastUpdated;
    isComplete = other.isComplete;
    priority = other.priority;
    dueDate = other.dueDate;
    startDate = other.startDate;
    reminder = other.reminder;
    notes = other.notes;
    subtasks = List<Subtask>.from(other.subtasks);
  }

  factory Task.fromJson(Map<String, dynamic> json) => _$TaskFromJson(json);
  Map<String, dynamic> toJson() => _$TaskToJson(this);
}

@JsonSerializable()
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

  factory Subtask.fromJson(Map<String, dynamic> json) =>
      _$SubtaskFromJson(json);
  Map<String, dynamic> toJson() => _$SubtaskToJson(this);
}
