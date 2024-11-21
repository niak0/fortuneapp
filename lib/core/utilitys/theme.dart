import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;
  const MaterialTheme(this.textTheme);

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      //ana renkler
      primary: Color(0xff804A32),
      onPrimary: Color(0xff322727),

      surfaceTint: Color(0xff97d945),
      primaryContainer: Color(0xff4f8200),
      onPrimaryContainer: Color(0xffffffff),

      secondary: Color(0xff322727),
      onSecondary: Color(0xff4A3B3B),

      secondaryContainer: Color(0xff322727),
      onSecondaryContainer: Color(0xffc4b1b1),

      tertiary: Color(0xff5ddcb0),
      onTertiary: Color(0xff003828),
      tertiaryContainer: Color(0xff008564),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xffffb4ab),
      onError: Color(0xff690005),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff0D0D0D), // arkaplan rengi
      onSurface: Color(0xffF5F5F5), // yazı rengi
      onSurfaceVariant: Color(0xffD1D1D1), // uzun metin rengi
      outline: Color(0xff8c947e),
      outlineVariant: Color(0xff424937),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe0e4d4),
      inversePrimary: Color(0xff3f6900),
      primaryFixed: Color(0xffb2f65f),
      onPrimaryFixed: Color(0xff102000),
      primaryFixedDim: Color(0xff97d945),
      onPrimaryFixedVariant: Color(0xff2f4f00),
      secondaryFixed: Color(0xfff2dedd),
      onSecondaryFixed: Color(0xff231919),
      secondaryFixedDim: Color(0xffd5c2c2),
      onSecondaryFixedVariant: Color(0xff514444),
      tertiaryFixed: Color(0xff7cf9cb),
      onTertiaryFixed: Color(0xff002116),
      tertiaryFixedDim: Color(0xff5ddcb0),
      onTertiaryFixedVariant: Color(0xff00513c),
      surfaceDim: Color(0xff11150b),
      surfaceBright: Color(0xff363b2f),
      surfaceContainerLowest: Color(0xff0b0f07),
      surfaceContainerLow: Color(0xff191d13),
      surfaceContainer: Color(0xff1d2117),
      surfaceContainerHigh: Color(0xff272b21),
      surfaceContainerHighest: Color(0xff32362b),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.surface,
        canvasColor: colorScheme.surface,
        appBarTheme: AppBarTheme(backgroundColor: Color(0xFF0D0D0D)),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: colorScheme.primary,
          unselectedItemColor: Color(0xff4A3B3B),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: colorScheme.onSurface,
            backgroundColor: Color(0xFF4A3B3B),
          ),
        ),
        iconTheme: IconThemeData(color: Color(0xFF2E4A3D)),
      );
}
