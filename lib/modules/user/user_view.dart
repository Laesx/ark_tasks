import 'package:ark_jots/modules/auth/auth_service.dart';
import 'package:ark_jots/modules/auth/login_view.dart';
import 'package:ark_jots/modules/tasks/task_providers.dart';
import 'package:ark_jots/modules/user/user_header.dart';
import 'package:ark_jots/modules/user/user_models.dart';
import 'package:ark_jots/services/firestore_service.dart';
import 'package:ark_jots/utils/tools.dart';
import 'package:ark_jots/widgets/layouts/constrained_view.dart';
import 'package:ark_jots/widgets/layouts/scaffolds.dart';
import 'package:ark_jots/widgets/shadowed_overflow_list.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    // This may cause problems since it "reads" maybe it should be "watch"
    final taskProvider = context.read<TaskProvider>();

    final authUser = AuthService().user;

    // TODO: Delete this pictures and use placeholders
    final user = User(
        id: 15,
        name: authUser?.displayName ?? "John Doe",
        imageUrl: authUser?.photoURL ??
            "https://lh3.googleusercontent.com/pw/AP1GczNQUAmF5dezxpV3FPUvpNXIgW88Hnxegl7PnLYzB-WBSJHcoTvWlZp8tQ2Ps-7REo4_IJzB2oFu_nfJ2uCAAXr-2Qvxgj6_Uf1Dy0qzCyfoP5TVL5Y2cx5anHTRrEJsfKmNXIOXHU0WMVpPv5p6D2ba=w0?.png",
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
                _ButtonRow(taskProvider),
                //SizedBox(height: 20),
                SliverList(
                    delegate: SliverChildListDelegate([
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          const ListTile(
                            title: Text('¡Haz una Copia de Seguridad!',
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
                                  label: "Subir Tareas",
                                  icon: Icons.upload,
                                  onTap: () => FirestoreService()
                                      .uploadTasks(taskProvider.tasks),
                                ),
                                const SizedBox(width: 10),
                                _Button(
                                  label: "Descargar Tareas",
                                  icon: Icons.download,
                                  onTap: () {
                                    taskProvider.downloadTasks();
                                    if (taskProvider.tasks.isEmpty) {}
                                  },
                                ),
                              ],
                            ),
                          ),
                          ListTile(
                            title: FutureBuilder(
                              future: FirestoreService().getLastUpdate(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const Text("Cargando...");
                                } else if (snapshot.hasError) {
                                  return const Text('Error');
                                } else {
                                  return Text(
                                      "Última Copia de Seguridad: ${snapshot.data}");
                                }
                              },
                            ),
                          ),
                          ListTile(
                              title: Text(
                                  "Última Modificación Local: ${Tools.formatDateTime(taskProvider.lastUpdated)}")),
                        ],
                      ),
                    ),
                  ),
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
  const _ButtonRow(this.taskProvider);

  final taskProvider;

  //final int id;

  @override
  Widget build(BuildContext context) {
    final buttons = [
      _Button(
        label: 'Estadísticas',
        icon: Icons.bar_chart,
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text("Estadísticas"),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                          "Tareas Completadas: ${taskProvider.completedTasks.length}"),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                          "Tareas Pendientes: ${taskProvider.pendingTasks.length}"),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cerrar"),
                    ),
                  ],
                )),
      ),
      _Button(
        label: 'Cerrar Sesión',
        icon: Icons.logout,
        onTap: () => showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: const Text("Cerrar Sesión"),
                  content: const Text(
                      "¡CUIDADO! Si estás usando una cuenta de invitado perderás todos los datos en la nube. ¿Estás seguro de que quieres cerrar sesión?"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        AuthService().signOut();
                        Navigator.pop(context);
                      },
                      child: const Text("Cerrar Sesión"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text("Cancelar"),
                    ),
                  ],
                )),
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
