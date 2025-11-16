import 'package:flutter/material.dart';

/// Palette de couleurs premium pour BarApp
/// Inspirée d'un design moderne et élégant pour une application de gestion de bar
class AppColors {
  // === COULEURS PRIMAIRES ===

  /// Bleu profond premium - Couleur principale de l'app
  static const Color primary = Color(0xFF1E3A8A); // Bleu profond
  static const Color primaryLight = Color(0xFF3B82F6); // Bleu clair
  static const Color primaryDark = Color(0xFF1E40AF); // Bleu très foncé

  /// Accent doré premium - Pour les éléments importants
  static const Color accent = Color(0xFFF59E0B); // Doré/Ambre
  static const Color accentLight = Color(0xFFFBBF24);
  static const Color accentDark = Color(0xFFD97706);

  /// Couleur secondaire - Violet élégant
  static const Color secondary = Color(0xFF7C3AED); // Violet
  static const Color secondaryLight = Color(0xFF8B5CF6);
  static const Color secondaryDark = Color(0xFF6D28D9);

  // === COULEURS SÉMANTIQUES ===

  /// Succès (ventes, confirmations)
  static const Color success = Color(0xFF10B981); // Vert
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  /// Erreur (alertes, suppressions)
  static const Color error = Color(0xFFEF4444); // Rouge
  static const Color errorLight = Color(0xFFF87171);
  static const Color errorDark = Color(0xFFDC2626);

  /// Avertissement (stock bas, expirations)
  static const Color warning = Color(0xFFF59E0B); // Orange/Ambre
  static const Color warningLight = Color(0xFFFBBF24);
  static const Color warningDark = Color(0xFFD97706);

  /// Information (tips, aide)
  static const Color info = Color(0xFF3B82F6); // Bleu
  static const Color infoLight = Color(0xFF60A5FA);
  static const Color infoDark = Color(0xFF2563EB);

  // === NUANCES DE GRIS (LIGHT MODE) ===

  static const Color greyLight50 = Color(0xFFFAFAFA);
  static const Color greyLight100 = Color(0xFFF5F5F5);
  static const Color greyLight200 = Color(0xFFEEEEEE);
  static const Color greyLight300 = Color(0xFFE0E0E0);
  static const Color greyLight400 = Color(0xFFBDBDBD);
  static const Color greyLight500 = Color(0xFF9E9E9E);
  static const Color greyLight600 = Color(0xFF757575);
  static const Color greyLight700 = Color(0xFF616161);
  static const Color greyLight800 = Color(0xFF424242);
  static const Color greyLight900 = Color(0xFF212121);

  // === NUANCES DE GRIS FONCÉ (DARK MODE) ===

  static const Color greyDark50 = Color(0xFF1F2937);
  static const Color greyDark100 = Color(0xFF374151);
  static const Color greyDark200 = Color(0xFF4B5563);
  static const Color greyDark300 = Color(0xFF6B7280);
  static const Color greyDark400 = Color(0xFF9CA3AF);
  static const Color greyDark500 = Color(0xFFD1D5DB);
  static const Color greyDark600 = Color(0xFFE5E7EB);
  static const Color greyDark700 = Color(0xFFF3F4F6);
  static const Color greyDark800 = Color(0xFFF9FAFB);
  static const Color greyDark900 = Color(0xFFFFFFFF);

  // === BACKGROUNDS ===

  /// Light mode backgrounds
  static const Color backgroundLight = Color(0xFFFAFAFA);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color cardLight = Color(0xFFFFFFFF);

  /// Dark mode backgrounds
  static const Color backgroundDark = Color(0xFF0F172A); // Bleu très foncé
  static const Color surfaceDark = Color(0xFF1E293B);
  static const Color cardDark = Color(0xFF334155);

  // === TEXTE ===

  /// Light mode text
  static const Color textPrimaryLight = Color(0xFF1F2937);
  static const Color textSecondaryLight = Color(0xFF6B7280);
  static const Color textDisabledLight = Color(0xFF9CA3AF);

  /// Dark mode text
  static const Color textPrimaryDark = Color(0xFFF9FAFB);
  static const Color textSecondaryDark = Color(0xFFD1D5DB);
  static const Color textDisabledDark = Color(0xFF6B7280);

  /// Alias pour compatibilité (utilise light mode par défaut)
  static const Color textSecondary = textSecondaryLight;
  static const Color textDisabled = textDisabledLight;

  // === BORDURES ===

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // === DIVIDERS ===

  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  // === COULEURS MÉTIER SPÉCIFIQUES ===

  /// Boissons froides (réfrigérateur)
  static const Color coldDrink = Color(0xFF06B6D4); // Cyan
  static const Color coldDrinkLight = Color(0xFF22D3EE);

  /// Boissons chaudes / température ambiante
  static const Color warmDrink = Color(0xFFF59E0B); // Ambre

  /// Revenue / argent
  static const Color revenue = Color(0xFF10B981); // Vert

  /// Dépenses / coûts
  static const Color expense = Color(0xFFEF4444); // Rouge

  /// Stock disponible
  static const Color stockAvailable = Color(0xFF10B981); // Vert

  /// Stock bas
  static const Color stockLow = Color(0xFFF59E0B); // Orange

  /// Stock épuisé
  static const Color stockOut = Color(0xFFEF4444); // Rouge

  // === GRADIENTS ===

  /// Gradient primaire (bleu)
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradient accent (doré)
  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFFBBF24)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradient succès
  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Gradient sombre
  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // === OPACITÉS ===

  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityHigh = 0.87;

  // === SHADOWS ===

  /// Ombre légère
  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  /// Ombre moyenne
  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  /// Ombre large
  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// Ombre extra large
  static List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Colors.black.withOpacity(0.2),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  /// Ombre dark mode
  static List<BoxShadow> shadowDark = [
    BoxShadow(
      color: Colors.black.withOpacity(0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
