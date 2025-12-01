import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: const ColorScheme(
    brightness: Brightness.light,

    primary: Color(0xFF0D1B2A), // Bleu nuit premium
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF1B263B),

    secondary: Color(0xFF415A77), // Bleu/gris froid
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFFE8ECF3),

    tertiary: Color(0xFFE0A85A), // Accent or
    onTertiary: Colors.black,

    surface: Color(0xFFF3F4F6), // Light background
    onSurface: Color(0xFF0D1B2A),

    error: Color(0xFFB00020),
    onError: Colors.white,

    inversePrimary: Color(0xFFE9EAF2),
  ),
);
