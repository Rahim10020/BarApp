import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/pages/detail/casier/casier_detail_screen.dart';
import 'package:projet7/pages/detail/casier/modifier_casier_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/ui/widgets/inputs/app_text_field.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

/// Écran de gestion des casiers
class CasierScreen extends StatefulWidget {
  const CasierScreen({super.key});

  @override
  State<CasierScreen> createState() => _CasierScreenState();
}

class _CasierScreenState extends State<CasierScreen> {
  final _quantiteController = TextEditingController();
  Boisson? _boissonSelectionnee;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BarAppProvider>(context, listen: false);
    if (provider.boissons.isNotEmpty) {
      _boissonSelectionnee = provider.boissons[0];
    }
  }

  @override
  void dispose() {
    _quantiteController.dispose();
    super.dispose();
  }

  Future<void> _ajouterCasier(BarAppProvider provider) async {
    // Validation
    if (_boissonSelectionnee == null) {
      context.showWarningSnackBar('Aucune boisson disponible');
      return;
    }

    if (_quantiteController.text.trim().isEmpty) {
      context.showWarningSnackBar('Veuillez préciser la quantité');
      return;
    }

    final quantite = int.tryParse(_quantiteController.text.trim());
    if (quantite == null || quantite <= 0) {
      context.showErrorSnackBar('La quantité doit être un nombre positif');
      return;
    }

    try {
      // Créer les boissons pour le casier
      List<Boisson> boissons = [];
      for (int i = 0; i < quantite; i++) {
        final newId = await provider.generateUniqueId("Boisson");
        boissons.add(
          Boisson(
            id: newId,
            nom: _boissonSelectionnee!.nom,
            prix: List.from(_boissonSelectionnee!.prix),
            estFroid: _boissonSelectionnee!.estFroid,
            modele: _boissonSelectionnee!.modele,
            description: _boissonSelectionnee!.description,
          ),
        );
      }

      final casier = Casier(
        id: await provider.generateUniqueId("Casier"),
        boissonTotal: quantite,
        boissons: boissons,
      );

      await provider.addCasier(casier);

      if (mounted) {
        _quantiteController.clear();
        context.showSuccessSnackBar('Casier créé avec succès');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Erreur: ${e.toString()}');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    // Si aucune boisson, afficher message
    if (provider.boissons.isEmpty) {
      return Center(
        child: AppCard(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.inventory_outlined,
                size: ThemeConstants.iconSize3Xl,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: ThemeConstants.spacingMd),
              Text(
                'Aucune boisson disponible',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: ThemeConstants.spacingXs),
              Text(
                'Créez des boissons avant de créer des casiers',
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: ThemeConstants.pagePadding,
      child: Column(
        children: [
          // Formulaire de création
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Titre
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius:
                            BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: const Icon(
                        Icons.inventory_2_rounded,
                        color: AppColors.primary,
                        size: ThemeConstants.iconSizeMd,
                      ),
                    ),
                    const SizedBox(width: ThemeConstants.spacingMd),
                    Text(
                      'Nouveau Casier',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),

                const SizedBox(height: ThemeConstants.spacingMd),

                // Quantité
                AppNumberField(
                  controller: _quantiteController,
                  label: 'Quantité de boissons',
                  hint: '24',
                  prefixIcon: Icons.numbers_rounded,
                ),

                const SizedBox(height: ThemeConstants.spacingMd),

                // Sélecteur de boisson
                Text(
                  'Type de boisson',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: ThemeConstants.spacingSm),

                SizedBox(
                  height: 60,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: provider.boissons.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(width: ThemeConstants.spacingSm),
                    itemBuilder: (context, index) {
                      final boisson = provider.boissons[index];
                      final isSelected = _boissonSelectionnee?.id == boisson.id;

                      return GestureDetector(
                        onTap: () =>
                            setState(() => _boissonSelectionnee = boisson),
                        child: AnimatedContainer(
                          duration: ThemeConstants.animationFast,
                          padding: const EdgeInsets.symmetric(
                            horizontal: ThemeConstants.spacingMd,
                            vertical: ThemeConstants.spacingSm,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary
                                : Theme.of(context)
                                    .colorScheme
                                    .surfaceContainerHighest,
                            borderRadius:
                                BorderRadius.circular(ThemeConstants.radiusMd),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.primary
                                  : Theme.of(context).dividerColor,
                              width: isSelected
                                  ? ThemeConstants.borderWidthMedium
                                  : ThemeConstants.borderWidthThin,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                boisson.nom ?? 'Sans nom',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: isSelected ? Colors.white : null,
                                      fontWeight:
                                          isSelected ? FontWeight.bold : null,
                                    ),
                              ),
                              Text(
                                boisson.modele?.name ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: isSelected
                                          ? Colors.white.withOpacity(0.9)
                                          : AppColors.textSecondary,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: ThemeConstants.spacingMd),

                // Bouton Créer
                AppButton.primary(
                  text: 'Créer le casier',
                  icon: Icons.add_box_rounded,
                  isFullWidth: true,
                  onPressed: () => _ajouterCasier(provider),
                ),
              ],
            ),
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Liste des casiers
          Expanded(
            child: provider.casiers.isEmpty
                ? Center(
                    child: AppCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inventory_outlined,
                            size: ThemeConstants.iconSize3Xl,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: ThemeConstants.spacingMd),
                          Text(
                            'Aucun casier',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: ThemeConstants.spacingXs),
                          Text(
                            'Créez votre premier casier ci-dessus',
                            style: Theme.of(context).textTheme.bodySmall,
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
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Item de liste pour un casier
class _CasierListItem extends StatelessWidget {
  final Casier casier;
  final BarAppProvider provider;

  const _CasierListItem({
    required this.casier,
    required this.provider,
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
            decoration: BoxDecoration(
              color: AppColors.stockAvailable.withOpacity(0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: const Icon(
              Icons.inventory_2_rounded,
              color: AppColors.stockAvailable,
              size: ThemeConstants.iconSizeLg,
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
                        color: AppColors.primary.withOpacity(0.1),
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
                    builder: (context) => ModifierCasierScreen(casier: casier),
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
                    title: 'Supprimer le casier',
                    message: 'Voulez-vous vraiment supprimer ce casier ?',
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
