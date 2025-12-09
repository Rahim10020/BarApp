import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet7/domain/entities/boisson.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/buttons/app_button.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/inputs/app_text_field.dart';

/// Formulaire moderne pour ajouter un casier
class CasierForm extends StatefulWidget {
  final BarAppProvider provider;
  final TextEditingController quantiteController;
  final Boisson? boissonSelectionnee;
  final Function(Boisson) onBoissonSelected;
  final Function() onAjouterCasier;

  const CasierForm({
    super.key,
    required this.provider,
    required this.quantiteController,
    required this.boissonSelectionnee,
    required this.onBoissonSelected,
    required this.onAjouterCasier,
  });

  @override
  State<CasierForm> createState() => _CasierFormState();
}

class _CasierFormState extends State<CasierForm> {
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
                child: SvgPicture.asset(
                  'assets/icons/casier.svg',
                  width: ThemeConstants.iconSizeMd,
                  height: ThemeConstants.iconSizeMd,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Nouveau Casier',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: ThemeConstants.spacingXs),
                    Text(
                      'Ajoutez un casier de boissons',
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

          // Section Quantité
          Text(
            'Informations du casier',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          AppNumberField(
            controller: widget.quantiteController,
            label: 'Quantité de boissons',
            hint: 'Ex: 24',
            prefixIcon: Icons.format_list_numbered_rounded,
          ),

          const SizedBox(height: ThemeConstants.spacingLg),

          // Section Type de boisson
          Text(
            'Type de boisson',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: ThemeConstants.spacingSm),
          Text(
            'Sélectionnez le modèle de boisson pour ce casier',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                ),
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          // Sélecteur de boisson avec amélioration
          SizedBox(
            height: 80,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.provider.boissons.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(width: ThemeConstants.spacingSm),
              itemBuilder: (context, index) {
                final boisson = widget.provider.boissons[index];
                final isSelected =
                    widget.boissonSelectionnee?.id == boisson.id;

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => widget.onBoissonSelected(boisson),
                    borderRadius:
                        BorderRadius.circular(ThemeConstants.radiusMd),
                    child: AnimatedContainer(
                      duration: ThemeConstants.animationFast,
                      padding: const EdgeInsets.symmetric(
                        horizontal: ThemeConstants.spacingMd,
                        vertical: ThemeConstants.spacingSm,
                      ),
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
                            : Theme.of(context)
                                .colorScheme
                                .surfaceContainerHighest,
                        borderRadius:
                            BorderRadius.circular(ThemeConstants.radiusMd),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Theme.of(context).dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                ),
                              ]
                            : null,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.local_drink_rounded,
                                size: 16,
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.primary,
                              ),
                              const SizedBox(width: ThemeConstants.spacingXs),
                              Text(
                                boisson.nom ?? 'Sans nom',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                      color: isSelected ? Colors.white : null,
                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.w500,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: ThemeConstants.spacingXs),
                          Text(
                            boisson.modele?.name ?? '',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: isSelected
                                          ? Colors.white.withValues(alpha: 0.9)
                                          : AppColors.textSecondary,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: ThemeConstants.spacingXl),

          // Divider
          const Divider(height: 1),

          const SizedBox(height: ThemeConstants.spacingLg),

          // Bouton Créer
          AppButton.primary(
            text: 'Ajoutez le casier',
            icon: Icons.add_box_rounded,
            size: AppButtonSize.medium,
            isFullWidth: true,
            onPressed: widget.onAjouterCasier,
          ),
        ],
      ),
    );
  }
}

