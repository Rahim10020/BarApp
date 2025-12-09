import 'package:flutter/material.dart';
import 'package:projet7/domain/entities/boisson.dart';
import 'package:projet7/domain/entities/casier.dart';
import 'package:projet7/presentation/pages/detail/casier/components/casier_form.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/dialogs/app_dialogs.dart';
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
        ),
        body: Center(
          child: Padding(
            padding: ThemeConstants.pagePadding,
            child: AppCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(ThemeConstants.spacingMd),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.inventory_2_rounded,
                      color: AppColors.warning,
                      size: 48,
                    ),
                  ),
                  const SizedBox(height: ThemeConstants.spacingLg),
                  Text(
                    'Aucune boisson disponible',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: ThemeConstants.spacingSm),
                  Text(
                    'Ajoutez des boissons avant d\'ajouter des casiers',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ajouter un casier'),
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
                    child: CasierForm(
                      provider: provider,
                      quantiteController: _quantiteController,
                      boissonSelectionnee: _boissonSelectionnee,
                      onBoissonSelected: (boisson) {
                        setState(() => _boissonSelectionnee = boisson);
                      },
                      onAjouterCasier: () => _ajouterCasier(provider),
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
