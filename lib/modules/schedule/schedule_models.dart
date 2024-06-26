import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'schedule_models.g.dart';

@HiveType(typeId: 3)
class Schedule extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? color;
  @HiveField(4)
  String timeStart;
  @HiveField(5)
  String? location;
  @HiveField(6)
  String timeEnd;
  @HiveField(7)
  String? instructor;
  @HiveField(8)
  String weekday;

  TimeOfDay get startTime {
    final time = timeStart.split(':');
    return TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  }

  TimeOfDay get endTime {
    final time = timeEnd.split(':');
    return TimeOfDay(hour: int.parse(time[0]), minute: int.parse(time[1]));
  }

  Color get colorValue {
    return Color(int.parse(color ?? '4280391411'));
  }

  Schedule({
    this.id,
    required this.name,
    this.description,
    this.color,
    required this.timeStart,
    this.location,
    required this.timeEnd,
    this.instructor,
    required this.weekday,
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
      weekday: json['weekday'],
    );
  }
}
