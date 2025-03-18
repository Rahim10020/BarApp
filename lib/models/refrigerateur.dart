import 'package:hive/hive.dart';
import 'package:projet7/models/boisson.dart';

part 'refrigerateur.g.dart';

/// Modèle représentant un réfrigérateur

@HiveType(typeId: 8)
class Refrigerateur {
  @HiveField(0)
  final int id;

  @HiveField(1)
  String nom;

  @HiveField(2)
  double? temperature;

  @HiveField(3)
  List<Boisson>? boissons;

  /// [id] : représente l'identifiant du réfrigérateur
  /// [nom] : représente le nom du réfrigérateur
  /// [temperature] : représente la température (en dégré Celsuis) du réfrigérateur
  /// [boissons] : représente la liste des `Boisson` dans le réfrigérateur
  Refrigerateur({
    required this.id,
    required this.nom,
    this.temperature,
    this.boissons,
  });

  double getPrixTotal() {
    double prixTotal = 0.0;

    if (boissons != null) {
      for (Boisson boisson in boissons!) {
        prixTotal += boisson.prix.last;
      }
    }

    return prixTotal;
  }

  int getBoissonTotal() {
    if (boissons != null) {
      return boissons!.length;
    }
    return 0;
  }
}
