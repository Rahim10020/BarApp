import 'package:hive/hive.dart';

part "id_counter.g.dart";

/// Modèle pour la gestion des compteurs d'identifiants uniques.
///
/// Cette classe est persistée dans Hive avec le typeId 10.
/// Elle permet de générer des identifiants séquentiels uniques
/// pour chaque type d'entité dans l'application.
///
/// Chaque type d'entité (Boisson, Casier, Vente, etc.) a son propre
/// compteur pour garantir l'unicité des IDs.
///
/// Exemple d'utilisation :
/// ```dart
/// final counter = IdCounter(
///   entityType: 'Boisson',
///   lastId: 100,
/// );
/// // Le prochain ID pour Boisson sera 101
/// ```
@HiveType(typeId: 10)
class IdCounter extends HiveObject {
  /// Type d'entité pour lequel ce compteur est utilisé.
  ///
  /// Exemples : "Boisson", "Casier", "Vente", "Commande", etc.
  @HiveField(0)
  String entityType;

  /// Dernier identifiant généré pour ce type d'entité.
  ///
  /// Le prochain ID à générer sera [lastId] + 1.
  @HiveField(1)
  int lastId;

  /// Crée une nouvelle instance de [IdCounter].
  ///
  /// [entityType] : nom du type d'entité (requis)
  /// [lastId] : dernier ID généré (requis)
  IdCounter({
    required this.entityType,
    required this.lastId,
  });
}
