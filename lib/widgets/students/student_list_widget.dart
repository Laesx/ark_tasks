import 'package:ark_jots/app_routes/app_routes.dart';
import 'package:ark_jots/services/services.dart';
import 'package:ark_jots/widgets/students/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class StudentListWidget extends StatelessWidget {
  StudentListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    // Riverpod
    //final studentService = context.read(studentServiceProvider);
    //final studentService = useProvider(studentServiceProvider);
    return Consumer(
      builder: (context, ref, child) {
        final studentService = ref.watch(studentListProvider);

        return studentService.when(
          data: (students) => GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4, // Change this number as per your need
              childAspectRatio: 0.9, // Change this number as per your need
            ),
            itemCount: students.length,
            itemBuilder: (context, index) => GestureDetector(
              // TODO Fix this onTap
              onTap: () => context.push(AppRoutes.student(
                  students[index].id, students[index].icon_url)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    child: students[index].icon_url == null
                        // Leaving this here in case I implement something else.
                        ? Image(
                            image: AssetImage('assets/no-image.jpg'),
                            fit: BoxFit.cover,
                          )
                        : FadeInImage(
                            image: NetworkImage(students[index].icon_url),
                            placeholder: AssetImage('assets/jar-loading.gif'),
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
              ),
            ),
          ),
          loading: () => const LinearProgressIndicator(),
          error: (error, stack) => Text('Error: $error'),
        );
      },
      /*
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, // Change this number as per your need
          childAspectRatio: 0.9, // Change this number as per your need
        ),
        itemCount: studentService.students.length,
        itemBuilder: (context, index) => GestureDetector(
          onTap: () {
            studentService.selectedStudent = studentService.students[index];
            Navigator.pushNamed(context, "student");
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: studentService.students[index].icon_url == null
                    // Leaving this here in case I implement something else.
                    ? Image(
                        image: AssetImage('assets/no-image.jpg'),
                        fit: BoxFit.cover,
                      )
                    : FadeInImage(
                        image:
                            NetworkImage(studentService.students[index].icon_url),
                        placeholder: AssetImage('assets/jar-loading.gif'),
                        fit: BoxFit.cover,
                      ),
              ),
            ),
          ),
        ),
      ),
      */
    );
  }
}
