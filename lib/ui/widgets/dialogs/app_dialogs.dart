import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_constants.dart';
import '../buttons/app_button.dart';

/// Utilities pour afficher des dialogs cohérents
class AppDialogs {
  /// Dialog de confirmation (pour suppressions, etc.)
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'Confirmer',
    String cancelText = 'Annuler',
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          AppButton.text(
            text: cancelText,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          AppButton(
            text: confirmText,
            type: isDangerous ? AppButtonType.danger : AppButtonType.primary,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
  }

  /// Dialog de confirmation de suppression
  static Future<bool?> showDeleteDialog(
    BuildContext context, {
    String? itemName,
    String? title,
    String? message,
  }) {
    final dialogTitle = title ?? 'Supprimer ${itemName ?? 'cet élément'} ?';
    final dialogMessage = message ??
        (itemName != null
            ? 'Voulez-vous vraiment supprimer $itemName ? Cette action est irréversible.'
            : 'Voulez-vous vraiment supprimer cet élément ? Cette action est irréversible.');

    return showConfirmDialog(
      context,
      title: dialogTitle,
      message: dialogMessage,
      confirmText: 'Supprimer',
      cancelText: 'Annuler',
      isDangerous: true,
    );
  }

  /// Dialog d'information simple
  static Future<void> showInfoDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          AppButton.primary(
            text: buttonText,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Dialog d'erreur
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.error_outline, color: AppColors.error),
            SizedBox(width: ThemeConstants.spacingSm),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          AppButton.danger(
            text: buttonText,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Dialog de succès
  static Future<void> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    String buttonText = 'OK',
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.check_circle_outline, color: AppColors.success),
            SizedBox(width: ThemeConstants.spacingSm),
            Text(title),
          ],
        ),
        content: Text(message),
        actions: [
          AppButton.success(
            text: buttonText,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Dialog de validation (erreurs de formulaire)
  static Future<void> showValidationDialog(
    BuildContext context, {
    required String field,
    String? customMessage,
  }) {
    return showErrorDialog(
      context,
      title: 'Champ requis',
      message: customMessage ?? 'Le champ "$field" est requis.',
    );
  }

  /// Dialog de loading
  static void showLoadingDialog(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              if (message != null) ...[
                SizedBox(height: ThemeConstants.spacingMd),
                Text(message),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Fermer le dialog de loading
  static void hideLoadingDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  /// Bottom sheet personnalisé
  static Future<T?> showAppBottomSheet<T>(
    BuildContext context, {
    required Widget child,
    String? title,
    bool isDismissible = true,
    bool enableDrag = true,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ThemeConstants.bottomSheetBorderRadius),
          ),
        ),
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            if (enableDrag) ...[
              SizedBox(height: ThemeConstants.spacingSm),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.greyLight300,
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
                ),
              ),
            ],

            // Title
            if (title != null) ...[
              SizedBox(height: ThemeConstants.spacingMd),
              Padding(
                padding: ThemeConstants.paddingHorizontal,
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              SizedBox(height: ThemeConstants.spacingMd),
              Divider(height: 1),
            ],

            // Content
            Padding(
              padding: ThemeConstants.bottomSheetPadding,
              child: child,
            ),
          ],
        ),
      ),
    );
  }

  /// Input dialog (pour saisir du texte)
  static Future<String?> showInputDialog(
    BuildContext context, {
    required String title,
    String? hint,
    String? initialValue,
    String confirmText = 'OK',
    String cancelText = 'Annuler',
    TextInputType? keyboardType,
  }) {
    final controller = TextEditingController(text: initialValue);

    return showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: hint),
          keyboardType: keyboardType,
          autofocus: true,
        ),
        actions: [
          AppButton.text(
            text: cancelText,
            onPressed: () => Navigator.of(context).pop(null),
          ),
          AppButton.primary(
            text: confirmText,
            onPressed: () => Navigator.of(context).pop(controller.text),
          ),
        ],
      ),
    );
  }

  /// Choice dialog (sélectionner parmi plusieurs options)
  static Future<T?> showChoiceDialog<T>(
    BuildContext context, {
    required String title,
    required List<T> options,
    required String Function(T) getLabel,
    T? selectedOption,
  }) {
    return showDialog<T>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((option) {
            final isSelected = option == selectedOption;
            return ListTile(
              title: Text(getLabel(option)),
              selected: isSelected,
              leading: Radio<T>(
                value: option,
                groupValue: selectedOption,
                onChanged: (value) => Navigator.of(context).pop(value),
              ),
              onTap: () => Navigator.of(context).pop(option),
            );
          }).toList(),
        ),
      ),
    );
  }
}

/// Extension pour afficher facilement des snackbars
extension SnackBarExtension on BuildContext {
  /// Afficher un snackbar de succès
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: ThemeConstants.spacingSm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Afficher un snackbar d'erreur
  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error, color: Colors.white),
            SizedBox(width: ThemeConstants.spacingSm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Afficher un snackbar d'information
  void showInfoSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.info, color: Colors.white),
            SizedBox(width: ThemeConstants.spacingSm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Afficher un snackbar d'avertissement
  void showWarningSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.warning, color: Colors.white),
            SizedBox(width: ThemeConstants.spacingSm),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: AppColors.warning,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
