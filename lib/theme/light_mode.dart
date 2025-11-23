import 'package:flutter/material.dart';

/// Configuration du thème clair de l'application.
///
/// Définit les couleurs pour le mode clair avec une palette
/// de gris clairs et de blancs pour une interface lumineuse
/// et facile à lire en pleine lumière.
ThemeData lightMode = ThemeData(
  colorScheme: const ColorScheme.light(
    surface: Color(0xFFE8E8E8),
    primary: Color(0xFF9E9E9E),
    secondary: Color(0xFFFFFFFF),
    tertiary: Color(0xFFDBDBDB),
    // tertiary: Color(0xFF737373),
    inversePrimary: Color.fromARGB(255, 23, 23, 23),
  ),
);
