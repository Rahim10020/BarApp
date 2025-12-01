import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projet7/theme/dark_mode.dart' as theme;
import 'package:projet7/theme/light_mode.dart' as theme;
import 'app_colors.dart';
import 'app_typography.dart';
import 'theme_constants.dart';

/// Thèmes de l'application (Light & Dark)
///
/// IMPORTANT: Les thèmes sont maintenant basés sur les fichiers dark_mode.dart et light_mode.dart
/// situés dans /lib/theme/. Les couleurs AppColors sont synchronisées avec ces fichiers.
class AppTheme {
  // === LIGHT THEME ===

  static ThemeData lightTheme = theme.lightMode.copyWith(
    // Scaffold
    scaffoldBackgroundColor: AppColors.backgroundLight,
    appBarTheme: AppBarTheme(
      elevation: ThemeConstants.appBarElevation,
      centerTitle: false,
      backgroundColor: AppColors.surfaceLight,
      foregroundColor: AppColors.textPrimaryLight,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTypography.textThemeLight.titleLarge,
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryLight,
        size: ThemeConstants.iconSizeMd,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.dark,
    ),

    // Card
    cardTheme: CardThemeData(
      elevation: ThemeConstants.cardElevation,
      color: AppColors.cardLight,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: const RoundedRectangleBorder(
        borderRadius: ThemeConstants.cardBorderRadius,
      ),
      margin: EdgeInsets.zero,
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceLight,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: AppColors.greyLight500,
      selectedIconTheme: const IconThemeData(size: ThemeConstants.iconSizeLg),
      unselectedIconTheme: const IconThemeData(size: ThemeConstants.iconSizeMd),
      selectedLabelStyle: AppTypography.textThemeLight.labelSmall,
      unselectedLabelStyle: AppTypography.textThemeLight.labelSmall,
      type: BottomNavigationBarType.fixed,
      elevation: ThemeConstants.bottomNavBarElevation,
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: ThemeConstants.elevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingLg,
          vertical: ThemeConstants.spacingMd,
        ),
        minimumSize: const Size(0, ThemeConstants.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: AppTypography.textThemeLight.labelLarge,
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(
          color: AppColors.primary,
          width: ThemeConstants.borderWidthMedium,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingLg,
          vertical: ThemeConstants.spacingMd,
        ),
        minimumSize: const Size(0, ThemeConstants.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: AppTypography.textThemeLight.labelLarge,
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingMd,
          vertical: ThemeConstants.spacingSm,
        ),
        minimumSize: const Size(0, ThemeConstants.buttonHeightSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
        ),
        textStyle: AppTypography.textThemeLight.labelLarge,
      ),
    ),

