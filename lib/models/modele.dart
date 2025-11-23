import 'package:hive/hive.dart';

part "modele.g.dart";

/// Énumération représentant les différentes tailles de boissons.
///
/// Cette enum est persistée dans Hive avec le typeId 9.
/// Elle permet de catégoriser les boissons selon leur taille/volume.
///
/// Utilisée principalement pour :
/// - Déterminer le prix applicable (petit ou grand)
/// - Afficher la taille dans l'interface utilisateur
/// - Filtrer les boissons par taille
@HiveType(typeId: 9)
enum Modele {
  /// Petit format de boisson.
  ///
  /// Correspond généralement au premier prix dans la liste des prix d'une boisson.
  @HiveField(0)
  petit,

  /// Grand format de boisson.
  ///
  /// Correspond généralement au deuxième prix dans la liste des prix d'une boisson.
  @HiveField(1)
  grand,
}
