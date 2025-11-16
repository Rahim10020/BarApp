import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/pages/detail/boisson/modifier_boisson_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/utils/helpers.dart';

/// Item de liste moderne pour afficher une boisson
class BoissonListItem extends StatelessWidget {
  final Boisson boisson;
  final BarAppProvider provider;

  const BoissonListItem({
    super.key,
    required this.boisson,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BoissonDetailScreen(boisson: boisson),
        ),
      ),
      child: Row(
        children: [
          // Icône avec fond coloré
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingMd),
            decoration: BoxDecoration(
              color: boisson.estFroid
                  ? AppColors.coldDrink.withOpacity(0.1)
                  : AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              boisson.estFroid
                  ? Icons.ac_unit_rounded
                  : Icons.local_bar_rounded,
              color: boisson.estFroid ? AppColors.coldDrink : AppColors.primary,
              size: ThemeConstants.iconSizeLg,
            ),
          ),

          const SizedBox(width: ThemeConstants.spacingMd),

          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom et Modèle
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        boisson.nom ?? 'Sans nom',
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: ThemeConstants.spacingXs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spacingXs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(ThemeConstants.radiusSm),
                      ),
                      child: Text(
                        boisson.modele?.name ?? '',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.info,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ThemeConstants.spacingXs),

                // Prix
                Text(
                  Helpers.formatterEnCFA(boisson.prix.last),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.revenue,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(
                  Icons.edit_rounded,
                  color: AppColors.info,
                  size: ThemeConstants.iconSizeMd,
                ),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifierBoissonScreen(
                      boisson: boisson,
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete_rounded,
                  color: AppColors.error,
                  size: ThemeConstants.iconSizeMd,
                ),
                onPressed: () async {
                  final confirmed = await AppDialogs.showDeleteDialog(
                    context,
                    title: 'Supprimer la boisson',
                    message: 'Voulez-vous vraiment supprimer ${boisson.nom} ?',
                  );

                  if (confirmed == true && context.mounted) {
                    try {
                      await provider.deleteBoisson(boisson);
                      if (context.mounted) {
                        context.showSuccessSnackBar('${boisson.nom} supprimée');
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
        ],
      ),
    );
  }
}
