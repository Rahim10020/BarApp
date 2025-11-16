import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Typographie cohérente pour toute l'application
/// Basée sur Material Design 3 avec Google Fonts (Montserrat + Inter)
class AppTypography {
  // === FONT FAMILIES ===

  /// Font principale - Montserrat (headings et UI)
  static const String fontFamilyPrimary = 'Montserrat';

  /// Font secondaire - Inter (body text)
  static const String fontFamilySecondary = 'Inter';

  // === TEXT THEME LIGHT ===

  static TextTheme textThemeLight = TextTheme(
    // Display - Très grands titres (rarement utilisés)
    displayLarge: GoogleFonts.montserrat(
      fontSize: 57,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.25,
      color: AppColors.textPrimaryLight,
      height: 1.12,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontSize: 45,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      color: AppColors.textPrimaryLight,
      height: 1.16,
    ),
    displaySmall: GoogleFonts.montserrat(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      color: AppColors.textPrimaryLight,
      height: 1.22,
    ),

    // Headline - Titres de sections
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      color: AppColors.textPrimaryLight,
      height: 1.25,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      color: AppColors.textPrimaryLight,
      height: 1.29,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: AppColors.textPrimaryLight,
      height: 1.33,
    ),

    // Title - Titres de cards, dialogs
    titleLarge: GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: AppColors.textPrimaryLight,
      height: 1.27,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: AppColors.textPrimaryLight,
      height: 1.5,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: AppColors.textPrimaryLight,
      height: 1.43,
    ),

    // Body - Texte principal (Inter pour meilleure lisibilité)
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
      color: AppColors.textPrimaryLight,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
      color: AppColors.textPrimaryLight,
      height: 1.43,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.4,
      color: AppColors.textSecondaryLight,
      height: 1.33,
    ),

    // Label - Buttons, tabs, chips
    labelLarge: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: AppColors.textPrimaryLight,
      height: 1.43,
    ),
    labelMedium: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: AppColors.textPrimaryLight,
      height: 1.33,
    ),
    labelSmall: GoogleFonts.montserrat(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.textSecondaryLight,
      height: 1.45,
    ),
  );

  // === TEXT THEME DARK ===

  static TextTheme textThemeDark = TextTheme(
    // Display
    displayLarge: GoogleFonts.montserrat(
      fontSize: 57,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.25,
      color: AppColors.textPrimaryDark,
      height: 1.12,
    ),
    displayMedium: GoogleFonts.montserrat(
      fontSize: 45,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      color: AppColors.textPrimaryDark,
      height: 1.16,
    ),
    displaySmall: GoogleFonts.montserrat(
      fontSize: 36,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      color: AppColors.textPrimaryDark,
      height: 1.22,
    ),

    // Headline
    headlineLarge: GoogleFonts.montserrat(
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      color: AppColors.textPrimaryDark,
      height: 1.25,
    ),
    headlineMedium: GoogleFonts.montserrat(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      letterSpacing: 0,
      color: AppColors.textPrimaryDark,
      height: 1.29,
    ),
    headlineSmall: GoogleFonts.montserrat(
      fontSize: 24,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: AppColors.textPrimaryDark,
      height: 1.33,
    ),

    // Title
    titleLarge: GoogleFonts.montserrat(
      fontSize: 22,
      fontWeight: FontWeight.w600,
      letterSpacing: 0,
      color: AppColors.textPrimaryDark,
      height: 1.27,
    ),
    titleMedium: GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.15,
      color: AppColors.textPrimaryDark,
      height: 1.5,
    ),
    titleSmall: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: AppColors.textPrimaryDark,
      height: 1.43,
    ),

    // Body
    bodyLarge: GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.5,
      color: AppColors.textPrimaryDark,
      height: 1.5,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.25,
      color: AppColors.textPrimaryDark,
      height: 1.43,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      letterSpacing: 0.4,
      color: AppColors.textSecondaryDark,
      height: 1.33,
    ),

    // Label
    labelLarge: GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.1,
      color: AppColors.textPrimaryDark,
      height: 1.43,
    ),
    labelMedium: GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
      color: AppColors.textPrimaryDark,
      height: 1.33,
    ),
    labelSmall: GoogleFonts.montserrat(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
      color: AppColors.textSecondaryDark,
      height: 1.45,
    ),
  );

  // === CUSTOM TEXT STYLES ===

  /// Titre de page (AppBar)
  static TextStyle pageTitle(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      letterSpacing: 0.15,
    );
  }

  /// Titre de section
  static TextStyle sectionTitle(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.montserrat(
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      letterSpacing: 0,
    );
  }

  /// Titre de card
  static TextStyle cardTitle(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.montserrat(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      letterSpacing: 0.15,
    );
  }

  /// Sous-titre de card
  static TextStyle cardSubtitle(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
      letterSpacing: 0.25,
    );
  }

  /// Label de formulaire
  static TextStyle fieldLabel(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      letterSpacing: 0.1,
    );
  }

  /// Texte d'input
  static TextStyle fieldText(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 16,
      fontWeight: FontWeight.normal,
      color: color ?? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight),
      letterSpacing: 0.5,
    );
  }

  /// Texte de bouton
  static TextStyle buttonText(BuildContext context, {Color? color}) {
    return GoogleFonts.montserrat(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      letterSpacing: 0.75,
    );
  }

  /// Prix / montants (highlight)
  static TextStyle price(BuildContext context, {Color? color}) {
    return GoogleFonts.montserrat(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: color ?? AppColors.primary,
      letterSpacing: 0,
    );
  }

  /// Badge / chip text
  static TextStyle badge(BuildContext context, {Color? color}) {
    return GoogleFonts.montserrat(
      fontSize: 12,
      fontWeight: FontWeight.w600,
      color: color ?? Colors.white,
      letterSpacing: 0.5,
    );
  }

  /// Caption (très petit texte)
  static TextStyle caption(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.inter(
      fontSize: 12,
      fontWeight: FontWeight.normal,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
      letterSpacing: 0.4,
    );
  }

  /// Overline (labels tout en majuscules)
  static TextStyle overline(BuildContext context, {Color? color}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GoogleFonts.montserrat(
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: color ?? (isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight),
      letterSpacing: 1.5,
    ).copyWith(
      textBaseline: TextBaseline.alphabetic,
    );
  }
}
