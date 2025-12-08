import 'package:flutter/material.dart';

/// Palette de couleurs pour BarApp
///
/// IMPORTANT: Ces couleurs sont synchronisées avec les fichiers dark_mode.dart et light_mode.dart
/// situés dans /lib/theme/. Toute modification doit être faite dans ces fichiers source.
class AppColors {
  // === COULEURS PRIMAIRES (depuis dark_mode.dart et light_mode.dart) ===

  /// Bleu nuit premium - Couleur principale de l'app
  static const Color primary = Color(0xFF0D1B2A);
  static const Color primaryLight = Color(0xFF1B263B);
  static const Color primaryDark = Color(0xFF0D1B2A);

  /// Accent or/ambre - Pour les éléments importants
  static const Color accent = Color(0xFFE0A85A);
  static const Color accentLight = Color(0xFFE0A85A);
  static const Color accentDark = Color(0xFFE0A85A);

  /// Couleur secondaire - Bleu/gris froid
  static const Color secondary = Color(0xFF415A77);
  static const Color secondaryLight = Color(0xFF415A77);
  static const Color secondaryDark = Color(0xFF415A77);

  // === COULEURS SÉMANTIQUES ===

  /// Succès (ventes, confirmations)
  static const Color success = Color(0xFF10B981);
  static const Color successLight = Color(0xFF34D399);
  static const Color successDark = Color(0xFF059669);

  /// Erreur (alertes, suppressions)
  static const Color error = Color(0xFFFF8A80); // Dark mode
  static const Color errorLight = Color(0xFFB00020); // Light mode
  static const Color errorDark = Color(0xFFFF8A80);

  /// Avertissement (stock bas, expirations)
  static const Color warning = Color(0xFFE0A85A);
  static const Color warningLight = Color(0xFFE0A85A);
  static const Color warningDark = Color(0xFFE0A85A);

  /// Information
  static const Color info = Color(0xFF415A77);
  static const Color infoLight = Color(0xFF415A77);
  static const Color infoDark = Color(0xFF415A77);

  // === BACKGROUNDS (depuis dark_mode.dart et light_mode.dart) ===

  /// Light mode backgrounds
  static const Color backgroundLight = Color(0xFFF3F4F6);
  static const Color surfaceLight = Color(0xFFF3F4F6);
  static const Color cardLight = Color(0xFFF3F4F6);

  /// Dark mode backgrounds
  static const Color backgroundDark = Color(0xFF0A0F14);
  static const Color surfaceDark = Color(0xFF0A0F14);
  static const Color cardDark = Color(0xFF0A0F14);

  // === TEXTE (depuis dark_mode.dart et light_mode.dart) ===

  /// Light mode text
  static const Color textPrimaryLight = Color(0xFF0D1B2A);
  static const Color textSecondaryLight = Color(0xFF415A77);
  static const Color textDisabledLight = Color(0xFF9CA3AF);

  /// Dark mode text
  static const Color textPrimaryDark = Color(0xFFE9EAF2);
  static const Color textSecondaryDark = Color(0xFFE9EAF2);
  static const Color textDisabledDark = Color(0xFF6B7280);

  /// Alias pour compatibilité
  static const Color textSecondary = textSecondaryLight;
  static const Color textDisabled = textDisabledLight;

  // === BORDURES ===

  static const Color borderLight = Color(0xFFE5E7EB);
  static const Color borderDark = Color(0xFF374151);

  // === DIVIDERS ===

  static const Color dividerLight = Color(0xFFE5E7EB);
  static const Color dividerDark = Color(0xFF374151);

  // === NUANCES DE GRIS (conservées pour compatibilité) ===

  static const Color greyLight50 = Color(0xFFF3F4F6);
  static const Color greyLight100 = Color(0xFFF3F4F6);
  static const Color greyLight200 = Color(0xFFE8ECF3);
  static const Color greyLight300 = Color(0xFFE0E0E0);
  static const Color greyLight400 = Color(0xFFBDBDBD);
  static const Color greyLight500 = Color(0xFF9E9E9E);
  static const Color greyLight600 = Color(0xFF757575);
  static const Color greyLight700 = Color(0xFF616161);
  static const Color greyLight800 = Color(0xFF424242);
  static const Color greyLight900 = Color(0xFF212121);

  static const Color greyDark50 = Color(0xFF1B263B);
  static const Color greyDark100 = Color(0xFF1B263B);
  static const Color greyDark200 = Color(0xFF4B5563);
  static const Color greyDark300 = Color(0xFF6B7280);
  static const Color greyDark400 = Color(0xFF9CA3AF);
  static const Color greyDark500 = Color(0xFFD1D5DB);
  static const Color greyDark600 = Color(0xFFE5E7EB);
  static const Color greyDark700 = Color(0xFFF3F4F6);
  static const Color greyDark800 = Color(0xFFF9FAFB);
  static const Color greyDark900 = Color(0xFFE9EAF2);

  // === COULEURS MÉTIER SPÉCIFIQUES (conservées) ===

  /// Boissons froides
  static const Color coldDrink = Color(0xFF06B6D4);
  static const Color coldDrinkLight = Color(0xFF22D3EE);

  /// Boissons chaudes
  static const Color warmDrink = Color(0xFFE0A85A);

  /// Revenue
  static const Color revenue = Color(0xFF10B981);

  /// Dépenses
  static const Color expense = Color(0xFFFF8A80);

  /// Stock disponible
  static const Color stockAvailable = Color(0xFF10B981);

  /// Stock bas
  static const Color stockLow = Color(0xFFE0A85A);

  /// Stock épuisé
  static const Color stockOut = Color(0xFFFF8A80);

  // === GRADIENTS (conservés) ===

  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF0D1B2A), Color(0xFF1B263B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFE0A85A), Color(0xFFE0A85A)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient successGradient = LinearGradient(
    colors: [Color(0xFF10B981), Color(0xFF34D399)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient darkGradient = LinearGradient(
    colors: [Color(0xFF0A0F14), Color(0xFF1B263B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  // === OPACITÉS ===

  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityHigh = 0.87;

  // === SHADOWS ===

  static List<BoxShadow> shadowSm = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.05),
      blurRadius: 4,
      offset: const Offset(0, 1),
    ),
  ];

  static List<BoxShadow> shadowMd = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.1),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> shadowLg = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.15),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> shadowXl = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.2),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> shadowDark = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];
}
