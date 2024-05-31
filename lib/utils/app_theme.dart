import 'package:ark_jots/utils/consts.dart';
import 'package:flutter/material.dart';

class ColorSeed {
  const ColorSeed(this.seed);

  final Color seed;

  ColorScheme scheme(Brightness brightness) =>
      ColorScheme.fromSeed(seedColor: seed, brightness: brightness);
}

const colorSeeds = {
  'Marino': ColorSeed(Color(0xFF45A0F2)),
  'Menta': ColorSeed(Color(0xFF2AB8B8)),
  'Abismo': ColorSeed(Color(0xFFB4ABF5)),
  'Caramelo': ColorSeed(Color(0xFFF78204)),
  'Bosque': ColorSeed(Color(0xFF00FFA9)),
  'Vino': ColorSeed(Color(0xFF894771)),
  'Mostaza': ColorSeed(Color(0xFFFFBF02)),
  'Lavanda': ColorSeed(Color.fromARGB(255, 64, 34, 108)),
};

ThemeData themeDataFrom(ColorScheme scheme) => ThemeData(
      useMaterial3: true,
      fontFamily: 'Rubik',
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      disabledColor: scheme.surface,
      unselectedWidgetColor: scheme.surface,
      splashColor: scheme.onBackground.withAlpha(20),
      highlightColor: Colors.transparent,
      checkboxTheme: CheckboxThemeData(
        shape:
            const RoundedRectangleBorder(borderRadius: Consts.borderRadiusMax),
        //fillColor: MaterialStateProperty.all(scheme.primary),
        checkColor: MaterialStateProperty.all(scheme.onPrimary),
        materialTapTargetSize: MaterialTapTargetSize.padded,
      ),
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: ZoomPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      cardTheme: const CardTheme(margin: EdgeInsets.all(0)),
      iconTheme: IconThemeData(
        color: scheme.onSurfaceVariant,
        size: Consts.iconBig,
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: scheme.surface.withAlpha(190),
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
          textStyle: const TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      chipTheme: ChipThemeData(
        labelStyle: TextStyle(
          color: scheme.onSecondaryContainer,
          fontWeight: FontWeight.normal,
        ),
      ),
      segmentedButtonTheme: const SegmentedButtonThemeData(
        style: ButtonStyle(tapTargetSize: MaterialTapTargetSize.shrinkWrap),
      ),
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 10),
      ),
      typography: Typography.material2014(),
      textTheme: TextTheme(
        titleLarge: TextStyle(
          fontSize: Consts.fontBig,
          color: scheme.onBackground,
          fontWeight: FontWeight.w500,
        ),
        titleMedium: TextStyle(
          fontSize: Consts.fontMedium,
          color: scheme.onBackground,
          fontWeight: FontWeight.w500,
        ),
        titleSmall: TextStyle(
          fontSize: Consts.fontMedium,
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontSize: Consts.fontMedium,
          color: scheme.primary,
          fontWeight: FontWeight.normal,
        ),
        bodyMedium: TextStyle(
          fontSize: Consts.fontMedium,
          color: scheme.onBackground,
          fontWeight: FontWeight.normal,
        ),
        labelMedium: TextStyle(
          fontSize: Consts.fontMedium,
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.normal,
        ),
        labelSmall: TextStyle(
          fontSize: Consts.fontSmall,
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.normal,
        ),
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: scheme.primary,
        selectionHandleColor: scheme.primary,
        selectionColor: scheme.primary.withAlpha(50),
      ),
      dividerTheme: const DividerThemeData(thickness: 1),
      dialogTheme: DialogTheme(
        backgroundColor: scheme.surface,
        titleTextStyle: TextStyle(
          fontSize: Consts.fontMedium,
          color: scheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        contentTextStyle: TextStyle(
          fontSize: Consts.fontMedium,
          color: scheme.onSurface,
          fontWeight: FontWeight.normal,
        ),
      ),
      tooltipTheme: TooltipThemeData(
        padding: Consts.padding,
        textStyle: TextStyle(color: scheme.onSurfaceVariant),
        decoration: BoxDecoration(
          color: scheme.surfaceVariant,
          borderRadius: Consts.borderRadiusMin,
          boxShadow: [BoxShadow(color: scheme.background, blurRadius: 10)],
        ),
      ),
      scrollbarTheme: ScrollbarThemeData(
        radius: Consts.radiusMin,
        thumbColor: MaterialStateProperty.all(scheme.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        isDense: true,
        hintStyle: TextStyle(
          fontSize: Consts.fontMedium,
          color: scheme.onSurfaceVariant,
          fontWeight: FontWeight.normal,
        ),
        border: const OutlineInputBorder(
          borderRadius: Consts.borderRadiusMax,
          borderSide: BorderSide.none,
        ),
      ),
    );
