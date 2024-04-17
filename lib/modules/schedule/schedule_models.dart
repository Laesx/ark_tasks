class Schedule {
  final String id;
  final String name;
  final String description;
  final String color;
  final String timeStart;
  final String location;
  final String timeEnd;
  final String category;
  final String status;

  Schedule({
    required this.id,
    required this.name,
    required this.description,
    required this.color,
    required this.timeStart,
    required this.location,
    required this.timeEnd,
    required this.category,
    required this.status,
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
      category: json['category'],
      status: json['status'],
    );
  }
}
