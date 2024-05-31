import 'package:ark_jots/modules/home/home_provider.dart';
import 'package:ark_jots/modules/schedule/schedule_providers.dart';
import 'package:ark_jots/services/ai_service.dart';
import 'package:ark_jots/services/local_notification_service.dart';
import 'package:ark_jots/utils/options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';
import 'modules/tasks/task_providers.dart';
import 'utils/app_routes.dart';
import 'utils/app_theme.dart';
import 'package:dynamic_color/dynamic_color.dart';

//void main() => runApp(MyApp());
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initializes the locale in Spanish (hardcoded for now)
  await initializeDateFormatting("es_ES", null);
  await LocalNotificationService().init();
  await Options.init();
  //await SharedPrefs().init();

  await Firebase.initializeApp();

  // Initializes the AI service
  await AiService.init();

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => HomeProvider()),
    ChangeNotifierProvider(create: (context) => TaskProvider()),
    ChangeNotifierProvider(create: (context) => ScheduleProvider()),
    ChangeNotifierProvider(create: (context) => AiService()),
    ChangeNotifierProvider(create: (context) => Options()),
  ], child: const MyApp()));
}

//void main() {initializeDateFormatting().then((_) => runApp(MyApp()));}
class MyApp extends StatefulWidget {
  const MyApp();

  @override
  AppState createState() => AppState();
}

class AppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();

    Options().addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    Options().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        ColorScheme lightScheme;
        ColorScheme darkScheme;
        var theme = Options().theme;

        // The system schemes must be cached, so
        // they can later be used in the settings.
        final notifier = context.watch<HomeProvider>();
        final hasDynamic = lightDynamic != null && darkDynamic != null;

        Color? lightBackground;
        Color? darkBackground;
        if (Options().pureWhiteOrBlackTheme) {
          lightBackground = Colors.white;
          darkBackground = Colors.black;
        }

        if (hasDynamic) {
          lightDynamic = lightDynamic.harmonized().copyWith(
                background: lightBackground,
              );
          darkDynamic = darkDynamic.harmonized().copyWith(
                background: darkBackground,
              );

          Future(
            () => notifier.cacheSystemColorSchemes(lightDynamic, darkDynamic),
          );
        }

        if (theme == null && hasDynamic) {
          lightScheme = lightDynamic!;
          darkScheme = darkDynamic!;
        } else {
          theme ??= 0;
          if (theme >= colorSeeds.length) {
            theme = colorSeeds.length - 1;
          }

          final seed = colorSeeds.values.elementAt(theme);
          lightScheme = seed.scheme(Brightness.light).copyWith(
                background: lightBackground,
              );
          darkScheme = seed.scheme(Brightness.dark).copyWith(
                background: darkBackground,
              );
        }

        final mode = Options().themeMode;
        final platformBrightness =
            View.of(context).platformDispatcher.platformBrightness;

        final isDark = mode == ThemeMode.system
            ? platformBrightness == Brightness.dark
            : mode == ThemeMode.dark;

        final ColorScheme scheme;
        final Brightness overlayBrightness;
        if (isDark) {
          scheme = darkScheme;
          overlayBrightness = Brightness.light;
        } else {
          scheme = lightScheme;
          overlayBrightness = Brightness.dark;
        }

        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarBrightness: scheme.brightness,
          statusBarIconBrightness: overlayBrightness,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarContrastEnforced: false,
          systemNavigationBarIconBrightness: overlayBrightness,
        ));
        final data = themeDataFrom(scheme);

        return MaterialApp(
          routes: AppRoutes().routes,
          title: 'Ark Jots',
          theme: data,
          darkTheme: data,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}
