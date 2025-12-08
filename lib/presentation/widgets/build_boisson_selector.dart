import 'package:flutter/material.dart';

/// Widget de sélection horizontale pour les boissons.
///
/// Affiche une liste horizontale défilable d'éléments personnalisables.
/// Utilisé pour permettre à l'utilisateur de sélectionner une boisson
/// parmi une liste.
///
/// Exemple d'utilisation:
/// ```dart
/// BuildBoissonSelector(
///   itemCount: boissons.length,
///   itemBuilder: (context, index) => BoissonTile(boisson: boissons[index]),
/// )
/// ```
class BuildBoissonSelector extends StatelessWidget {
  final int? itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;

  const BuildBoissonSelector({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
