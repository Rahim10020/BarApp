import 'package:hive/hive.dart';

import 'boisson.dart';

part 'vente.g.dart';

@HiveType(typeId: 2)
class Vente {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final Boisson boisson;

  @HiveField(2)
  final int quantiteVendu;

  @HiveField(3)
  final DateTime dateVente;

  // Constructeur par défaut requis par Isar
  Vente({
    required this.id,
    required this.boisson,
    required this.quantiteVendu,
    required this.dateVente,
  });

  double get prixTotal {
    return boisson.prix.last * quantiteVendu;
  }
}
