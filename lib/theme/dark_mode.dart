import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF323437),
    primary: Color(0xFF737373),
    secondary: Color(0xFF383838),
    tertiary: Color(0xFF4D4D4D),
    inversePrimary: Color(0xFFD1D0C5),
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
      foregroundColor: const Color(0xFFD1D0C5), // inversePrimary
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    ),
  ),
  cardTheme: CardTheme(
    elevation: 4,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    color: const Color(0xFF383838), // secondary
  ),
);
