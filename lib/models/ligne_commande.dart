import 'package:hive/hive.dart';
import 'package:projet7/models/casier.dart';

part 'ligne_commande.g.dart';

/// Modèle représentant une ligne dans le carnet de commande

@HiveType(typeId: 3)
class LigneCommande {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final double montant;

  @HiveField(2)
  final Casier casier;

  /// [id] : repésente l'identifiant de la ligne de commande
  /// [montant] : représente le montant total du casier contenu dans la ligne de commande
  /// [casier] : représente le casier visé par la commande
  LigneCommande({
    required this.id,
    required this.montant,
    required this.casier,
  });
}
