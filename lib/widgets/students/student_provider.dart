import 'dart:async';

import 'package:blueark_flutter/models/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:blueark_flutter/services/student_service.dart';

final studentProvider = FutureProvider.autoDispose.family<Student, int>(
  (ref, studentId) async {
    var data = await StudentService.fetchStudent(studentId);
    return data;
  },
);

final studentListProvider = FutureProvider.autoDispose<List<Student>>(
  (ref) async {
    var data = await StudentService.fetchStudents();
    return data;
  },
);
