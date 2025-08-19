import 'package:flutter/material.dart';

class TermviewTheme {
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF1E1E1E),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        color: Color(0xFFC5C8C6),
        fontSize: 35,
        fontWeight: FontWeight.bold,
        fontFamily: "FiraCode",
      ),
      bodyMedium: TextStyle(
        color: Color(0xFFC5C8C6),
        fontSize: 18,
        fontWeight: FontWeight.w500,
        fontFamily: "FiraCode",
      ),
      bodySmall: TextStyle(
        color: Color(0xFFC5C8C6),
        fontFamily: "FiraCode",
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF3C3C3C),
        foregroundColor: const Color(0xFFC5C8C6),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        textStyle: const TextStyle(
          fontSize: 18,
          fontFamily: "FiraCode",
          fontWeight: FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2D2D2D),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
        borderSide: BorderSide.none,
      ),
      hintStyle: TextStyle(
        color: Color(0xFFC5C8C6),
        fontFamily: "FiraCode",
      ),
      labelStyle: TextStyle(
        color: Color(0xFFC5C8C6),
        fontFamily: "FiraCode",
      ),
    ),
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF569CD6),
      secondary: Color(0xFF00FF00),
    ),
  );
}
