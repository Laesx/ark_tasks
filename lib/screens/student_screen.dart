import 'package:blueark_flutter/services/services.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StudentScreen extends StatelessWidget {
  const StudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentService = Provider.of<StudentService>(context);

    //return ChangeNotifierProvider(create: ( _ ) => studentService.selectedStudent, child: StudentScreen());
    return _StudentScreenBody();
  }
}

class _StudentScreenBody extends StatelessWidget {
  const _StudentScreenBody({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final studentService = Provider.of<StudentService>(context);

    return Scaffold(
      body: ListView.builder(
        itemCount: studentService.students.length,
        itemBuilder: (context, index) {
          final student = studentService.students[index];
          return ListTile(
            title: Text(student.name),
            subtitle: Text(student.school.toString()),
          );
        },
      ),
    );
  }
}
