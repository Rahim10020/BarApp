import 'package:flutter/material.dart';
import 'package:projet7/services/auth_service.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/ui/widgets/inputs/app_text_field.dart';

/// Écran de modification du code PIN
class ChangePinScreen extends StatefulWidget {
  const ChangePinScreen({super.key});

  @override
  State<ChangePinScreen> createState() => _ChangePinScreenState();
}

class _ChangePinScreenState extends State<ChangePinScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _oldPinController = TextEditingController();
  final TextEditingController _newPinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  bool _isLoading = false;
  int _failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    // Add listeners to update button state
    _oldPinController.addListener(() => setState(() {}));
    _newPinController.addListener(() => setState(() {}));
    _confirmPinController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _oldPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  bool get _areAllFieldsFilled {
    return _oldPinController.text.isNotEmpty &&
        _newPinController.text.isNotEmpty &&
        _confirmPinController.text.isNotEmpty;
  }

  Future<void> _changePin() async {
    // Validation
    if (_newPinController.text.length < 4) {
      context.showWarningSnackBar('Le nouveau code PIN doit contenir au moins 4 chiffres');
      return;
    }

    if (_newPinController.text != _confirmPinController.text) {
      context.showErrorSnackBar('Les nouveaux codes PIN ne correspondent pas');
      return;
    }

    if (_oldPinController.text == _newPinController.text) {
      context.showWarningSnackBar('Le nouveau code PIN doit être différent de l\'ancien');
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Vérifier l'ancien code PIN
      final isOldPinCorrect = await _authService.authenticateWithPin(_oldPinController.text);

      if (!isOldPinCorrect) {
        setState(() {
          _failedAttempts++;
          _oldPinController.clear();
        });

        if (mounted) {
          if (_failedAttempts >= 3) {
            context.showErrorSnackBar(
              'Ancien code PIN incorrect ($_failedAttempts tentatives). Trop de tentatives échouées.'
            );
          } else {
            context.showErrorSnackBar(
              'Ancien code PIN incorrect ($_failedAttempts/3 tentatives)'
            );
          }
        }
        setState(() => _isLoading = false);
        return;
      }

      // Changer le code PIN
      final success = await _authService.changePin(
        _oldPinController.text,
        _newPinController.text,
      );

      if (success) {
        if (mounted) {
          context.showSuccessSnackBar('Code PIN modifié avec succès !');
          Navigator.of(context).pop(true);
        }
      } else {
        if (mounted) {
          context.showErrorSnackBar('Échec de la modification du code PIN');
        }
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Erreur: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Modifier le code PIN', style: Theme.of(context).textTheme.titleMedium),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: ThemeConstants.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // En-tête avec icône
              AppCard(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ThemeConstants.spacingLg),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_reset,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.spacingMd),
                    Text(
                      'Modifier votre code PIN',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: ThemeConstants.spacingSm),
                    Text(
                      'Pour votre sécurité, veuillez d\'abord entrer votre ancien code PIN',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: ThemeConstants.spacingLg),

              // Formulaire
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ancien code PIN',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: ThemeConstants.spacingMd),

                    AppTextField(
                      controller: _oldPinController,
                      label: 'Ancien code PIN',
                      hint: 'Entrez votre code PIN actuel',
                      prefixIcon: Icons.lock_outline,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                    ),

                    const SizedBox(height: ThemeConstants.spacingLg),

                    Text(
                      'Nouveau code PIN',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: ThemeConstants.spacingMd),

                    AppTextField(
                      controller: _newPinController,
                      label: 'Nouveau code PIN',
                      hint: 'Entrez au moins 4 chiffres',
                      prefixIcon: Icons.pin,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                    ),

                    const SizedBox(height: ThemeConstants.spacingMd),

                    AppTextField(
                      controller: _confirmPinController,
                      label: 'Confirmer le nouveau code PIN',
                      hint: 'Confirmez votre nouveau code PIN',
                      prefixIcon: Icons.pin,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      onFieldSubmitted: (_) {
                        if (_areAllFieldsFilled && !_isLoading) {
                          _changePin();
                        }
                      },
                    ),
                  ],
                ),
              ),

              const SizedBox(height: ThemeConstants.spacingXl),

              // Boutons
              AppButton.primary(
                text: 'Modifier le code PIN',
                icon: Icons.check_circle,
                isFullWidth: true,
                onPressed: (_isLoading || !_areAllFieldsFilled) ? null : _changePin,
                isLoading: _isLoading,
              ),

              const SizedBox(height: ThemeConstants.spacingMd),

              AppButton.secondary(
                text: 'Annuler',
                isFullWidth: true,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

