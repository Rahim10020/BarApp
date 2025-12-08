import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/ui/widgets/inputs/app_text_field.dart';
import 'package:provider/provider.dart';

/// Écran pour ajouter un nouveau casier
class AjouterCasierScreen extends StatefulWidget {
  const AjouterCasierScreen({super.key});

  @override
  State<AjouterCasierScreen> createState() => _AjouterCasierScreenState();
}

class _AjouterCasierScreenState extends State<AjouterCasierScreen> {
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
        Navigator.of(context).pop(true); // Retourner true pour indiquer succès
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
      return Scaffold(
        appBar: AppBar(
          title: const Text('Ajouter un casier'),
          centerTitle: true,
        ),
        body: Center(
          child: AppCard(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un casier'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth > 600
                ? ThemeConstants.maxWidthForm
                : constraints.maxWidth - ThemeConstants.pagePadding.horizontal;

            return Center(
              child: SingleChildScrollView(
                padding: ThemeConstants.pagePadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      final offset = (1 - value) * 24;
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, offset),
                          child: child,
                        ),
                      );
                    },
                    child: AppCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Titre
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(
                                    ThemeConstants.spacingSm),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                      ThemeConstants.radiusMd),
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
                              separatorBuilder: (_, __) => const SizedBox(
                                  width: ThemeConstants.spacingSm),
                              itemBuilder: (context, index) {
                                final boisson = provider.boissons[index];
                                final isSelected =
                                    _boissonSelectionnee?.id == boisson.id;

                                return GestureDetector(
                                  onTap: () => setState(
                                      () => _boissonSelectionnee = boisson),
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
                                      borderRadius: BorderRadius.circular(
                                          ThemeConstants.radiusMd),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          boisson.nom ?? 'Sans nom',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: isSelected
                                                    ? Colors.white
                                                    : null,
                                                fontWeight: isSelected
                                                    ? FontWeight.bold
                                                    : null,
                                              ),
                                        ),
                                        Text(
                                          boisson.modele?.name ?? '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: isSelected
                                                    ? Colors.white
                                                        .withValues(alpha: 0.9)
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
                            size: AppButtonSize.small,
                            isFullWidth: true,
                            onPressed: () => _ajouterCasier(provider),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
