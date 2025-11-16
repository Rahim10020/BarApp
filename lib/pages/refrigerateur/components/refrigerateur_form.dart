import 'package:flutter/material.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/inputs/app_text_field.dart';

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
          // Titre
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.coldDrink.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: const Icon(
                  Icons.kitchen_rounded,
                  color: AppColors.coldDrink,
                  size: ThemeConstants.iconSizeMd,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingMd),
              Text(
                'Nouveau Réfrigérateur',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Nom et Température (ligne)
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AppTextField(
                  controller: widget.nomController,
                  label: 'Nom',
                  hint: 'Ex: Frigo Principal',
                  prefixIcon: Icons.label_rounded,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingMd),
              Expanded(
                child: AppNumberField(
                  controller: widget.tempController,
                  label: 'Temp. (°C)',
                  hint: '4',
                  prefixIcon: Icons.thermostat_rounded,
                ),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Bouton Ajouter
          AppButton.primary(
            text: 'Ajouter le réfrigérateur',
            icon: Icons.add_circle_rounded,
            isFullWidth: true,
            onPressed: widget.onAjouterRefrigerateur,
          ),
        ],
      ),
    );
  }
}
