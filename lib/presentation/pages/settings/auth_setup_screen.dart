import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:projet7/data/services/auth_service.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/buttons/app_button.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/presentation/widgets/inputs/app_text_field.dart';

/// Écran de configuration de l'authentification
class AuthSetupScreen extends StatefulWidget {
  const AuthSetupScreen({super.key});

  @override
  State<AuthSetupScreen> createState() => _AuthSetupScreenState();
}

class _AuthSetupScreenState extends State<AuthSetupScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  bool _isLoading = false;
  bool _biometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];
  bool _useBiometric = false;

  bool get _areAllFieldsFilled {
    return _pinController.text.isNotEmpty &&
        _confirmPinController.text.isNotEmpty;
  }

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
    // Add listeners to update button state
    _pinController.addListener(() => setState(() {}));
    _confirmPinController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    final isAvailable = await _authService.isBiometricAvailable();
    final biometrics = await _authService.getAvailableBiometrics();

    setState(() {
      _biometricAvailable = isAvailable;
      _availableBiometrics = biometrics;
      _useBiometric =
          isAvailable; // Par défaut, utiliser la biométrie si disponible
    });
  }

  String _getBiometricTypeLabel() {
    if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Face ID';
    } else if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Empreinte digitale';
    } else if (_availableBiometrics.contains(BiometricType.iris)) {
      return 'Reconnaissance de l\'iris';
    }
    return 'Biométrie';
  }

  Future<void> _setupAuth() async {
    // Validation
    if (_pinController.text.isEmpty) {
      context.showWarningSnackBar('Veuillez entrer un code PIN');
      return;
    }

    if (_pinController.text.length < 4) {
      context
          .showWarningSnackBar('Le code PIN doit contenir au moins 4 chiffres');
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      context.showErrorSnackBar('Les codes PIN ne correspondent pas');
      return;
    }

    setState(() => _isLoading = true);

    try {
      if (_useBiometric && _biometricAvailable) {
        // Tester la biométrie avant de configurer
        final success = await _authService.authenticateWithBiometric();
        if (!success) {
          if (mounted) {
            context.showErrorSnackBar('Authentification biométrique échouée');
          }
          setState(() => _isLoading = false);
          return;
        }

        await _authService.enableAuthWithBiometric(_pinController.text);
        if (mounted) {
          context.showSuccessSnackBar('Authentification biométrique activée !');
        }
      } else {
        await _authService.enableAuthWithPin(_pinController.text);
        if (mounted) {
          context.showSuccessSnackBar('Code PIN configuré avec succès !');
        }
      }

      if (mounted) {
        Navigator.of(context).pop(true);
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
        title: Text('Configuration de la sécurité',
            style: Theme.of(context).textTheme.titleMedium),
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
                      child: Icon(
                        _biometricAvailable ? Icons.fingerprint : Icons.lock,
                        size: 64,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: ThemeConstants.spacingMd),
                    Text(
                      'Sécurisez votre application',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: ThemeConstants.spacingSm),
                    Text(
                      'Configurez l\'authentification pour protéger vos données',
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: ThemeConstants.spacingLg),

              // Option biométrique
              if (_biometricAvailable)
                AppCard(
                  child: SwitchListTile(
                    value: _useBiometric,
                    onChanged: (value) {
                      setState(() => _useBiometric = value);
                    },
                    title: Text('Utiliser ${_getBiometricTypeLabel()}'),
                    subtitle: Text(
                      _useBiometric
                          ? 'Code PIN utilisé en secours'
                          : 'Authentification par code PIN uniquement',
                    ),
                    secondary: Icon(
                      _useBiometric ? Icons.fingerprint : Icons.lock_outline,
                      color: AppColors.primary,
                    ),
                  ),
                ),

              if (_biometricAvailable)
                const SizedBox(height: ThemeConstants.spacingLg),

              // Configuration du code PIN
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Code PIN ${_useBiometric ? "(secours)" : ""}',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: ThemeConstants.spacingSm),
                    Text(
                      _useBiometric
                          ? 'Créez un code PIN qui servira en cas d\'échec de la biométrie'
                          : 'Créez un code PIN pour sécuriser l\'application',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: ThemeConstants.spacingMd),
                    AppTextField(
                      controller: _pinController,
                      label: 'Code PIN',
                      hint: 'Entrez au moins 4 chiffres',
                      prefixIcon: Icons.pin,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                    ),
                    const SizedBox(height: ThemeConstants.spacingMd),
                    AppTextField(
                      controller: _confirmPinController,
                      label: 'Confirmer le code PIN',
                      hint: 'Confirmez votre code PIN',
                      prefixIcon: Icons.pin,
                      obscureText: true,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: ThemeConstants.spacingXl),

              // Boutons
              AppButton.primary(
                text: 'Configurer',
                icon: Icons.check_circle,
                isFullWidth: true,
                onPressed:
                    (_isLoading || !_areAllFieldsFilled) ? null : _setupAuth,
                isLoading: _isLoading,
              ),

              const SizedBox(height: ThemeConstants.spacingMd),

              AppButton.secondary(
                text: 'Ignorer',
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