    // Icon Button
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.textPrimaryLight,
        iconSize: ThemeConstants.iconSizeMd,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyLight50,
      contentPadding: ThemeConstants.inputPadding,
      border: const OutlineInputBorder(
        borderRadius: ThemeConstants.inputBorderRadius,
        borderSide: BorderSide(
          color: AppColors.borderLight,
          width: ThemeConstants.inputBorderWidth,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: ThemeConstants.inputBorderRadius,
        borderSide: BorderSide(
          color: AppColors.borderLight,
          width: ThemeConstants.inputBorderWidth,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: ThemeConstants.inputBorderRadius,
        borderSide: BorderSide(
          color: AppColors.primary,
          width: ThemeConstants.borderWidthMedium,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: ThemeConstants.inputBorderRadius,
        borderSide: BorderSide(
          color: AppColors.error,
          width: ThemeConstants.inputBorderWidth,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: ThemeConstants.inputBorderRadius,
        borderSide: BorderSide(
          color: AppColors.error,
          width: ThemeConstants.borderWidthMedium,
        ),
      ),
      labelStyle: AppTypography.textThemeLight.bodyMedium,
      hintStyle: AppTypography.textThemeLight.bodyMedium?.copyWith(
        color: AppColors.textSecondaryLight,
      ),
      errorStyle: AppTypography.textThemeLight.bodySmall?.copyWith(
        color: AppColors.error,
      ),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation: ThemeConstants.elevationHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.dialogBorderRadius),
      ),
      titleTextStyle: AppTypography.textThemeLight.titleLarge,
      contentTextStyle: AppTypography.textThemeLight.bodyMedium,
    ),

    // Bottom Sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceLight,
      surfaceTintColor: Colors.transparent,
      elevation: ThemeConstants.elevationHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.bottomSheetBorderRadius),
        ),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerLight,
      thickness: ThemeConstants.dividerThickness,
      space: ThemeConstants.dividerThickness,
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.greyLight100,
      selectedColor: AppColors.primary,
      labelStyle: AppTypography.textThemeLight.labelMedium,
      secondaryLabelStyle: AppTypography.textThemeLight.labelMedium?.copyWith(
        color: Colors.white,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacingSm,
        vertical: ThemeConstants.spacingXs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      elevation: 0,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return Colors.white;
        }
        return AppColors.greyLight400;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.greyLight300;
      }),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(Colors.white),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
      ),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primary;
        }
        return AppColors.greyLight500;
      }),
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.greyLight800,
      contentTextStyle: AppTypography.textThemeLight.bodyMedium?.copyWith(
        color: Colors.white,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
    ),

    // Typography
    textTheme: AppTypography.textThemeLight,

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryLight,
      size: ThemeConstants.iconSizeMd,
    ),
  );

  // === DARK THEME ===

  static ThemeData darkTheme = theme.darkMode.copyWith(
    // Scaffold
    scaffoldBackgroundColor: AppColors.backgroundDark,

    // AppBar
    appBarTheme: AppBarTheme(
      elevation: ThemeConstants.appBarElevation,
      centerTitle: false,
      backgroundColor: AppColors.surfaceDark,
      foregroundColor: AppColors.textPrimaryDark,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: AppTypography.textThemeDark.titleLarge,
      iconTheme: const IconThemeData(
        color: AppColors.textPrimaryDark,
        size: ThemeConstants.iconSizeMd,
      ),
      systemOverlayStyle: SystemUiOverlayStyle.light,
    ),

    // Card
    cardTheme: CardThemeData(
      elevation: ThemeConstants.cardElevation,
      color: AppColors.cardDark,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black.withValues(alpha: 0.3),
      shape: const RoundedRectangleBorder(
        borderRadius: ThemeConstants.cardBorderRadius,
      ),
      margin: EdgeInsets.zero,
    ),

    // Bottom Navigation Bar
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: AppColors.surfaceDark,
      selectedItemColor: AppColors.primaryLight,
      unselectedItemColor: AppColors.greyDark400,
      selectedIconTheme: const IconThemeData(size: ThemeConstants.iconSizeLg),
      unselectedIconTheme: const IconThemeData(size: ThemeConstants.iconSizeMd),
      selectedLabelStyle: AppTypography.textThemeDark.labelSmall,
      unselectedLabelStyle: AppTypography.textThemeDark.labelSmall,
      type: BottomNavigationBarType.fixed,
      elevation: ThemeConstants.bottomNavBarElevation,
    ),

    // Floating Action Button
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.primaryLight,
      foregroundColor: AppColors.greyDark900,
      elevation: ThemeConstants.elevationHigh,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
      ),
    ),

    // Elevated Button
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryLight,
        foregroundColor: AppColors.greyDark900,
        elevation: 0,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingLg,
          vertical: ThemeConstants.spacingMd,
        ),
        minimumSize: const Size(0, ThemeConstants.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: AppTypography.textThemeDark.labelLarge,
      ),
    ),

    // Outlined Button
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        side: const BorderSide(
          color: AppColors.primaryLight,
          width: ThemeConstants.borderWidthMedium,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingLg,
          vertical: ThemeConstants.spacingMd,
        ),
        minimumSize: const Size(0, ThemeConstants.buttonHeightMd),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        textStyle: AppTypography.textThemeDark.labelLarge,
      ),
    ),

    // Text Button
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primaryLight,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingMd,
          vertical: ThemeConstants.spacingSm,
        ),
        minimumSize: const Size(0, ThemeConstants.buttonHeightSm),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
        ),
        textStyle: AppTypography.textThemeDark.labelLarge,
      ),
    ),

    // Icon Button
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        foregroundColor: AppColors.textPrimaryDark,
        iconSize: ThemeConstants.iconSizeMd,
      ),
    ),

    // Input Decoration
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.greyDark100,
      contentPadding: ThemeConstants.inputPadding,
      border: const OutlineInputBorder(
        borderRadius: ThemeConstants.inputBorderRadius,
        borderSide: BorderSide(
          color: AppColors.borderDark,
          width: ThemeConstants.inputBorderWidth,
        ),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: ThemeConstants.inputBorderRadius,
        borderSide: BorderSide(
          color: AppColors.borderDark,
          width: ThemeConstants.inputBorderWidth,
        ),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: ThemeConstants.inputBorderRadius,
        borderSide: BorderSide(
          color: AppColors.primaryLight,
          width: ThemeConstants.borderWidthMedium,
        ),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: ThemeConstants.inputBorderRadius,
        borderSide: BorderSide(
          color: AppColors.errorLight,
          width: ThemeConstants.inputBorderWidth,
        ),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: ThemeConstants.inputBorderRadius,
        borderSide: BorderSide(
          color: AppColors.errorLight,
          width: ThemeConstants.borderWidthMedium,
        ),
      ),
      labelStyle: AppTypography.textThemeDark.bodyMedium,
      hintStyle: AppTypography.textThemeDark.bodyMedium?.copyWith(
        color: AppColors.textSecondaryDark,
      ),
      errorStyle: AppTypography.textThemeDark.bodySmall?.copyWith(
        color: AppColors.errorLight,
      ),
    ),

    // Dialog
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation: ThemeConstants.elevationHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.dialogBorderRadius),
      ),
      titleTextStyle: AppTypography.textThemeDark.titleLarge,
      contentTextStyle: AppTypography.textThemeDark.bodyMedium,
    ),

    // Bottom Sheet
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: AppColors.surfaceDark,
      surfaceTintColor: Colors.transparent,
      elevation: ThemeConstants.elevationHighest,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(ThemeConstants.bottomSheetBorderRadius),
        ),
      ),
    ),

    // Divider
    dividerTheme: const DividerThemeData(
      color: AppColors.dividerDark,
      thickness: ThemeConstants.dividerThickness,
      space: ThemeConstants.dividerThickness,
    ),

    // Chip
    chipTheme: ChipThemeData(
      backgroundColor: AppColors.greyDark200,
      selectedColor: AppColors.primaryLight,
      labelStyle: AppTypography.textThemeDark.labelMedium,
      secondaryLabelStyle: AppTypography.textThemeDark.labelMedium?.copyWith(
        color: AppColors.greyDark900,
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacingSm,
        vertical: ThemeConstants.spacingXs,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
      elevation: 0,
    ),

    // Switch
    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.greyDark900;
        }
        return AppColors.greyDark600;
      }),
      trackColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return AppColors.greyDark400;
      }),
    ),

    // Checkbox
    checkboxTheme: CheckboxThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return Colors.transparent;
      }),
      checkColor: WidgetStateProperty.all(AppColors.greyDark900),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
      ),
    ),

    // Radio
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.selected)) {
          return AppColors.primaryLight;
        }
        return AppColors.greyDark500;
      }),
    ),

    // Snackbar
    snackBarTheme: SnackBarThemeData(
      backgroundColor: AppColors.greyDark700,
      contentTextStyle: AppTypography.textThemeDark.bodyMedium?.copyWith(
        color: AppColors.greyDark900,
      ),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
      ),
    ),

    // Typography
    textTheme: AppTypography.textThemeDark,

    // Icon Theme
    iconTheme: const IconThemeData(
      color: AppColors.textPrimaryDark,
      size: ThemeConstants.iconSizeMd,
    ),
  );
}
