import 'dart:convert';

class Student {
  int id;
  String name;
  String school;
  String icon_url;
  String portrait_url;

  Student({
    required this.id,
    required this.name,
    required this.school,
    required this.icon_url,
    required this.portrait_url,
  });

  factory Student.fromJson(String str) => Student.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Student.fromMap(Map<String, dynamic> json) => Student(
        id: json["Id"],
        name: json["Name"],
        school: json["School"],
        icon_url: json["icon_url"],
        portrait_url: json["portrait_url"],
      );

  Map<String, dynamic> toMap() => {
        "Id": id,
        "Name": name,
        "School": school,
        "icon_url": icon_url,
        "portrait_url": portrait_url,
      };
}
