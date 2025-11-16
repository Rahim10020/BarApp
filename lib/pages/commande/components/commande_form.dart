import 'package:flutter/material.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/pages/commande/components/build_casier_selector.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/inputs/app_text_field.dart';

/// Formulaire moderne pour créer une commande
class CommandeForm extends StatefulWidget {
  final BarAppProvider provider;
  final List<Casier> casiersSelectionnes;
  final TextEditingController nomFournisseurController;
  final TextEditingController adresseFournisseurController;
  final Fournisseur? fournisseurSelectionne;
  final Function(Fournisseur?) onFournisseurChanged;
  final Function() onAjouterCommande;

  const CommandeForm({
    super.key,
    required this.provider,
    required this.casiersSelectionnes,
    required this.nomFournisseurController,
    required this.adresseFournisseurController,
    required this.fournisseurSelectionne,
    required this.onFournisseurChanged,
    required this.onAjouterCommande,
  });

  @override
  State<CommandeForm> createState() => _CommandeFormState();
}

class _CommandeFormState extends State<CommandeForm> {
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
                padding: EdgeInsets.all(ThemeConstants.spacingSm),
                decoration: BoxDecoration(
                  color: AppColors.expense.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  Icons.receipt_long_rounded,
                  color: AppColors.expense,
                  size: ThemeConstants.iconSizeMd,
                ),
              ),
              SizedBox(width: ThemeConstants.spacingMd),
              Text(
                'Nouvelle Commande',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),

          SizedBox(height: ThemeConstants.spacingMd),

          // Sélection Fournisseur Existant
          AppDropdown<Fournisseur>(
            value: widget.fournisseurSelectionne,
            label: 'Fournisseur existant',
            hint: 'Sélectionner un fournisseur',
            prefixIcon: Icons.business_rounded,
            items: widget.provider.fournisseurs.map((fournisseur) {
              return DropdownMenuItem(
                value: fournisseur,
                child: Text(fournisseur.nom),
              );
            }).toList(),
            onChanged: widget.onFournisseurChanged,
          ),

          SizedBox(height: ThemeConstants.spacingMd),

          // Divider avec "OU"
          Row(
            children: [
              Expanded(child: Divider(color: Theme.of(context).dividerColor)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: ThemeConstants.spacingSm),
                child: Text(
                  'OU',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                ),
              ),
              Expanded(child: Divider(color: Theme.of(context).dividerColor)),
            ],
          ),

          SizedBox(height: ThemeConstants.spacingMd),

          // Nouveau Fournisseur
          Text(
            'Créer un nouveau fournisseur',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          SizedBox(height: ThemeConstants.spacingSm),

          AppTextField(
            controller: widget.nomFournisseurController,
            label: 'Nom du fournisseur',
            hint: 'Ex: Brasseries du Cameroun',
            prefixIcon: Icons.person_rounded,
          ),

          SizedBox(height: ThemeConstants.spacingMd),

          AppTextField(
            controller: widget.adresseFournisseurController,
            label: 'Adresse (optionnel)',
            hint: 'Ex: Douala, Cameroun',
            prefixIcon: Icons.location_on_rounded,
            maxLines: 2,
          ),

          SizedBox(height: ThemeConstants.spacingMd),

          // Sélecteur de Casiers
          Text(
            'Casiers à commander (${widget.casiersSelectionnes.length} sélectionné${widget.casiersSelectionnes.length > 1 ? 's' : ''})',
            style: Theme.of(context).textTheme.labelLarge,
          ),
          SizedBox(height: ThemeConstants.spacingSm),

          widget.provider.casiers.isEmpty
              ? Container(
                  padding: EdgeInsets.all(ThemeConstants.spacingMd),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                    border: Border.all(
                      color: AppColors.warning.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: AppColors.warning),
                      SizedBox(width: ThemeConstants.spacingSm),
                      Expanded(
                        child: Text(
                          'Aucun casier disponible. Créez des casiers d\'abord.',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                )
              : BuildCasierSelector(
                  itemCount: widget.provider.casiers.length,
                  itemBuilder: (context, index) {
                    final casier = widget.provider.casiers[index];
                    final isSelected = widget.casiersSelectionnes.contains(casier);

                    return GestureDetector(
                      onTap: () => setState(() {
                        if (isSelected) {
                          widget.casiersSelectionnes.remove(casier);
                        } else {
                          widget.casiersSelectionnes.add(casier);
                        }
                      }),
                      child: AnimatedContainer(
                        duration: ThemeConstants.animationFast,
                        margin: EdgeInsets.symmetric(
                          horizontal: ThemeConstants.spacingXs,
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: ThemeConstants.spacingMd,
                          vertical: ThemeConstants.spacingSm,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary
                              : Theme.of(context).colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
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
                              'Casier #${casier.id}',
                              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: isSelected ? Colors.white : null,
                                    fontWeight: isSelected ? FontWeight.bold : null,
                                  ),
                            ),
                            Text(
                              '${casier.boissonTotal} unités',
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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

          SizedBox(height: ThemeConstants.spacingMd),

          // Bouton Créer
          AppButton.primary(
            text: 'Créer la commande',
            icon: Icons.add_shopping_cart_rounded,
            isFullWidth: true,
            onPressed: widget.onAjouterCommande,
          ),
        ],
      ),
    );
  }
}
