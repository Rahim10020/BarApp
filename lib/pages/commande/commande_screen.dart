import 'package:flutter/material.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/pages/commande/ajouter_commande_screen.dart';
import 'package:projet7/pages/commande/commande_detail_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

/// Écran de gestion des commandes
class CommandeScreen extends StatefulWidget {
  const CommandeScreen({super.key});

  @override
  State<CommandeScreen> createState() => _CommandeScreenState();
}

class _CommandeScreenState extends State<CommandeScreen> {
  Future<void> _navigateToAjouterCommande() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AjouterCommandeScreen()),
    );

    if (result == true && mounted) {
      // La commande a été ajoutée avec succès
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
            // Liste des commandes
            Expanded(
              child: provider.commandes.isEmpty
                  ? Center(
                      child: AppCard(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.receipt_long_outlined,
                              size: ThemeConstants.iconSize3Xl,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(height: ThemeConstants.spacingMd),
                            Text(
                              'Aucune commande',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            const SizedBox(height: ThemeConstants.spacingXs),
                            Text(
                              'Appuyez sur le bouton + pour ajouter une commande',
                              style: Theme.of(context).textTheme.bodySmall,
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    )
                  : ListView.separated(
                      itemCount: provider.commandes.length,
                      separatorBuilder: (_, __) =>
                          const SizedBox(height: ThemeConstants.spacingSm),
                      itemBuilder: (context, index) {
                        final commande = provider.commandes[index];
                        return _CommandeListItem(
                          commande: commande,
                          provider: provider,
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAjouterCommande,
        icon: const Icon(Icons.add),
        label: const Text('Ajouter'),
        heroTag: 'ajouter-commande',
      ),
    );
  }
}

/// Item de liste pour une commande
class _CommandeListItem extends StatelessWidget {
  final Commande commande;
  final BarAppProvider provider;

  const _CommandeListItem({
    required this.commande,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => CommandeDetailScreen(commande: commande),
        ),
      ),
      child: Row(
        children: [
          // Icône
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingMd),
            decoration: BoxDecoration(
              color: AppColors.expense.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: AppColors.expense,
              size: ThemeConstants.iconSizeLg,
            ),
          ),

          const SizedBox(width: ThemeConstants.spacingMd),

          // Informations
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ID et Fournisseur
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
                        '#${commande.id}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    if (commande.fournisseur != null) ...[
                      const SizedBox(width: ThemeConstants.spacingXs),
                      Flexible(
                        child: Text(
                          commande.fournisseur!.nom,
                          style: Theme.of(context).textTheme.titleMedium,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: ThemeConstants.spacingXs),

                // Montant et Date
                Row(
                  children: [
                    Text(
                      Helpers.formatterEnCFA(commande.montantTotal),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.expense,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    Text(
                      ' • ${Helpers.formatterDate(commande.dateCommande)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Action Supprimer
          IconButton(
            icon: const Icon(
              Icons.delete_rounded,
              color: AppColors.error,
              size: ThemeConstants.iconSizeMd,
            ),
            onPressed: () async {
              final confirmed = await AppDialogs.showDeleteDialog(
                context,
                title: 'Supprimer la commande',
                message:
                    'Voulez-vous vraiment supprimer la commande #${commande.id} ?',
              );

              if (confirmed == true && context.mounted) {
                try {
                  await provider.deleteCommande(commande);
                  if (context.mounted) {
                    context.showSuccessSnackBar(
                        'Commande #${commande.id} supprimée');
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
