import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:projet7/presentation/pages/settings/auth_setup_screen.dart';
import 'package:projet7/presentation/pages/settings/change_pin_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/providers/theme_provider.dart';
import 'package:projet7/data/services/auth_service.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/buttons/app_button.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:provider/provider.dart';

/// Page des paramètres de l'application
class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _isBackingUp = false;
  bool _isRestoring = false;
  final AuthService _authService = AuthService();
  bool _isAuthEnabled = false;
  bool _useBiometric = false;

  @override
  void initState() {
    super.initState();
    _loadAuthStatus();
  }

  Future<void> _loadAuthStatus() async {
    final isEnabled = await _authService.isAuthEnabled();
    final useBiometric = await _authService.shouldUseBiometric();
    setState(() {
      _isAuthEnabled = isEnabled;
      _useBiometric = useBiometric;
    });
  }

  Future<void> _handleBackup(BarAppProvider provider) async {
    setState(() => _isBackingUp = true);

    try {
      await provider.backupData();
      if (mounted) {
        setState(() => _isBackingUp = false);
        context.showSuccessSnackBar('Sauvegarde effectuée avec succès');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isBackingUp = false);
        context.showErrorSnackBar('Erreur: $e');
      }
    }
  }

  Future<void> _handleRestore(BarAppProvider provider) async {
    final confirmed = await AppDialogs.showConfirmDialog(
      context,
      title: 'Restaurer les données',
      message:
          'Cette action va remplacer toutes vos données actuelles par la dernière sauvegarde. Continuer ?',
      confirmText: 'Restaurer',
      cancelText: 'Annuler',
    );

    if (confirmed != true) return;

    if (mounted) {
      setState(() => _isRestoring = true);
    }

    try {
      await provider.restoreData();
      if (mounted) {
        setState(() => _isRestoring = false);
        context.showSuccessSnackBar('Restauration effectuée avec succès');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isRestoring = false);
        context.showErrorSnackBar('Erreur: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final barProvider = Provider.of<BarAppProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramètres'),
      ),
      body: ListView(
        padding: ThemeConstants.pagePadding,
        children: [
          // Section Apparence
          Text(
            'Apparence',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: Icon(
                    themeProvider.isDarkMode
                        ? Icons.dark_mode_rounded
                        : Icons.light_mode_rounded,
                    color: Theme.of(context).brightness == Brightness.dark
                        ? AppColors.accent
                        : AppColors.primary,
                    size: ThemeConstants.iconSizeMd,
                  ),
                ),
                const SizedBox(width: ThemeConstants.spacingMd),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mode sombre',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        themeProvider.isDarkMode ? 'Activé' : 'Désactivé',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                CupertinoSwitch(
                  value: themeProvider.isDarkMode,
                  onChanged: (_) => themeProvider.toggleTheme(),
                  activeTrackColor: AppColors.primary,
                ),
              ],
            ),
          ),

          const SizedBox(height: ThemeConstants.spacingXl),

          // Section Sécurité
          Text(
            'Sécurité',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Icon(
                        _isAuthEnabled ? Icons.lock : Icons.lock_open,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? AppColors.accent
                            : AppColors.primary,
                        size: ThemeConstants.iconSizeMd,
                      ),
                    ),
                    const SizedBox(width: ThemeConstants.spacingMd),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Authentification',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          Text(
                            _isAuthEnabled
                                ? (_useBiometric
                                    ? 'Biométrie activée'
                                    : 'Code PIN activé')
                                : 'Désactivée',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                    CupertinoSwitch(
                      value: _isAuthEnabled,
                      onChanged: (value) async {
                        if (value) {
                          // Activer l'authentification
                          final result = await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const AuthSetupScreen(),
                            ),
                          );

                          if (result == true) {
                            await _loadAuthStatus();
                            if (mounted) {
                              context.showSuccessSnackBar(
                                'Authentification activée',
                              );
                            }
                          }
                        } else {
                          // Désactiver l'authentification
                          final confirmed = await AppDialogs.showConfirmDialog(
                            context,
                            title: 'Désactiver l\'authentification',
                            message:
                                'Voulez-vous vraiment désactiver la protection de l\'application ?',
                            confirmText: 'Désactiver',
                            cancelText: 'Annuler',
                          );

                          if (confirmed == true) {
                            await _authService.disableAuth();
                            await _loadAuthStatus();
                            if (mounted) {
                              context.showSuccessSnackBar(
                                'Authentification désactivée',
                              );
                            }
                          }
                        }
                      },
                      activeTrackColor: AppColors.primary,
                    ),
                  ],
                ),

                if (_isAuthEnabled) ...[
                  const Divider(height: ThemeConstants.spacingLg),

                  // Bouton pour changer le code PIN
                  AppButton.secondary(
                    text: 'Modifier le code PIN',
                    icon: Icons.edit,
                    isFullWidth: true,
                    onPressed: () async {
                      final result = await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ChangePinScreen(),
                        ),
                      );

                      if (result == true) {
                        if (mounted) {
                          context.showSuccessSnackBar('Code PIN modifié avec succès');
                        }
                      }
                    },
                  ),
                ],
              ],
            ),
          ),

          const SizedBox(height: ThemeConstants.spacingXl),

          // Section Données
          Text(
            'Sauvegarde et Restauration',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.backup_rounded,
                      color: AppColors.info,
                      size: ThemeConstants.iconSizeMd,
                    ),
                    const SizedBox(width: ThemeConstants.spacingSm),
                    Text(
                      'Gestion des données',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.info,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: ThemeConstants.spacingSm),
                Text(
                  'Sauvegardez vos données régulièrement pour éviter toute perte.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: ThemeConstants.spacingMd),

                // Boutons d'action
                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        text: 'Sauvegarder',
                        icon: Icons.backup_rounded,
                        type: AppButtonType.success,
                        isLoading: _isBackingUp,
                        onPressed: () => _handleBackup(barProvider),
                      ),
                    ),
                    const SizedBox(width: ThemeConstants.spacingMd),
                    Expanded(
                      child: AppButton.secondary(
                        text: 'Restaurer',
                        icon: Icons.restore_rounded,
                        isLoading: _isRestoring,
                        onPressed: () => _handleRestore(barProvider),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: ThemeConstants.spacingXl),

          // Section À propos
          Text(
            'À propos',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            child: Column(
              children: [
                _buildInfoRow(
                  context,
                  icon: Icons.info_rounded,
                  label: 'Version',
                  value: '1.0.0',
                ),
                const Divider(height: ThemeConstants.spacingLg),
                _buildInfoRow(
                  context,
                  icon: Icons.local_bar_rounded,
                  label: 'Application',
                  value: 'BarApp',
                ),
                const Divider(height: ThemeConstants.spacingLg),
                _buildInfoRow(
                  context,
                  icon: Icons.business_rounded,
                  label: 'Bar actuel',
                  value: barProvider.currentBar?.nom ?? 'Non configuré',
                ),
              ],
            ),
          ),

          const SizedBox(height: ThemeConstants.spacingXl),

          // Section Danger
          Text(
            'Zone de danger',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                ),
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            color: AppColors.error.withValues(alpha: 0.1),
            border: Border.all(
              color: AppColors.error.withValues(alpha: 0.3),
              width: ThemeConstants.borderWidthThin,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.warning_rounded,
                      color: AppColors.error,
                      size: ThemeConstants.iconSizeMd,
                    ),
                    const SizedBox(width: ThemeConstants.spacingSm),
                    Text(
                      'Actions irréversibles',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.error,
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: ThemeConstants.spacingSm),
                Text(
                  'Ces actions ne peuvent pas être annulées.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: ThemeConstants.spacingMd),
                AppButton(
                  text: 'Réinitialiser les données',
                  icon: Icons.delete_forever_rounded,
                  type: AppButtonType.danger,
                  isFullWidth: true,
                  onPressed: () async {
                    final confirmed = await AppDialogs.showConfirmDialog(
                      context,
                      title: 'Réinitialiser les données',
                      message:
                          'ATTENTION: Cette action supprimera TOUTES vos données de manière irréversible. Êtes-vous absolument sûr ?',
                      confirmText: 'Tout supprimer',
                      cancelText: 'Annuler',
                    );

                    if (confirmed == true && context.mounted) {
                      context.showInfoSnackBar(
                          'Fonctionnalité non encore implémentée');
                    }
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: ThemeConstants.spacingXl),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Theme.of(context).brightness == Brightness.dark
              ? AppColors.accent
              : AppColors.primary,
          size: ThemeConstants.iconSizeSm,
        ),
        const SizedBox(width: ThemeConstants.spacingMd),
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}
