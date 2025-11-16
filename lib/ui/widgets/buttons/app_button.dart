import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_constants.dart';

/// Énumération des types de boutons
enum AppButtonType {
  primary, // Bouton principal (filled)
  secondary, // Bouton secondaire (outlined)
  text, // Bouton texte
  danger, // Bouton danger (rouge)
  success, // Bouton succès (vert)
}

/// Énumération des tailles de boutons
enum AppButtonSize {
  small,
  medium,
  large,
}

/// Bouton réutilisable avec styles cohérents
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final Color? customColor;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.customColor,
  });

  /// Constructeur pour bouton primaire
  const AppButton.primary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  })  : type = AppButtonType.primary,
        customColor = null;

  /// Constructeur pour bouton secondaire
  const AppButton.secondary({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  })  : type = AppButtonType.secondary,
        customColor = null;

  /// Constructeur pour bouton texte
  const AppButton.text({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  })  : type = AppButtonType.text,
        customColor = null;

  /// Constructeur pour bouton danger
  const AppButton.danger({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  })  : type = AppButtonType.danger,
        customColor = null;

  /// Constructeur pour bouton succès
  const AppButton.success({
    super.key,
    required this.text,
    this.onPressed,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
  })  : type = AppButtonType.success,
        customColor = null;

  @override
  Widget build(BuildContext context) {
    final buttonHeight = _getHeight();
    final buttonPadding = _getPadding();
    final fontSize = _getFontSize();

    Widget buttonChild = isLoading
        ? SizedBox(
            width: _getLoaderSize(),
            height: _getLoaderSize(),
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                _getLoaderColor(context),
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: _getIconSize()),
                SizedBox(width: ThemeConstants.spacingSm),
              ],
              Text(
                text,
                style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.75,
                ),
              ),
            ],
          );

    Widget button;

    switch (type) {
      case AppButtonType.primary:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: customColor ?? AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: Size(0, buttonHeight),
            padding: buttonPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
          ),
          child: buttonChild,
        );
        break;

      case AppButtonType.secondary:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: customColor ?? AppColors.primary,
            side: BorderSide(
              color: customColor ?? AppColors.primary,
              width: ThemeConstants.borderWidthMedium,
            ),
            minimumSize: Size(0, buttonHeight),
            padding: buttonPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
          ),
          child: buttonChild,
        );
        break;

      case AppButtonType.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: customColor ?? AppColors.primary,
            minimumSize: Size(0, buttonHeight),
            padding: buttonPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
            ),
          ),
          child: buttonChild,
        );
        break;

      case AppButtonType.danger:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: customColor ?? AppColors.error,
            foregroundColor: Colors.white,
            minimumSize: Size(0, buttonHeight),
            padding: buttonPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
          ),
          child: buttonChild,
        );
        break;

      case AppButtonType.success:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: customColor ?? AppColors.success,
            foregroundColor: Colors.white,
            minimumSize: Size(0, buttonHeight),
            padding: buttonPadding,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
          ),
          child: buttonChild,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }

  double _getHeight() {
    switch (size) {
      case AppButtonSize.small:
        return ThemeConstants.buttonHeightSm;
      case AppButtonSize.medium:
        return ThemeConstants.buttonHeightMd;
      case AppButtonSize.large:
        return ThemeConstants.buttonHeightLg;
    }
  }

  EdgeInsets _getPadding() {
    switch (size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingMd,
          vertical: ThemeConstants.spacingSm,
        );
      case AppButtonSize.medium:
        return EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingLg,
          vertical: ThemeConstants.spacingMd,
        );
      case AppButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingXl,
          vertical: ThemeConstants.spacingMd,
        );
    }
  }

  double _getFontSize() {
    switch (size) {
      case AppButtonSize.small:
        return 12;
      case AppButtonSize.medium:
        return 14;
      case AppButtonSize.large:
        return 16;
    }
  }

  double _getIconSize() {
    switch (size) {
      case AppButtonSize.small:
        return ThemeConstants.iconSizeSm;
      case AppButtonSize.medium:
        return ThemeConstants.iconSizeMd;
      case AppButtonSize.large:
        return ThemeConstants.iconSizeLg;
    }
  }

  double _getLoaderSize() {
    switch (size) {
      case AppButtonSize.small:
        return 16;
      case AppButtonSize.medium:
        return 20;
      case AppButtonSize.large:
        return 24;
    }
  }

  Color _getLoaderColor(BuildContext context) {
    if (type == AppButtonType.secondary || type == AppButtonType.text) {
      return customColor ?? AppColors.primary;
    }
    return Colors.white;
  }
}

/// Bouton icône circulaire
class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final Color? color;
  final Color? backgroundColor;
  final double? size;
  final String? tooltip;

  const AppIconButton({
    super.key,
    required this.icon,
    this.onPressed,
    this.color,
    this.backgroundColor,
    this.size,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    final button = IconButton(
      onPressed: onPressed,
      icon: Icon(icon),
      color: color,
      iconSize: size ?? ThemeConstants.iconSizeMd,
      style: backgroundColor != null
          ? IconButton.styleFrom(
              backgroundColor: backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
            )
          : null,
    );

    if (tooltip != null) {
      return Tooltip(
        message: tooltip!,
        child: button,
      );
    }

    return button;
  }
}
