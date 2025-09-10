import 'package:hive/hive.dart';
import 'package:projet7/models/boisson.dart';

part 'ligne_vente.g.dart';

/// Modèle représentant une ligne dans le carnet de vente

@HiveType(typeId: 2)
class LigneVente {
  @HiveField(0)
  final int id;

  @HiveField(1)
  double montant;

  @HiveField(2)
  final Boisson boisson;

  /// [id] : repésente l'identifiant de la ligne de vente
  /// [montant] : représente le montant de la `Boisson` contenue dans la ligne de vente
  /// [boisson] : représente la `Boisson` concernée par la vente
  LigneVente({
    required this.id,
    required this.montant,
    required this.boisson,
  });

  double getMontant() {
    return boisson.prix.last;
  }

  /// Synchronise le montant stocké avec le montant de la boisson
  void synchroniserMontant() {
    montant = boisson.prix.last;
  }
}
