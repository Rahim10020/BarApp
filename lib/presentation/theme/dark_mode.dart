import 'package:flutter/material.dart';

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,

    primary: Color(0xFF0D1B2A), // Bleu nuit premium
    onPrimary: Colors.white,
    primaryContainer: Color(0xFF1B263B),

    secondary: Color(0xFF415A77), // Bleu/gris froid
    onSecondary: Colors.white,
    secondaryContainer: Color(0xFF0D1B2A),

    tertiary: Color(0xFFE0A85A), // Accent or / ambre
    onTertiary: Colors.black,

    surface: Color(0xFF0A0F14), // Dark background
    onSurface: Color(0xFFE9EAF2),

    error: Color(0xFFFF8A80),
    onError: Colors.black,

    inversePrimary: Color(0xFFE9EAF2),
  ),
);
