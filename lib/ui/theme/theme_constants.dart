import 'package:flutter/material.dart';

/// Constantes de design pour l'application
/// Garantit la cohérence visuelle à travers toute l'app
class ThemeConstants {
  // === SPACING ===

  /// Spacing extra small - 4px
  static const double spacingXs = 4.0;

  /// Spacing small - 8px
  static const double spacingSm = 8.0;

  /// Spacing medium - 16px (valeur par défaut)
  static const double spacingMd = 16.0;

  /// Spacing large - 24px
  static const double spacingLg = 24.0;

  /// Spacing extra large - 32px
  static const double spacingXl = 32.0;

  /// Spacing 2xl - 48px
  static const double spacing2Xl = 48.0;

  /// Spacing 3xl - 64px
  static const double spacing3Xl = 64.0;

  // === BORDER RADIUS ===

  /// Border radius small - 4px
  static const double radiusSm = 4.0;

  /// Border radius medium - 8px
  static const double radiusMd = 8.0;

  /// Border radius large - 12px (valeur par défaut pour cards)
  static const double radiusLg = 12.0;

  /// Border radius extra large - 16px
  static const double radiusXl = 16.0;

  /// Border radius 2xl - 24px
  static const double radius2Xl = 24.0;

  /// Border radius 3xl - 32px (pour modals)
  static const double radius3Xl = 32.0;

  /// Border radius full - 999px (cercle)
  static const double radiusFull = 999.0;

  // === BORDER WIDTH ===

  static const double borderWidthThin = 1.0;
  static const double borderWidthMedium = 2.0;
  static const double borderWidthThick = 3.0;

  // === ICON SIZES ===

  static const double iconSizeXs = 16.0;
  static const double iconSizeSm = 20.0;
  static const double iconSizeMd = 24.0;
  static const double iconSizeLg = 32.0;
  static const double iconSizeXl = 48.0;
  static const double iconSize2Xl = 64.0;
  static const double iconSize3Xl = 80.0;

  // === BUTTON HEIGHTS ===

  static const double buttonHeightSm = 36.0;
  static const double buttonHeightMd = 48.0;
  static const double buttonHeightLg = 56.0;

  // === APPBAR ===

  static const double appBarHeight = 56.0;
  static const double appBarElevation = 0.0; // Flat design

  // === BOTTOM NAV BAR ===

  static const double bottomNavBarHeight = 64.0;
  static const double bottomNavBarElevation = 8.0;

  // === CARD ===

  static const double cardElevation = 0.0; // Utilise shadows au lieu d'elevation
  static const EdgeInsets cardPadding = EdgeInsets.all(spacingMd);
  static const BorderRadius cardBorderRadius =
      BorderRadius.all(Radius.circular(radiusLg));

  // === INPUT FIELDS ===

  static const double inputHeight = 56.0;
  static const double inputBorderWidth = 1.5;
  static const BorderRadius inputBorderRadius =
      BorderRadius.all(Radius.circular(radiusMd));
  static const EdgeInsets inputPadding = EdgeInsets.symmetric(
    horizontal: spacingMd,
    vertical: spacingSm,
  );

  // === DIALOGS ===

  static const double dialogMaxWidth = 400.0;
  static const double dialogBorderRadius = radius3Xl;
  static const EdgeInsets dialogPadding = EdgeInsets.all(spacingLg);

  // === BOTTOM SHEETS ===

  static const double bottomSheetBorderRadius = radius3Xl;
  static const EdgeInsets bottomSheetPadding = EdgeInsets.all(spacingLg);

  // === DIVIDER ===

  static const double dividerThickness = 1.0;
  static const double dividerIndent = 0.0;

  // === ANIMATIONS ===

  /// Animation rapide - 150ms (alias pour compatibilité)
  static const Duration animationFast = Duration(milliseconds: 150);

  /// Animation normale - 200ms (alias pour compatibilité)
  static const Duration animationNormal = Duration(milliseconds: 200);

  /// Duration ultra rapide - 100ms
  static const Duration durationFast = Duration(milliseconds: 100);

  /// Duration rapide - 200ms
  static const Duration durationNormal = Duration(milliseconds: 200);

  /// Duration moyenne - 300ms (valeur par défaut)
  static const Duration durationMedium = Duration(milliseconds: 300);

  /// Duration lente - 500ms
  static const Duration durationSlow = Duration(milliseconds: 500);

  /// Curve par défaut - ease in out
  static const Curve curveDefault = Curves.easeInOut;

  /// Curve pour apparitions
  static const Curve curveEaseOut = Curves.easeOut;

  /// Curve pour disparitions
  static const Curve curveEaseIn = Curves.easeIn;

  /// Curve élastique
  static const Curve curveElastic = Curves.elasticOut;

  /// Curve rebond
  static const Curve curveBounce = Curves.bounceOut;

  // === BREAKPOINTS (responsive) ===

  static const double breakpointMobile = 600.0;
  static const double breakpointTablet = 900.0;
  static const double breakpointDesktop = 1200.0;

  // === MAX WIDTHS ===

  static const double maxWidthContent = 1200.0;
  static const double maxWidthForm = 600.0;

  // === Z-INDEX / ELEVATION ===

  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationHighest = 16.0;

  // === ASPECT RATIOS ===

  static const double aspectRatioSquare = 1.0;
  static const double aspectRatioCard = 16 / 9;
  static const double aspectRatioPortrait = 3 / 4;

  // === GRID ===

  static const int gridColumnsPhone = 2;
  static const int gridColumnsTablet = 3;
  static const int gridColumnsDesktop = 4;

  // === OPACITY ===

  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityHigh = 0.87;

  // === HELPER METHODS ===

  /// Retourne le spacing selon une valeur multiplier
  static double spacing(double multiplier) => spacingMd * multiplier;

  /// Retourne le radius selon une valeur multiplier
  static double radius(double multiplier) => radiusMd * multiplier;

  /// Padding symétrique horizontal
  static EdgeInsets paddingH(double value) => EdgeInsets.symmetric(horizontal: value);

  /// Padding symétrique vertical
  static EdgeInsets paddingV(double value) => EdgeInsets.symmetric(vertical: value);

  /// Padding uniforme
  static EdgeInsets paddingAll(double value) => EdgeInsets.all(value);

  /// Padding horizontal standard
  static const EdgeInsets paddingHorizontal = EdgeInsets.symmetric(horizontal: spacingMd);

  /// Padding vertical standard
  static const EdgeInsets paddingVertical = EdgeInsets.symmetric(vertical: spacingMd);

  /// Padding de page (écrans)
  static const EdgeInsets pagePadding = EdgeInsets.all(spacingMd);

  /// Padding de section
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: spacingMd,
    vertical: spacingLg,
  );
}
