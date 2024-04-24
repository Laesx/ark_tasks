import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

//part 'schedule_models.g.dart';

@HiveType(typeId: 3)
class Schedule extends HiveObject {
  @HiveField(0)
  final String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String description;
  @HiveField(3)
  String color;
  @HiveField(4)
  String timeStart;
  @HiveField(5)
  String location;
  @HiveField(6)
  String timeEnd;
  @HiveField(7)
  String instructor;

  TimeOfDay get startTime {
    final time = timeStart.split(':');
    return TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  }

  Schedule({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.timeStart,
    required this.location,
    required this.timeEnd,
    required this.instructor,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      id: json['id'],
      name: json['title'],
      description: json['description'],
      color: json['date'],
      timeStart: json['time'],
      location: json['location'],
      timeEnd: json['image'],
      instructor: json['instructor'],
    );
  }
}
