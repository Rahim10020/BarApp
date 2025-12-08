import 'package:flutter/material.dart';
import 'package:projet7/data/services/auth_service.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/buttons/app_button.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/presentation/widgets/inputs/app_text_field.dart';

/// Écran d'authentification (Biométrie ou PIN)
class AuthLoginScreen extends StatefulWidget {
  const AuthLoginScreen({super.key});

  @override
  State<AuthLoginScreen> createState() => _AuthLoginScreenState();
}

class _AuthLoginScreenState extends State<AuthLoginScreen> {
  final AuthService _authService = AuthService();
  final TextEditingController _pinController = TextEditingController();

  bool _isLoading = false;
  bool _useBiometric = false;
  bool _showPinInput = false;
  int _failedAttempts = 0;

  @override
  void initState() {
    super.initState();
    _pinController.addListener(() {
      setState(() {}); // Rebuild to update button state
    });
    _initAuth();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _initAuth() async {
    final useBiometric = await _authService.shouldUseBiometric();
    setState(() {
      _useBiometric = useBiometric;
    });

    if (useBiometric) {
      // Tenter automatiquement l'authentification biométrique
      await _authenticateWithBiometric();
    } else {
      // Afficher le champ PIN directement
      setState(() => _showPinInput = true);
    }
  }

  Future<void> _authenticateWithBiometric() async {
    setState(() => _isLoading = true);

    try {
      final success = await _authService.authenticateWithBiometric();

      if (success) {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        // Échec biométrique, afficher le PIN
        if (mounted) {
          setState(() {
            _showPinInput = true;
            _isLoading = false;
          });
          context.showWarningSnackBar('Utilisez votre code PIN');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _showPinInput = true;
          _isLoading = false;
        });
        context.showErrorSnackBar('Erreur biométrique: utilisez le code PIN');
      }
    } finally {
      if (mounted && !_showPinInput) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _authenticateWithPin() async {
    if (_pinController.text.isEmpty) {
      context.showWarningSnackBar('Veuillez entrer votre code PIN');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final success =
          await _authService.authenticateWithPin(_pinController.text);

      if (success) {
        if (mounted) {
          Navigator.of(context).pop(true);
        }
      } else {
        setState(() {
          _failedAttempts++;
          _pinController.clear();
        });

        if (mounted) {
          if (_failedAttempts >= 3) {
            context.showErrorSnackBar(
                'Code PIN incorrect ($_failedAttempts tentatives). Trop de tentatives échouées.');
            // Optionnel: bloquer temporairement l'accès
          } else {
            context.showErrorSnackBar(
                'Code PIN incorrect ($_failedAttempts/3 tentatives)');
          }
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
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: ThemeConstants.pagePadding,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo/Icône
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.spacingXl),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _useBiometric && !_showPinInput
                        ? Icons.fingerprint
                        : Icons.lock,
                    size: 80,
                    color: AppColors.primary,
                  ),
                ),

                const SizedBox(height: ThemeConstants.spacingXl),

                // Titre
                Text(
                  'BarApp',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),

                const SizedBox(height: ThemeConstants.spacingSm),

                Text(
                  'Authentification requise',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),

                const SizedBox(height: ThemeConstants.spacingXl),

                // Zone d'authentification
                if (_showPinInput)
                  AppCard(
                    child: Column(
                      children: [
                        AppTextField(
                          controller: _pinController,
                          label: 'Code PIN',
                          hint: 'Entrez votre code PIN',
                          prefixIcon: Icons.pin,
                          obscureText: true,
                          keyboardType: TextInputType.number,
                          maxLength: 8,
                          onFieldSubmitted: (_) => _authenticateWithPin(),
                        ),

                        const SizedBox(height: ThemeConstants.spacingMd),

                        AppButton.primary(
                          text: 'Se connecter',
                          icon: Icons.login,
                          isFullWidth: true,
                          onPressed: (_isLoading || _pinController.text.isEmpty)
                              ? null
                              : _authenticateWithPin,
                          isLoading: _isLoading,
                        ),

                        // Option pour revenir à la biométrie
                        if (_useBiometric) ...[
                          const SizedBox(height: ThemeConstants.spacingMd),
                          TextButton.icon(
                            onPressed: _isLoading
                                ? null
                                : () {
                                    setState(() {
                                      _showPinInput = false;
                                      _pinController.clear();
                                    });
                                    _authenticateWithBiometric();
                                  },
                            icon: const Icon(Icons.fingerprint),
                            label: const Text('Utiliser la biométrie'),
                          ),
                        ],
                      ],
                    ),
                  )
                else if (_useBiometric)
                  AppCard(
                    child: Column(
                      children: [
                        if (_isLoading)
                          const CircularProgressIndicator()
                        else
                          Column(
                            children: [
                              AppButton.primary(
                                text: 'Authentifier avec biométrie',
                                icon: Icons.fingerprint,
                                isFullWidth: true,
                                onPressed: _authenticateWithBiometric,
                              ),
                              const SizedBox(height: ThemeConstants.spacingMd),
                              TextButton.icon(
                                onPressed: () {
                                  setState(() => _showPinInput = true);
                                },
                                icon: const Icon(Icons.pin),
                                label: const Text('Utiliser le code PIN'),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
