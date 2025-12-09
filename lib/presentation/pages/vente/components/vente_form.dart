import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:projet7/domain/entities/boisson.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/presentation/theme/app_colors.dart';
import 'package:projet7/presentation/theme/theme_constants.dart';
import 'package:projet7/presentation/widgets/buttons/app_button.dart';
import 'package:projet7/presentation/widgets/cards/app_card.dart';

/// Formulaire moderne pour créer une nouvelle vente
class VenteForm extends StatefulWidget {
  final BarAppProvider provider;
  final List<Boisson> boissonsSelectionnees;
  final bool isAdding;
  final Function() onAjouterVente;

  const VenteForm({
    super.key,
    required this.provider,
    required this.boissonsSelectionnees,
    required this.isAdding,
    required this.onAjouterVente,
  });

  @override
  State<VenteForm> createState() => _VenteFormState();
}

class _VenteFormState extends State<VenteForm> {
  @override
  Widget build(BuildContext context) {
    // Limiter les boissons disponibles à celles des réfrigérateurs
    final boissonsDisponibles =
        widget.provider.refrigerateurs.expand((r) => r.boissons ?? []).toList();

    // État vide si aucune boisson
    if (boissonsDisponibles.isEmpty) {
      return AppCard(
        child: Column(
          children: [
            SvgPicture.asset(
              'assets/icons/boissons.svg',
              width: 32,
              height: 32,
            ),
            const SizedBox(height: ThemeConstants.spacingMd),
            Text(
              'Aucune boisson en stock',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: ThemeConstants.spacingXs),
            Text(
              'Ajoutez des boissons aux réfrigérateurs pour créer une vente',
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return AnimatedContainer(
      duration: ThemeConstants.animationNormal,
      child: AppCard(
        color:
            widget.isAdding ? AppColors.success.withValues(alpha: 0.1) : null,
        border: widget.isAdding
            ? Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
                width: ThemeConstants.borderWidthMedium,
              )
            : null,
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
                    borderRadius:
                        BorderRadius.circular(ThemeConstants.radiusMd),
                  ),
                  child: const Icon(
                    Icons.add_shopping_cart_rounded,
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
                        'Nouvelle Vente',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(
                        'Sélectionnez les boissons',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                if (widget.boissonsSelectionnees.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: ThemeConstants.spacingSm,
                      vertical: ThemeConstants.spacingXs,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.circular(ThemeConstants.radiusFull),
                    ),
                    child: Text(
                      '${widget.boissonsSelectionnees.length}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: ThemeConstants.spacingLg),

            // Liste horizontale des boissons
            SizedBox(
              height: 70,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: boissonsDisponibles.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(width: ThemeConstants.spacingSm),
                itemBuilder: (context, index) {
                  final boisson = boissonsDisponibles[index];
                  final isSelected =
                      widget.boissonsSelectionnees.contains(boisson);

                  return _BoissonChip(
                    boisson: boisson,
                    isSelected: isSelected,
                    onTap: () => setState(() {
                      if (isSelected) {
                        widget.boissonsSelectionnees.remove(boisson);
                      } else {
                        widget.boissonsSelectionnees.add(boisson);
                      }
                    }),
                  );
                },
              ),
            ),

            const SizedBox(height: ThemeConstants.spacingLg),

            // Bouton Enregistrer
            AppButton.primary(
              text: 'Enregistrer la vente',
              icon: Icons.check_circle_rounded,
              isFullWidth: true,
              onPressed: widget.boissonsSelectionnees.isNotEmpty
                  ? widget.onAjouterVente
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

/// Chip pour sélectionner une boisson
class _BoissonChip extends StatelessWidget {
  final Boisson boisson;
  final bool isSelected;
  final VoidCallback onTap;

  const _BoissonChip({
    required this.boisson,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: ThemeConstants.animationFast,
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingMd,
          vertical: ThemeConstants.spacingSm,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          border: Border.all(
            color:
                isSelected ? AppColors.primary : Theme.of(context).dividerColor,
            width: isSelected
                ? ThemeConstants.borderWidthMedium
                : ThemeConstants.borderWidthThin,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.local_bar_rounded,
                  size: ThemeConstants.iconSizeMd,
                  color: isSelected ? Colors.white : AppColors.primary,
                ),
                const SizedBox(width: ThemeConstants.spacingXs),
                Text(
                  boisson.nom ?? 'Sans nom',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: isSelected ? Colors.white : null,
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                ),
              ],
            ),
            const SizedBox(height: ThemeConstants.spacingXs),
            Text(
              boisson.getModele() ?? 'N/A',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: isSelected
                        ? Colors.white.withValues(alpha: 0.9)
                        : AppColors.textSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
