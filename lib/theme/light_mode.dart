import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFE8E8E8),
    primary: Color(0xFF5D4037),
    secondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFFDBDBDB),
    inversePrimary: Color.fromARGB(255, 23, 23, 23),
    primaryContainer: Color(0xFF5D4037), // Remplace Colors.brown[600]
  ),
  textTheme: const TextTheme(
    bodyMedium: TextStyle(fontFamily: 'Roboto'),
    titleLarge: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
    titleMedium: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.w600),
    bodySmall: TextStyle(fontFamily: 'Roboto'),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF5D4037), // primaryContainer
      foregroundColor: const Color.fromARGB(255, 23, 23, 23), // inversePrimary
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: const Color(0xFFFFFFFF), // secondary
  ),
);
