import 'package:flutter/material.dart';
import 'package:projet7/domain/entities/modele.dart';
import 'package:projet7/presentation/pages/detail/boisson/boisson_import_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/buttons/app_button.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/inputs/app_text_field.dart';

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
          // En-tête avec icône
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: const Icon(
                  Icons.local_drink_rounded,
                  color: AppColors.primary,
                  size: ThemeConstants.iconSizeMd,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nouvelle Boisson',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: ThemeConstants.spacingXs),
                    Text(
                      'Ajoutez une boisson à votre catalogue',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textSecondary,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacingLg),

          // Divider
          const Divider(height: 1),

          const SizedBox(height: ThemeConstants.spacingLg),

          // Section Informations de base
          Text(
            'Informations de base',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          // Nom
          AppTextField(
            controller: widget.nomController,
            label: 'Nom de la boisson',
            hint: 'Ex: Coca-Cola',
            prefixIcon: Icons.label_rounded,
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Prix
          AppNumberField(
            controller: widget.prixController,
            label: 'Prix unitaire (FCFA)',
            hint: 'Ex: 500',
            prefixIcon: Icons.payments_rounded,
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Description
          AppTextField(
            controller: widget.descriptionController,
            label: 'Description (optionnel)',
            hint: 'Décrivez la boisson...',
            maxLines: 3,
            prefixIcon: Icons.description_rounded,
          ),

          const SizedBox(height: ThemeConstants.spacingLg),

          // Section Catégorie
          Text(
            'Catégorie',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: ThemeConstants.spacingSm),
          Text(
            'Sélectionnez le format de la boisson',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          // Sélecteur de modèle avec amélioration visuelle
          Row(
            children: [
              Expanded(
                child: _buildModeleCard(
                  context: context,
                  modele: Modele.petit,
                  label: 'Petit',
                  icon: Icons.local_drink_outlined,
                  description: 'Format réduit',
                  isSelected: widget.selectedModele == Modele.petit,
                  onTap: () => widget.onModeleChanged(Modele.petit),
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingMd),
              Expanded(
                child: _buildModeleCard(
                  context: context,
                  modele: Modele.grand,
                  label: 'Grand',
                  icon: Icons.local_drink_rounded,
                  description: 'Format standard',
                  isSelected: widget.selectedModele == Modele.grand,
                  onTap: () => widget.onModeleChanged(Modele.grand),
                ),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacingXl),

          // Divider
          const Divider(height: 1),

          const SizedBox(height: ThemeConstants.spacingLg),

          // Bouton Ajouter
          AppButton.primary(
            text: 'Ajouter la boisson',
            icon: Icons.add_circle_rounded,
            size: AppButtonSize.medium,
            isFullWidth: true,
            onPressed: widget.onAjouterBoisson,
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Bouton Importer (secondaire)
          AppButton.secondary(
            text: 'Ou importer depuis un fichier',
            icon: Icons.upload_file_rounded,
            size: AppButtonSize.medium,
            isFullWidth: true,
            onPressed: () async {
              final result = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const BoissonImportScreen(),
                ),
              );

              if (result == true) {
                // Les boissons ont été importées
                widget.onResetForm();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildModeleCard({
    required BuildContext context,
    required Modele modele,
    required String label,
    required IconData icon,
    required String description,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        child: AnimatedContainer(
          duration: ThemeConstants.animationFast,
          padding: const EdgeInsets.all(ThemeConstants.spacingMd),
          decoration: BoxDecoration(
            gradient: isSelected
                ? const LinearGradient(
                    colors: [
                      AppColors.primary,
                      AppColors.primaryDark,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: isSelected
                ? null
                : Theme.of(context).colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : Theme.of(context).dividerColor,
              width: isSelected ? 2 : 1,
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: isSelected ? Colors.white : AppColors.primary,
              ),
              const SizedBox(height: ThemeConstants.spacingSm),
              Text(
                label,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: isSelected ? Colors.white : null,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.w500,
                    ),
              ),
              const SizedBox(height: ThemeConstants.spacingXs),
              Text(
                description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : AppColors.textSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
