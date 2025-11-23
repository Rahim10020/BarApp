import 'package:flutter/material.dart';

/// Configuration du thème sombre de l'application.
///
/// Définit les couleurs pour le mode sombre avec une palette
/// de gris foncés et de couleurs neutres pour une meilleure
/// lisibilité en conditions de faible luminosité.
ThemeData darkMode = ThemeData(
  colorScheme: const ColorScheme.dark(
    surface: Color(0xFF323437),
    primary: Color(0xFF737373),
    secondary: Color(0xFF383838),
    tertiary: Color(0xFF4D4D4D),
    inversePrimary: Color(0xFFD1D0C5),
  ),
);
