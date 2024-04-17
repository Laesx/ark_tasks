import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

//void main() => runApp(MyApp());
Future<void> main() async {
  runApp(const ProviderScope(child: MyApp()));
}

//void main() {initializeDateFormatting().then((_) => runApp(MyApp()));}
class MyApp extends ConsumerStatefulWidget {
  const MyApp();

  @override
  AppState createState() => AppState();
}

class AppState extends ConsumerState<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(
      initialLocation: AppRoutes.home,
      routes: buildRoutes(() => false),
      errorBuilder: (context, state) => const NotFoundView(canPop: false),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Preliminary theme data, possibly add several themes
    final data = themeDataFrom(ColorScheme.fromSeed(
        seedColor: Color(0xFFB4ABF5),
        brightness: Brightness.dark,
        background: Colors.black));

    return MaterialApp.router(
      title: 'Ark Jots',
      routerConfig: _router,
      //theme: AppTheme.darkTheme,
      theme: data,
      //darkTheme: AppTheme.darkTheme, // TODO: Implementar tema oscuro
      debugShowCheckedModeBanner: false,
    );
  }
}
