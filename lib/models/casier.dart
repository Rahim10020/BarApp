import 'package:hive/hive.dart';

import 'boisson.dart';

part 'casier.g.dart';

/// Modèle représentant un casier

@HiveType(typeId: 1)
class Casier {
  @HiveField(0)
  final int id;

  @HiveField(2)
  late int boissonTotal;

  @HiveField(3)
  List<Boisson> boissons;

  /// [id] : repésente l'identifiant du casier
  /// [boissonTotal] : représente la quantité de boisson dans le casier
  /// [boissons] : représente la liste des boissons dans le casier

  Casier({
    required this.id,
    required this.boissonTotal,
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
