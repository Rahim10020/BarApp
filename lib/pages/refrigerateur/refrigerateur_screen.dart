import 'package:flutter/material.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/pages/refrigerateur/components/refrigerateur_form.dart';
import 'package:projet7/pages/refrigerateur/components/refrigerateur_list_item.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:provider/provider.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';

/// Écran de gestion des réfrigérateurs
class RefrigerateurScreen extends StatefulWidget {
  const RefrigerateurScreen({super.key});

  @override
  State<RefrigerateurScreen> createState() => _RefrigerateurScreenState();
}

class _RefrigerateurScreenState extends State<RefrigerateurScreen> {
  final _nomController = TextEditingController();
  final _tempController = TextEditingController();

  @override
  void dispose() {
    _nomController.dispose();
    _tempController.dispose();
    super.dispose();
  }

  Future<void> _ajouterRefrigerateur(BarAppProvider provider) async {
    // Validation
    if (_nomController.text.trim().isEmpty) {
      context.showWarningSnackBar('Veuillez renseigner le nom');
      return;
    }

    if (_tempController.text.trim().isEmpty) {
      context.showWarningSnackBar('Veuillez renseigner la température');
      return;
    }

    // Vérifier que la température est valide
    final temperature = double.tryParse(_tempController.text.trim());
    if (temperature == null) {
      context.showErrorSnackBar('La température doit être un nombre valide');
      return;
    }

    try {
      final refrigerateur = Refrigerateur(
        id: await provider.generateUniqueId("Refrigerateur"),
        nom: _nomController.text.trim(),
        temperature: temperature,
      );

      await provider.addRefrigerateur(refrigerateur);

      if (mounted) {
        _resetForm();
        context.showSuccessSnackBar('${refrigerateur.nom} ajouté avec succès');
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar('Erreur: ${e.toString()}');
      }
    }
  }

  void _resetForm() {
    _nomController.clear();
    _tempController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    return Padding(
      padding: ThemeConstants.pagePadding,
      child: Column(
        children: [
          RefrigerateurForm(
            provider: provider,
            nomController: _nomController,
            tempController: _tempController,
            onAjouterRefrigerateur: () => _ajouterRefrigerateur(provider),
            onResetForm: _resetForm,
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Liste des réfrigérateurs
          Expanded(
            child: provider.refrigerateurs.isEmpty
                ? Center(
                    child: AppCard(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.kitchen_outlined,
                            size: ThemeConstants.iconSize3Xl,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(height: ThemeConstants.spacingMd),
                          Text(
                            'Aucun réfrigérateur',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: ThemeConstants.spacingXs),
                          Text(
                            'Ajoutez votre premier réfrigérateur ci-dessus',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: provider.refrigerateurs.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: ThemeConstants.spacingSm),
                    itemBuilder: (context, index) {
                      final refrigerateur = provider.refrigerateurs[index];
                      return RefrigerateurListItem(
                        refrigerateur: refrigerateur,
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
