import 'package:hive/hive.dart';

part 'fournisseur.g.dart';

/// Modèle représentant un fournisseur (notamment ses informations d'identifications)

@HiveType(typeId: 7)
class Fournisseur {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nom;

  @HiveField(2)
  final String adresse;

  /// [id] : repésente l'identifiant du fournisseur
  /// [nom] : représente le nom du fournisseur
  /// [adresse] : représente l'adresse (email, téléphone) du fournisseur
  Fournisseur({
    required this.id,
    required this.nom,
    required this.adresse,
  });
}
