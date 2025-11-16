import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';
import 'package:projet7/pages/detail/boisson/components/boisson_form.dart';
import 'package:projet7/pages/detail/boisson/components/boisson_list_item.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:provider/provider.dart';

/// Écran de gestion des boissons
class BoissonScreen extends StatefulWidget {
  const BoissonScreen({super.key});

  @override
  State<BoissonScreen> createState() => _BoissonScreenState();
}

class _BoissonScreenState extends State<BoissonScreen> {
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();
  final _descriptionController = TextEditingController();
  Modele? _modele;

  @override
  void dispose() {
    _nomController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _ajouterBoisson(BarAppProvider provider) async {
    // Validation
    if (_nomController.text.trim().isEmpty) {
      context.showWarningSnackBar('Veuillez renseigner le nom');
      return;
    }

    if (_prixController.text.trim().isEmpty) {
      context.showWarningSnackBar('Veuillez renseigner le prix');
      return;
    }

    if (_modele == null) {
      context.showWarningSnackBar('Veuillez choisir le modèle');
      return;
    }

    // Vérifier que le prix est valide
    final prix = double.tryParse(_prixController.text.trim());
    if (prix == null || prix <= 0) {
      context.showErrorSnackBar('Le prix doit être un nombre positif');
      return;
    }

    try {
      final boisson = Boisson(
        id: await provider.generateUniqueId("Boisson"),
        nom: _nomController.text.trim(),
        prix: [prix],
        estFroid: false,
        modele: _modele,
        description: _descriptionController.text.trim().isNotEmpty
            ? _descriptionController.text.trim()
            : null,
      );

      await provider.addBoisson(boisson);

      if (mounted) {
        _resetForm();
        context.showSuccessSnackBar('${boisson.nom} ajoutée avec succès');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Erreur: ${e.toString()}');
      }
    }
  }

  void _resetForm() {
    _nomController.clear();
    _prixController.clear();
    _descriptionController.clear();
    setState(() => _modele = null);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    return Padding(
      padding: ThemeConstants.pagePadding,
      child: Column(
        children: [
          BoissonForm(
            provider: provider,
            nomController: _nomController,
            prixController: _prixController,
            descriptionController: _descriptionController,
            selectedModele: _modele,
            onModeleChanged: (value) => setState(() => _modele = value),
            onAjouterBoisson: () => _ajouterBoisson(provider),
            onResetForm: _resetForm,
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Liste des boissons
          Expanded(
            child: provider.boissons.isEmpty
                ? Center(
                    child: AppCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_bar_outlined,
                            size: ThemeConstants.iconSize3Xl,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: ThemeConstants.spacingMd),
                          Text(
                            'Aucune boisson',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: ThemeConstants.spacingXs),
                          Text(
                            'Ajoutez votre première boisson ci-dessus',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: provider.boissons.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: ThemeConstants.spacingSm),
                    itemBuilder: (context, index) {
                      final boisson = provider.boissons[index];
                      return BoissonListItem(
                        boisson: boisson,
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
