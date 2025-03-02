import 'package:hive/hive.dart';

part 'bar_instance.g.dart';

/// Modèle représentant un bar (notamment ses informations d'identifications)

@HiveType(typeId: 6)
class BarInstance {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String nom;

  @HiveField(2)
  final String adresse;

  /// [id] : repésente l'identifiant du bar
  /// [nom] : représente le nom du bar
  /// [adresse] : représente l'adresse (email, téléphone) du bar
  BarInstance({
    required this.id,
    required this.nom,
    required this.adresse,
  });
}
