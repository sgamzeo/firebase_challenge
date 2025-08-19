import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData themeFromColorScheme(ColorScheme scheme) {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();

    return ThemeData(
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.background,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.background,
        foregroundColor: scheme.primary,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: scheme.primary,
          foregroundColor: scheme.onPrimary,
        ),
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: scheme.onBackground,
        displayColor: scheme.onBackground,
      ),
    );
  }
}
