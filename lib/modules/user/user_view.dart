import 'package:ark_jots/modules/auth/auth_service.dart';
import 'package:ark_jots/modules/auth/login_view.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/modules/user/user_header.dart';
import 'package:ark_jots/modules/user/user_models.dart';
import 'package:ark_jots/services/firestore_service.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This may cause problems since it "reads" maybe it should be "watch"
    final taskProvider = context.read<TaskProvider>();

    final user = User(
        id: 15,
        name: "John Doe",
        imageUrl:
            "https://s4.anilist.co/file/anilistcdn/user/avatar/large/b460805-oF5QFTje80wf.png",
        bannerUrl:
            "https://s4.anilist.co/file/anilistcdn/user/banner/b460805-nGwZ2Mq22yDi.jpg");
    return PageScaffold(
      child: StreamBuilder(
          stream: AuthService().userStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error'));
            } else if (snapshot.hasData) {
              return CustomScrollView(slivers: [
                UserHeader(id: user.id, user: user, imageUrl: user.imageUrl),
                SliverList(
                    delegate: SliverChildListDelegate([
                  ListTile(
                    title: Text('Upload all Tasks'),
                    onTap: () =>
                        FirestoreService().uploadTasks(taskProvider.tasks),
                  ),
                  ListTile(
                    title: const Text('Log Out'),
                    onTap: () => AuthService().signOut(),
                  )
                ]))
              ]);
            } else {
              return LoginView();
            }
          }),
    );
  }
}
