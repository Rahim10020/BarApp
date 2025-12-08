import 'package:flutter/material.dart';
import 'package:projet7/domain/entities/refrigerateur.dart';
import 'package:projet7/presentation/pages/refrigerateur/ajouter_boisson_refrigerateur_screen.dart';
import 'package:projet7/presentation/pages/refrigerateur/refrigerateur_detail_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/dialogs/app_dialogs.dart';

/// Item de liste moderne pour afficher un réfrigérateur
class RefrigerateurListItem extends StatelessWidget {
  final Refrigerateur refrigerateur;
  final BarAppProvider provider;

  const RefrigerateurListItem({
    super.key,
    required this.refrigerateur,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    final boissonTotal = refrigerateur.getBoissonTotal();

    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => RefrigerateurDetailScreen(
            refrigerateur: refrigerateur,
          ),
        ),
      ),
      child: Row(
        children: [
          // Icône avec fond coloré
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.coldDrink.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: const Icon(
              Icons.kitchen_rounded,
              color: AppColors.coldDrink,
              size: ThemeConstants.iconSizeLg,
            ),
          ),

          const SizedBox(width: ThemeConstants.spacingMd),

          // Informations
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom
                Text(
                  refrigerateur.nom,
                  style: Theme.of(context).textTheme.titleMedium,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: ThemeConstants.spacingXs),

                // Température et Boissons
                Flexible(
                  child: Row(
                    children: [
                      if (refrigerateur.temperature != null) ...[
                        const Icon(
                          Icons.thermostat_rounded,
                          size: ThemeConstants.iconSizeSm,
                          color: AppColors.coldDrink,
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '${refrigerateur.temperature}°C',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  color: AppColors.coldDrink,
                                  fontWeight: FontWeight.w600,
                                ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          ' • ',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                      const Icon(
                        Icons.local_drink_rounded,
                        size: ThemeConstants.iconSizeSm,
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '$boissonTotal boisson${boissonTotal > 1 ? 's' : ''}',
                          style: Theme.of(context).textTheme.bodySmall,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Actions
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Ajouter des boissons
              IconButton(
                icon: const Icon(
                  Icons.add_circle_rounded,
                  color: AppColors.success,
                  size: ThemeConstants.iconSizeMd,
                ),
                tooltip: 'Ajouter des boissons',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AjouterBoissonRefrigerateurScreen(
                      refrigerateur: refrigerateur,
                    ),
                  ),
                ),
              ),
              // Supprimer
              IconButton(
                icon: const Icon(
                  Icons.delete_rounded,
                  color: AppColors.error,
                  size: ThemeConstants.iconSizeMd,
                ),
                tooltip: 'Supprimer',
                onPressed: () async {
                  final confirmed = await AppDialogs.showDeleteDialog(
                    context,
                    title: 'Supprimer le réfrigérateur',
                    message:
                        'Voulez-vous vraiment supprimer ${refrigerateur.nom} ?',
                  );

                  if (confirmed == true && context.mounted) {
                    try {
                      await provider.deleteRefrigerateur(refrigerateur);
                      if (context.mounted) {
                        context.showSuccessSnackBar(
                            '${refrigerateur.nom} supprimé');
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
