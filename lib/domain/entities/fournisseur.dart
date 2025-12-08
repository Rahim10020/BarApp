import 'package:hive/hive.dart';

part 'fournisseur.g.dart';

/// Modèle représentant un fournisseur de boissons.
///
/// Cette classe est persistée dans Hive avec le typeId 7.
/// Elle contient les informations d'identification du fournisseur
/// pour le suivi des commandes et la gestion des approvisionnements.
///
/// Exemple d'utilisation :
/// ```dart
/// final fournisseur = Fournisseur(
///   id: 1,
///   nom: 'Brasseries du Sénégal',
///   adresse: '+221 33 123 45 67',
/// );
/// ```
@HiveType(typeId: 7)
class Fournisseur {
  /// Identifiant unique du fournisseur.
  @HiveField(0)
  final int id;

  /// Nom ou raison sociale du fournisseur.
  @HiveField(1)
  final String nom;

  /// Coordonnées de contact du fournisseur.
  ///
  /// Peut contenir un numéro de téléphone, une adresse email
  /// ou une adresse physique. Optionnel.
  @HiveField(2)
  String? adresse;

  /// Crée une nouvelle instance de [Fournisseur].
  ///
  /// [id] : identifiant unique du fournisseur (requis)
  /// [nom] : nom du fournisseur (requis)
  /// [adresse] : coordonnées de contact
  Fournisseur({
    required this.id,
    required this.nom,
    this.adresse,
  });
}
