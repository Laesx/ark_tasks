import 'package:blueark_flutter/models/models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

final studentServiceProvider = Provider<StudentService>((ref) {
  return StudentService();
});

class StudentService with ChangeNotifier {
  List<Student> _students = [];

  List<Student> get students => _students;

  Student? selectedStudent;

  StudentService() {
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    final url =
        'http://10.0.2.2:5000/students'; // Replace with your API endpoint

    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);

      print(response.body);

      // Clear the existing characters list
      _students.clear();

      // Parse the JSON response and create Character objects
      final List<dynamic> studentMap = json.decode(response.body);

      studentMap.forEach((value) {
        final student = Student.fromMap(value);
        _students.add(student);
      });

      //print(value);
      //final student = Student.fromMap(studentMap);
      //_students.add(student);

      /*
      responseData.forEach((characterData) {
        final student = Student(
          id: characterData['Id'],
          name: characterData['Name'],
          school: characterData['School'],
          icon_url: characterData['icon_url'],
          portrait_url: characterData['portrait_url'],
          // Add more properties as needed
        );

        _students.add(student);
      });
      */

      notifyListeners();
    } catch (error) {
      // Handle error
      print('Error fetching students: $error');
    }
  }

  // Returns a list of all the students
  static Future<List<Student>> fetchStudents() async {
    final url = "http://10.0.2.2:5000/students";

    List<Student> students = [];

    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);

      print(response.body);

      //print(value);
      final List<dynamic> studentMap = json.decode(response.body);
      studentMap.forEach((value) {
        final student = Student.fromMap(value);
        students.add(student);
      });
      //notifyListeners();
      return students;
    } catch (error) {
      // Handle error
      print('Error fetching students: $error');
      rethrow;
    }
  }

  // Returns a single student by ID
  static Future<Student> fetchStudent(int id) async {
    final url = 'http://10.0.2.2:5000/students/$id';

    Student student;

    try {
      final response = await http.get(Uri.parse(url));
      final responseData = json.decode(response.body);

      print(response.body);

      //print(value);
      final Map<String, dynamic> studentMap = json.decode(response.body);
      student = Student.fromMap(studentMap);
      //notifyListeners();
      return student;
    } catch (error) {
      // Handle error
      print('Error fetching students: $error');
      rethrow;
    }
  }
}
