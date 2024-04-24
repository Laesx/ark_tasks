import 'package:ark_jots/services/ai_service.dart';
import 'package:ark_jots/utils/options.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
//import 'package:intl/date_symbol_data_file.dart';
import 'package:provider/provider.dart';
import 'modules/tasks/task_providers.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';

//void main() => runApp(MyApp());
Future<void> main() async {
  await Options.init();
  //await initializeDateFormatting();
  //await SharedPrefs().init();

  // Initializes the AI service
  await AiService.init();

  runApp(MultiProvider(providers: [
    //ChangeNotifierProvider(create: (context) => HomeProvider()),
    ChangeNotifierProvider(create: (context) => TaskProvider()),
    //ChangeNotifierProvider(create: (context) => ScheduleProvider()),
    //ChangeNotifierProvider(create: (context) => SettingsProvider()),
  ], child: const MyApp()));
}

//void main() {initializeDateFormatting().then((_) => runApp(MyApp()));}
class MyApp extends StatefulWidget {
  const MyApp();

  @override
  AppState createState() => AppState();
}

class AppState extends State<MyApp> {
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
    Options().dispose();
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
