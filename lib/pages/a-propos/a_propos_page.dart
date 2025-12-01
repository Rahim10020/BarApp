import 'package:flutter/material.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/app_typography.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';

/// Page "À propos" de l'application.
///
/// Affiche les informations sur l'application:
/// - Nom de l'application (BarApp)
/// - Version actuelle
/// - Description de l'application
class AProposPage extends StatelessWidget {
  const AProposPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'À propos',
          style: AppTypography.pageTitle(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: ThemeConstants.pagePadding,
        child: Column(
          children: [
            const SizedBox(height: ThemeConstants.spacingLg),

            // Logo et nom de l'app
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(ThemeConstants.spacingLg),
              decoration: BoxDecoration(
                gradient:
                    isDark ? AppColors.darkGradient : AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                boxShadow: isDark ? AppColors.shadowDark : AppColors.shadowMd,
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(ThemeConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(ThemeConstants.radiusLg),
                    ),
                    child: const Icon(
                      Icons.local_bar_rounded,
                      size: ThemeConstants.iconSize2Xl,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.spacingMd),
                  Text(
                    'BarApp',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: ThemeConstants.spacingXs),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.spacingMd,
                      vertical: ThemeConstants.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(ThemeConstants.radiusFull),
                    ),
                    child: Text(
                      'Version 1.0.0',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ThemeConstants.spacingLg),

            // Description
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                        decoration: BoxDecoration(
                          color: AppColors.info.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(ThemeConstants.radiusMd),
                        ),
                        child: const Icon(
                          Icons.info_rounded,
                          color: AppColors.info,
                          size: ThemeConstants.iconSizeSm,
                        ),
                      ),
                      const SizedBox(width: ThemeConstants.spacingSm),
                      Text(
                        'Description',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ThemeConstants.spacingMd),
                  Text(
                    'BarApp est une application mobile permettant de gérer efficacement les commandes, les ventes et le stock pour un bar ou un établissement de restauration.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ThemeConstants.spacingMd),

            // Fonctionnalités
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                        decoration: BoxDecoration(
                          color: AppColors.success.withValues(alpha: 0.1),
                          borderRadius:
                              BorderRadius.circular(ThemeConstants.radiusMd),
                        ),
                        child: const Icon(
                          Icons.check_circle_rounded,
                          color: AppColors.success,
                          size: ThemeConstants.iconSizeSm,
                        ),
                      ),
                      const SizedBox(width: ThemeConstants.spacingSm),
                      Text(
                        'Fonctionnalités',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ThemeConstants.spacingMd),
                  _buildFeatureItem(context, 'Gestion des ventes'),
                  _buildFeatureItem(context, 'Gestion des commandes'),
                  _buildFeatureItem(context, 'Suivi du stock'),
                  _buildFeatureItem(context, 'Rapports et statistiques'),
                  _buildFeatureItem(context, 'Export PDF'),
                ],
              ),
            ),

            const SizedBox(height: ThemeConstants.spacingMd),

            // Contact / Support
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
                        child: const Icon(
                          Icons.support_agent_rounded,
                          color: AppColors.primary,
                          size: ThemeConstants.iconSizeSm,
                        ),
                      ),
                      const SizedBox(width: ThemeConstants.spacingSm),
                      Text(
                        'Support',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: ThemeConstants.spacingMd),
                  Text(
                    'Pour toute question ou suggestion, n\'hésitez pas à nous contacter.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: ThemeConstants.spacingXl),

            // Copyright
            Text(
              '© 2024 BarApp. Tous droits réservés.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: ThemeConstants.spacingLg),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: ThemeConstants.spacingSm),
      child: Row(
        children: [
          const Icon(
            Icons.check_rounded,
            color: AppColors.success,
            size: ThemeConstants.iconSizeSm,
          ),
          const SizedBox(width: ThemeConstants.spacingSm),
          Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
