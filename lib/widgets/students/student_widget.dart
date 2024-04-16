import 'package:blueark_flutter/models/models.dart';
import 'package:blueark_flutter/widgets/layouts/scaffolds.dart';
import 'package:blueark_flutter/widgets/students/student_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class StudentWidget extends StatefulWidget {
  //const StudentWidget({Key? key}) : super(key: key);

  final int studentId;
  final String? imageUrl;

  const StudentWidget(this.studentId, this.imageUrl, {super.key});

  @override
  State<StudentWidget> createState() => _StudentWidgetState();
}

class _StudentWidgetState extends State<StudentWidget> {
  @override
  Widget build(BuildContext context) {
    //Student student = studentProvider(widget.studentId);

    return PageScaffold(
      child: NestedScrollView(
        controller: ScrollController(),
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              expandedHeight: 200,
              floating: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text('Character Name'),
                background: Image.network(
                  widget.imageUrl ?? 'https://via.placeholder.com/150',
                  fit: BoxFit.cover,
                ),
              ),
            )
          ];
        },
        body: Consumer(
          builder: (context, ref, child) {
            final studentAsyncValue =
                ref.watch(studentProvider(widget.studentId));

            return studentAsyncValue.when(
              data: (student) => StudentBody(student: student),
              loading: () =>
                  CircularProgressIndicator(), // Show a loading spinner while waiting for the data
              error: (error, stack) => Text(
                  'Error: $error'), // Show an error message if something goes wrong
            );
          },
        ),
      ),
    );
  }
}

class StudentBody extends StatelessWidget {
  final Student student;

  const StudentBody({
    super.key,
    required this.student,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 400,
        margin: EdgeInsets.only(top: 30, bottom: 50),
        decoration: BoxDecoration(
            color: Colors.lightBlue[50],
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                offset: Offset(0, 7),
                blurRadius: 10,
              )
            ]),
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25))),
            ),
            Positioned(
              top: 150,
              left: 20,
              child: Text(
                student.name,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Positioned(
              top: 180,
              left: 20,
              child: Text(
                student.school,
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal),
              ),
            ),
            Positioned(
                child: Image.network(
                    student.portrait_url ?? 'https://via.placeholder.com/150')),
          ],
        ));
  }
}
