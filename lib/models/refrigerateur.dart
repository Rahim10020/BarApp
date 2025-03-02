import 'package:hive/hive.dart';
import 'package:projet7/models/boisson.dart';

part 'refrigerateur.g.dart';

/// Modèle représentant un réfrigérateur

@HiveType(typeId: 8)
class Refrigerateur {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final double boissonTotal;

  @HiveField(2)
  final double montantTotal;

  @HiveField(3)
  final List<Boisson> boissons;

  /// [id] : repésente l'identifiant du réfrigérateur
  /// [boissonTotal] : représente la quantité total de `Boisson` dans le réfrigérateur
  /// [montantTotal] : représente le montant total de `Boisson` dans le réfrigérateur
  /// [boissons] : représente la liste des `Boisson` dans le réfrigérateur
  Refrigerateur({
    required this.id,
    required this.boissonTotal,
    required this.montantTotal,
    required this.boissons,
  });

  double getPrixTotal() {
    double prixTotal = 0.0;

    for (Boisson boisson in boissons) {
      prixTotal += boisson.prix.last;
    }

    return prixTotal;
  }
}
