import 'package:hive/hive.dart';
import 'package:projet7/models/fournisseur.dart';

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

  @HiveField(4)
  Fournisseur fournisseur;

  /// [id] : repésente l'identifiant du casier
  /// [boissonTotal] : représente la quantité de boisson dans le casier
  /// [boissons] : représente la liste des boissons dans le casier
  /// [fournisseur] : représente le fournisseur du casier

  Casier({
    required this.id,
    required this.boissonTotal,
    required this.boissons,
    required this.fournisseur,
  });

  double getPrixTotal() {
    double prixTotal = 0.0;

    for (Boisson boisson in boissons) {
      prixTotal += boisson.prix.last;
    }

    return prixTotal;
  }
}
