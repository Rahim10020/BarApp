import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet7/domain/entities/boisson.dart';
import 'package:projet7/presentation/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/presentation/pages/detail/boisson/modifier_boisson_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/core/utils/helpers.dart';

/// Item de liste moderne pour afficher une boisson
class BoissonListItem extends StatelessWidget {
  final Boisson boisson;
  final BarAppProvider provider;

  const BoissonListItem({
    super.key,
    required this.boisson,
    required this.provider,
  });

  Future<void> _handleDelete(BuildContext context) async {
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
  }

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
            child: SvgPicture.asset(
              Helpers.getBoissonIconPath(boisson.nom),
              width: ThemeConstants.iconSizeLg,
              height: ThemeConstants.iconSizeLg,
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
                        color: AppColors.info.withValues(alpha: 0.1),
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

          // Menu d'actions
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_horiz,
              color: AppColors.textSecondary,
              size: ThemeConstants.iconSizeMd,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifierBoissonScreen(
                      boisson: boisson,
                    ),
                  ),
                );
              } else if (value == 'delete') {
                _handleDelete(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem<String>(
                value: 'edit',
                child: Row(
                  children: [
                    const Icon(
                      Icons.edit_rounded,
                      color: AppColors.info,
                      size: ThemeConstants.iconSizeSm,
                    ),
                    const SizedBox(width: ThemeConstants.spacingSm),
                    Text(
                      'Modifier',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'delete',
                child: Row(
                  children: [
                    const Icon(
                      Icons.delete_rounded,
                      color: AppColors.error,
                      size: ThemeConstants.iconSizeSm,
                    ),
                    const SizedBox(width: ThemeConstants.spacingSm),
                    Text(
                      'Supprimer',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.error,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
