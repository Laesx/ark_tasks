import 'package:ark_jots/modules/home/home_view.dart';
import 'package:ark_jots/modules/tasks/task_details.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  var routes = {
    '/': (context) => const HomeView(),
    '/home': (context) => const HomeView(),
    '/task': (context) => TaskDetailScreen(),
    '/schedule': (context) => const NotFoundView(canPop: true),
  };

  static const initialRoute = '/home';
  static const home = '/home';
  static const notFound = '/404';
  static String task() => '/task';
  static String schedule() => '/schedule';

// Hay que implementarlo esto es para cuando no encuentre la ruta
// en caso de que sean rutas dinámicas
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const HomeView());
  }
}

class NotFoundView extends StatelessWidget {
  const NotFoundView({required this.canPop});

  final bool canPop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: 'Not Found', canPop: canPop),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '404 Not Found',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton(
              child: const Text('Go Home'),
              onPressed: () => Navigator.pushNamed(context, AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }
}
