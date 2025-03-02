import 'package:hive/hive.dart';
import 'package:projet7/models/ligne_vente.dart';

part 'vente.g.dart';

/// Modèle représentant un carnet de vente

@HiveType(typeId: 4)
class Vente {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final double montantTotal;

  @HiveField(2)
  final DateTime dateVente;

  @HiveField(3)
  final List<LigneVente> lignesVente;

  /// [id] : repésente l'identifiant de la ligne de vente
  /// [montantTotal] : représente le montant total de la vente
  /// [dateVente] : représente la date où l'opération de vente a été réalisée
  /// [lignesVente] : représente les différentes lignes dans le carnet de vente
  Vente({
    required this.id,
    required this.montantTotal,
    required this.dateVente,
    required this.lignesVente,
  });

  double getPrixTotal() {
    double prixTotal = 0.0;

    for (LigneVente ligneVente in lignesVente) {
      prixTotal += ligneVente.montant;
    }

    return prixTotal;
  }
}
