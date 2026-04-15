import 'package:flutter/material.dart';

class ThemeLight {
  static ColorScheme get colorScheme => ColorScheme.fromSeed(
    seedColor: const Color(0xFFD5461E),
    primary: const Color(0xFFD5461E),
    secondary: const Color(0xFF263238),
    brightness: Brightness.light,
  );


  static ThemeData get themeData => ThemeData(
    colorScheme: colorScheme,
    fontFamily: 'PlusJakartaSans',
    scaffoldBackgroundColor: const Color(0xFFFAFAFA),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFFAFAFA),
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      centerTitle: false,
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius:BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      isDense: true,
      fillColor: Colors.white,
      filled: true,

      hintStyle: TextStyle(
        color: Color(0xFFB3B3B3),
        fontSize: 14,
      ),
    ),

    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    ),

  );
}