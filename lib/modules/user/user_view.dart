import 'package:ark_jots/modules/auth/auth_service.dart';
import 'package:ark_jots/modules/auth/login_view.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/modules/user/user_header.dart';
import 'package:ark_jots/modules/user/user_models.dart';
import 'package:ark_jots/services/firestore_service.dart';
import 'package:ark_jots/widgets/layouts/constrained_view.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/widgets/shadowed_overflow_list.dart';
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
                _ButtonRow(),
                //SizedBox(height: 20),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const ListTile(
                            title: Text('Backup your Tasks!',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                          ),
                          Container(
                            height: 60,
                            margin: const EdgeInsets.symmetric(vertical: 10),
                            alignment: Alignment.center,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _Button(
                                  label: "Upload all Tasks",
                                  icon: Icons.upload,
                                  onTap: () => print('Log Out'),
                                ),
                                SizedBox(width: 10),
                                _Button(
                                  label: "Download all Tasks",
                                  icon: Icons.download,
                                  onTap: () => print('Log Out'),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    title: const Text('Upload all Tasks'),
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
              return const LoginView();
            }
          }),
    );
  }
}

class _ButtonRow extends StatelessWidget {
  const _ButtonRow();

  //final int id;

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _Button(
        label: 'Edit Profile',
        icon: Icons.edit,
        onTap: () => print('Edit Profile'),
      ),
      _Button(
        label: 'Settings',
        icon: Icons.settings,
        onTap: () => print('Settings'),
      ),
      _Button(
        label: 'Log Out',
        icon: Icons.logout,
        onTap: () => print('Log Out'),
      ),
    ];
    return SliverToBoxAdapter(
      child: ConstrainedView(
        child: Container(
          height: 60,
          margin: const EdgeInsets.symmetric(vertical: 10),
          alignment: Alignment.center,
          child: ShadowedOverflowList(
            itemCount: buttons.length,
            itemBuilder: (context, i) => buttons[i],
            shrinkWrap: true,
          ),
        ),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  const _Button({required this.label, required this.icon, required this.onTap});

  final String label;
  final IconData icon;
  final void Function() onTap;

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [Icon(icon), Text(label)],
      ),
    );
  }
}
