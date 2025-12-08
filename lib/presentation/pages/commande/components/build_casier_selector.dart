import 'package:flutter/material.dart';

/// Widget de sélection horizontale pour les casiers.
///
/// Affiche une liste horizontale défilable de casiers personnalisables.
/// Utilisé dans les écrans de commande pour sélectionner des casiers
/// à ajouter à une commande.
///
/// Exemple d'utilisation:
/// ```dart
/// BuildCasierSelector(
///   itemCount: casiers.length,
///   itemBuilder: (context, index) => CasierTile(casier: casiers[index]),
/// )
/// ```
class BuildCasierSelector extends StatelessWidget {
  final int? itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;

  const BuildCasierSelector({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
