import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet7/domain/entities/casier.dart';
import 'package:projet7/presentation/pages/detail/casier/ajouter_casier_screen.dart';
import 'package:projet7/presentation/pages/detail/casier/casier_detail_screen.dart';
import 'package:projet7/presentation/pages/detail/casier/modifier_casier_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/core/utils/helpers.dart';
import 'package:provider/provider.dart';

/// Écran de gestion des casiers
class CasierScreen extends StatefulWidget {
  const CasierScreen({super.key});

  @override
  State<CasierScreen> createState() => _CasierScreenState();
}

class _CasierScreenState extends State<CasierScreen> {
  Future<void> _navigateToAjouterCasier() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AjouterCasierScreen()),
    );

    if (result == true && mounted) {
      // Le casier a été ajouté avec succès
      // Le provider se mettra à jour automatiquement
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    return Scaffold(
      body: Padding(
        padding: ThemeConstants.pagePadding,
        child: Column(
          children: [
            // Liste des casiers
            Expanded(
              child: provider.casiers.isEmpty
                  ? Center(
                      child: AppCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/casier.svg',
                              width: ThemeConstants.iconSizeMd,
                              height: ThemeConstants.iconSizeMd,
                            ),
                            const SizedBox(height: ThemeConstants.spacingMd),
                            Text(
                              'Aucun casier',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: ThemeConstants.spacingXs),
                            Text(
                              'Appuyez sur le bouton + pour ajouter un casier',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: provider.casiers.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: ThemeConstants.spacingSm),
                      itemBuilder: (context, index) {
                        final casier = provider.casiers[index];
                        return _CasierListItem(
                          casier: casier,
                          provider: provider,
                          onDelete: () async {
                            final confirmed = await AppDialogs.showDeleteDialog(
                              context,
                              title: 'Supprimer le casier',
                              message:
                                  'Voulez-vous vraiment supprimer ce casier ?',
                            );

                            if (confirmed == true && context.mounted) {
                              try {
                                await provider.deleteCasier(casier);
                                if (context.mounted) {
                                  context.showSuccessSnackBar(
                                      'Casier #${casier.id} supprimé');
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  context.showErrorSnackBar(
                                      'Erreur: ${e.toString()}');
                                }
                              }
                            }
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAjouterCasier,
        icon: const Icon(Icons.add),
        label: const SizedBox.shrink(),
        heroTag: 'ajouter-casier',
      ),
    );
  }
}

/// Item de liste pour un casier
class _CasierListItem extends StatelessWidget {
  final Casier casier;
  final BarAppProvider provider;
  final VoidCallback onDelete;

  const _CasierListItem({
    required this.casier,
    required this.provider,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CasierDetailScreen(casier: casier),
        ),
      ),
      child: Row(
        children: [
          // Icône
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingMd),
            child: SvgPicture.asset(
              'assets/icons/casier.svg',
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
                // ID et Boisson
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spacingXs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(ThemeConstants.radiusSm),
                      ),
                      child: Text(
                        '#${casier.id}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    const SizedBox(width: ThemeConstants.spacingXs),
                    Flexible(
                      child: Text(
                        '${casier.boissons.first.nom} (${casier.boissons.first.modele?.name})',
                        style: Theme.of(context).textTheme.titleMedium,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: ThemeConstants.spacingXs),
                // Prix et Quantité
                Row(
                  children: [
                    Text(
                      Helpers.formatterEnCFA(casier.getPrixTotal()),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.revenue,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      ' • ${casier.boissonTotal} unités',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Menu d'actions
          PopupMenuButton<String>(
            icon: const Icon(
              Icons.more_vert,
              color: AppColors.textSecondary,
              size: ThemeConstants.iconSizeMd,
            ),
            onSelected: (value) {
              if (value == 'edit') {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifierCasierScreen(casier: casier),
                  ),
                );
              } else if (value == 'delete') {
                onDelete();
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
