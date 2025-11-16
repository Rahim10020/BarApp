import 'package:flutter/material.dart';
import 'package:projet7/models/modele.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/inputs/app_text_field.dart';

/// Formulaire moderne pour ajouter une boisson
class BoissonForm extends StatefulWidget {
  final BarAppProvider provider;
  final TextEditingController nomController;
  final TextEditingController prixController;
  final TextEditingController descriptionController;
  final Modele? selectedModele;
  final Function(Modele?) onModeleChanged;
  final Function() onAjouterBoisson;
  final Function() onResetForm;

  const BoissonForm({
    super.key,
    required this.provider,
    required this.nomController,
    required this.prixController,
    required this.descriptionController,
    required this.selectedModele,
    required this.onModeleChanged,
    required this.onAjouterBoisson,
    required this.onResetForm,
  });

  @override
  State<BoissonForm> createState() => _BoissonFormState();
}

class _BoissonFormState extends State<BoissonForm> {
  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: const Icon(
                  Icons.add_box_rounded,
                  color: AppColors.primary,
                  size: ThemeConstants.iconSizeMd,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingMd),
              Text(
                'Ajouter une boisson',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Nom et Prix (ligne)
          Row(
            children: [
              Expanded(
                child: AppTextField(
                  controller: widget.nomController,
                  label: 'Nom',
                  hint: 'Ex: Coca-Cola',
                  prefixIcon: Icons.local_bar_rounded,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingMd),
              Expanded(
                child: AppNumberField(
                  controller: widget.prixController,
                  label: 'Prix (FCFA)',
                  hint: '500',
                  prefixIcon: Icons.payments_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Description
          AppTextField(
            controller: widget.descriptionController,
            label: 'Description (optionnel)',
            hint: 'Décrivez la boisson...',
            maxLines: 2,
            prefixIcon: Icons.description_rounded,
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Modèle (Dropdown)
          AppDropdown<Modele>(
            value: widget.selectedModele,
            label: 'Modèle',
            hint: 'Sélectionnez le modèle',
            prefixIcon: Icons.category_rounded,
            items: Modele.values.map((modele) {
              return DropdownMenuItem(
                value: modele,
                child: Text(modele == Modele.petit ? 'Petit' : 'Grand'),
              );
            }).toList(),
            onChanged: widget.onModeleChanged,
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Bouton Ajouter
          AppButton.primary(
            text: 'Ajouter la boisson',
            icon: Icons.add_circle_rounded,
            isFullWidth: true,
            onPressed: widget.onAjouterBoisson,
          ),
        ],
      ),
    );
  }
}
