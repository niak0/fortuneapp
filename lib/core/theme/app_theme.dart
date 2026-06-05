import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'mystic_dimens.dart';
import 'mystic_palette.dart';
import 'mystic_theme_id.dart';
import 'mystic_tokens.dart';

/// Mistik temanın `ThemeData` fabrikası. Bir [MysticPalette]'ten `ColorScheme`,
/// font sistemi ve tüm component theme'leri üretir; sabit renk içermez.
abstract final class MysticTheme {
  /// Tema kimliğinden hazır `ThemeData` döndürür.
  static ThemeData themeFor(MysticThemeId id) => _build(id.palette);

  /// Karakterli tipografi: Cinzel (başlık) · Cormorant Garamond (alt başlık) ·
  /// Jost (gövde). Tümü Türkçe gliflerini destekler.
  static TextTheme buildTextTheme(Color ink) {
    final body = GoogleFonts.jostTextTheme();
    final display = GoogleFonts.cinzelTextTheme();
    final serif = GoogleFonts.cormorantGaramondTextTheme();
    return body
        .copyWith(
          displayLarge: display.displayLarge,
          displayMedium: display.displayMedium,
          displaySmall: display.displaySmall,
          headlineLarge: display.headlineLarge?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.2,
          ),
          headlineMedium: display.headlineMedium?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
          headlineSmall: display.headlineSmall?.copyWith(
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
          ),
          titleLarge: serif.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          titleMedium: serif.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        )
        .apply(bodyColor: ink, displayColor: ink);
  }

  // Paletten tam ThemeData üretir.
  static ThemeData _build(MysticPalette p) {
    final scheme = _scheme(p);
    final textTheme = buildTextTheme(p.ink);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: p.bg,
      canvasColor: p.bg,
      textTheme: textTheme,
      extensions: [MysticTokens.fromPalette(p)],
      iconTheme: IconThemeData(color: p.inkSoft),

      appBarTheme: AppBarTheme(
        backgroundColor: p.bg,
        foregroundColor: p.ink,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.headlineSmall,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: p.bgElev,
        selectedItemColor: p.gold,
        unselectedItemColor: p.inkFaint,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: p.bgElev,
        indicatorColor: p.gold,
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(
            color: s.contains(WidgetState.selected) ? p.onAccent : p.inkFaint,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: p.gold,
          foregroundColor: p.onAccent,
          elevation: 0,
          textStyle: textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: MysticSpace.x4,
            vertical: MysticSpace.x3,
          ),
          shape: const StadiumBorder(),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: p.gold),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: p.gold,
          side: BorderSide(color: p.lineStrong),
          shape: const StadiumBorder(),
        ),
      ),

      cardTheme: CardThemeData(
        color: p.bgElev,
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: MysticRadius.mdAll,
          side: BorderSide(color: p.line),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: p.line,
        thickness: 1,
        space: MysticSpace.x5,
      ),

      dialogTheme: DialogThemeData(
        backgroundColor: p.bgElev2,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: MysticRadius.lgAll),
        titleTextStyle: textTheme.titleLarge,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: p.inkSoft),
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: p.gold,
        linearTrackColor: p.line,
        circularTrackColor: p.line,
      ),

      listTileTheme: ListTileThemeData(iconColor: p.gold, textColor: p.ink),

      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.gold : p.inkFaint,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? p.goldDeep : p.bgElev2,
        ),
        trackOutlineColor: WidgetStateProperty.all(p.line),
      ),

      segmentedButtonTheme: SegmentedButtonThemeData(
        style: ButtonStyle(
          foregroundColor: WidgetStateProperty.resolveWith(
            (s) => s.contains(WidgetState.selected) ? p.onAccent : p.inkSoft,
          ),
          backgroundColor: WidgetStateProperty.resolveWith(
            (s) =>
                s.contains(WidgetState.selected) ? p.gold : Colors.transparent,
          ),
          side: WidgetStateProperty.all(BorderSide(color: p.lineStrong)),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: p.bgElev,
        labelStyle: TextStyle(color: p.inkSoft),
        hintStyle: TextStyle(color: p.inkFaint),
        border: OutlineInputBorder(
          borderRadius: MysticRadius.smAll,
          borderSide: BorderSide(color: p.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: MysticRadius.smAll,
          borderSide: BorderSide(color: p.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: MysticRadius.smAll,
          borderSide: BorderSide(color: p.gold),
        ),
      ),

      snackBarTheme: SnackBarThemeData(
        backgroundColor: p.bgElev2,
        contentTextStyle: textTheme.bodyMedium?.copyWith(color: p.ink),
        actionTextColor: p.gold,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: MysticRadius.smAll),
      ),
    );
  }

  // Paletten dark ColorScheme türetir.
  static ColorScheme _scheme(MysticPalette p) {
    return ColorScheme(
      brightness: Brightness.dark,
      primary: p.gold,
      onPrimary: p.onAccent,
      primaryContainer: p.bgGlow,
      onPrimaryContainer: p.ink,
      secondary: p.flame,
      onSecondary: p.onAccent,
      secondaryContainer: p.bgElev2,
      onSecondaryContainer: p.inkSoft,
      tertiary: p.goldBright,
      onTertiary: p.onAccent,
      tertiaryContainer: p.bgGlow,
      onTertiaryContainer: p.ink,
      error: p.danger,
      onError: p.onAccent,
      // Sıcak uyarı kabı (kayıt teşvik afişi gibi) — alev tonunda.
      errorContainer: Color.alphaBlend(
        p.flame.withValues(alpha: 0.16),
        p.bgElev,
      ),
      onErrorContainer: p.ink,
      surface: p.bg,
      onSurface: p.ink,
      onSurfaceVariant: p.inkSoft,
      outline: p.lineStrong,
      outlineVariant: p.line,
      surfaceContainerLowest: p.bgDeep,
      surfaceContainerLow: p.bgElev,
      surfaceContainer: p.bgElev,
      surfaceContainerHigh: p.bgElev2,
      surfaceContainerHighest: p.bgElev2,
      inverseSurface: p.ink,
      onInverseSurface: p.bg,
      inversePrimary: p.goldDeep,
      scrim: const Color(0xFF000000),
      shadow: const Color(0xFF000000),
      surfaceTint: p.gold,
    );
  }
}
