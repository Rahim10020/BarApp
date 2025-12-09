import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/buttons/app_button.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';
import 'package:projet7/presentation/widgets/inputs/app_text_field.dart';

/// Formulaire moderne pour ajouter un réfrigérateur
class RefrigerateurForm extends StatefulWidget {
  final BarAppProvider provider;
  final TextEditingController nomController;
  final TextEditingController tempController;
  final Function() onAjouterRefrigerateur;
  final Function() onResetForm;

  const RefrigerateurForm({
    super.key,
    required this.provider,
    required this.nomController,
    required this.tempController,
    required this.onAjouterRefrigerateur,
    required this.onResetForm,
  });

  @override
  State<RefrigerateurForm> createState() => _RefrigerateurFormState();
}

class _RefrigerateurFormState extends State<RefrigerateurForm> {
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
                  'assets/icons/fridge.svg',
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
                      'Nouveau Réfrigérateur',
                      style:
                          Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: ThemeConstants.spacingXs),
                    Text(
                      'Ajoutez un réfrigérateur à votre bar',
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

          // Section Informations
          Text(
            'Informations du réfrigérateur',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          // Nom
          AppTextField(
            controller: widget.nomController,
            label: 'Nom du réfrigérateur',
            hint: 'Ex: Frigo Principal',
            prefixIcon: Icons.label_rounded,
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Température
          AppNumberField(
            controller: widget.tempController,
            label: 'Température (°C)',
            hint: 'Ex: 4',
            prefixIcon: Icons.thermostat_rounded,
          ),

          const SizedBox(height: ThemeConstants.spacingSm),

          // Info température
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingSm),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusSm),
              border: Border.all(
                color: AppColors.info.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline_rounded,
                  color: AppColors.info,
                  size: 16,
                ),
                const SizedBox(width: ThemeConstants.spacingSm),
                Expanded(
                  child: Text(
                    'Température recommandée : entre 2°C et 6°C',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.info,
                        ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: ThemeConstants.spacingXl),

          // Divider
          const Divider(height: 1),

          const SizedBox(height: ThemeConstants.spacingLg),

          // Bouton Ajouter
          AppButton.primary(
            text: 'Ajouter le réfrigérateur',
            icon: Icons.add_circle_rounded,
            size: AppButtonSize.medium,
            isFullWidth: true,
            onPressed: widget.onAjouterRefrigerateur,
          ),
        ],
      ),
    );
  }
}
