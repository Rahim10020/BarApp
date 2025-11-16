import 'package:flutter/material.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/vente/vente_detail_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/utils/helpers.dart';

/// Item de liste moderne pour afficher une vente
class VenteListItem extends StatelessWidget {
  final Vente vente;
  final BarAppProvider provider;

  const VenteListItem({
    super.key,
    required this.vente,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => VenteDetailScreen(vente: vente),
        ),
      ),
      child: Row(
        children: [
          // Icône avec fond coloré
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.revenue.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.revenue,
              size: ThemeConstants.iconSizeLg,
            ),
          ),

          const SizedBox(width: ThemeConstants.spacingMd),

          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID et montant
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spacingSm,
                        vertical: ThemeConstants.spacingXs,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(ThemeConstants.radiusSm),
                      ),
                      child: Text(
                        '#${vente.id}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(width: ThemeConstants.spacingSm),
                    Expanded(
                      child: Text(
                        Helpers.formatterEnCFA(vente.montantTotal),
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: AppColors.revenue,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: ThemeConstants.spacingXs),

                // Date
                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today_rounded,
                      size: ThemeConstants.iconSizeSm,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: ThemeConstants.spacingXs),
                    Text(
                      Helpers.formatterDate(vente.dateVente),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Bouton supprimer
          IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              color: AppColors.error,
              size: ThemeConstants.iconSizeMd,
            ),
            onPressed: () async {
              final confirmed = await AppDialogs.showDeleteDialog(
                context,
                title: 'Supprimer la vente',
                message:
                    'Voulez-vous vraiment supprimer la vente #${vente.id} ?',
              );

              if (confirmed == true && context.mounted) {
                try {
                  await provider.deleteVente(vente);
                  if (context.mounted) {
                    context.showSuccessSnackBar('Vente #${vente.id} supprimée');
                  }
                } catch (e) {
                  if (context.mounted) {
                    context.showErrorSnackBar('Erreur: ${e.toString()}');
                  }
                }
              }
            },
          ),
        ],
      ),
    );
  }
}
