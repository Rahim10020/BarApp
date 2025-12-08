import 'package:flutter/material.dart';
import 'package:projet7/domain/entities/ligne_vente.dart';
import 'package:projet7/presentation/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/core/utils/helpers.dart';

/// Écran de détail d'une ligne de vente
class LigneVenteDetailScreen extends StatelessWidget {
  final LigneVente ligneVente;

  const LigneVenteDetailScreen({super.key, required this.ligneVente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ligne de vente #${ligneVente.id}'),
      ),
      body: Padding(
        padding: ThemeConstants.pagePadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ID et Montant
            Row(
              children: [
                Expanded(
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.tag_rounded,
                              color: AppColors.primary,
                              size: ThemeConstants.iconSizeSm,
                            ),
                            const SizedBox(width: ThemeConstants.spacingXs),
                            Text(
                              'ID',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: ThemeConstants.spacingXs),
                        Text(
                          '#${ligneVente.id}',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: ThemeConstants.spacingMd),
                Expanded(
                  child: AppCard(
                    color: AppColors.revenue.withValues(alpha: 0.1),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(
                              Icons.payments_rounded,
                              color: AppColors.revenue,
                              size: ThemeConstants.iconSizeSm,
                            ),
                            const SizedBox(width: ThemeConstants.spacingXs),
                            Text(
                              'Montant',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: ThemeConstants.spacingXs),
                        Text(
                          Helpers.formatterEnCFA(ligneVente.getMontant()),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    color: AppColors.revenue,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: ThemeConstants.spacingLg),

            // Titre section Boisson
            Text(
              'Boisson',
              style: Theme.of(context).textTheme.titleLarge,
            ),

            const SizedBox(height: ThemeConstants.spacingMd),

            // Card Boisson
            AppCard(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => BoissonDetailScreen(
                    boisson: ligneVente.boisson,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(ThemeConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: AppColors.coldDrink.withValues(alpha: 0.1),
                      borderRadius:
                          BorderRadius.circular(ThemeConstants.radiusMd),
                    ),
                    child: const Icon(
                      Icons.local_bar_rounded,
                      color: AppColors.coldDrink,
                      size: ThemeConstants.iconSizeLg,
                    ),
                  ),
                  const SizedBox(width: ThemeConstants.spacingMd),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ligneVente.boisson.nom ?? 'Sans nom',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: ThemeConstants.spacingXs),
                        Text(
                          Helpers.formatterEnCFA(ligneVente.boisson.prix.last),
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.revenue,
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
