import 'dart:async';

import 'package:ark_jots/modules/home/home_view.dart';
import 'package:ark_jots/screens/home_screen.dart';
import 'package:ark_jots/widgets/layouts/top_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

List<GoRoute> buildRoutes(bool Function() shoudConfirmExit) {
  /*
  final FutureOr<bool> Function(BuildContext) onExit = (BuildContext context) {
    if (!shoudConfirmExit()) return true;
    return showPopUp<bool>(
      context,
      ConfirmationDialog(
        title: 'Exit?',
        mainAction: 'Yes',
        secondaryAction: 'No',
        onConfirm: () => Navigator.of(context).pop(true),
      ),
    ).then((value) => value ?? false);
  };*/

  return [
    GoRoute(path: '/', redirect: (context, state) => '/home'),
    GoRoute(
      path: '/home',
      //onExit: onExit,
      builder: (context, state) {
        return const HomeView();
      },
    ),
  ];
}

class AppRoutes {
  static const initialRoute = '/home';

  static const home = '/home';

  static const notFound = '/404';

  static String student(int id, [String? image]) =>
      '/student/$id${image != null ? "?image=$image" : ""}';

  static String task(int id) => '/task/$id';

// Hay que implementarlo esto es para cuando no encuentre la ruta
// en caso de que sean rutas dinámicas
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) => const HomeScreen());
  }
}

String? _parseIdOr404(BuildContext _, GoRouterState state) =>
    int.tryParse(state.pathParameters['id'] ?? '') == null ? '404' : null;

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
              onPressed: () => context.go(AppRoutes.home),
            ),
          ],
        ),
      ),
    );
  }
}
