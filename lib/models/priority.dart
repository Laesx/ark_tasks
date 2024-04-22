import 'package:hive/hive.dart';

part 'priority.g.dart';

@HiveType(typeId: 0)
enum Priority {
  @HiveField(0)
  low,
  @HiveField(1)
  medium,
  @HiveField(2)
  high,
}

Priority priorityFromString(String str) {
  switch (str) {
    case 'low':
      return Priority.low;
    case 'medium':
      return Priority.medium;
    case 'high':
      return Priority.high;
    default:
      throw ArgumentError('Invalid priority: $str');
  }
}

/*
class Priority {
  final String name;
  final int value;

  const Priority(this.name, this.value);

  static const Priority low = Priority('Low', 0);
  static const Priority medium = Priority('Medium', 1);
  static const Priority high = Priority('High', 2);

  static List<Priority> get priorities => [low, medium, high];

  int get index => priorities.indexOf(this);

  static Priority fromValue(int value) {
    return priorities.firstWhere((element) => element.value == value);
  }

  static Priority fromJson(String str) {
    switch (str) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      default:
        throw ArgumentError('Invalid priority: $str');
    }
  }
}
*/
