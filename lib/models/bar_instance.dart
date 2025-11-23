import 'package:hive/hive.dart';

part 'bar_instance.g.dart';

/// Modèle représentant les informations d'identification d'un bar.
///
/// Cette classe est persistée dans Hive avec le typeId 6.
/// Elle contient les informations de base du bar comme son nom
/// et ses coordonnées de contact.
///
/// Il ne devrait y avoir qu'une seule instance de bar dans l'application,
/// créée lors de la première utilisation.
///
/// Exemple d'utilisation :
/// ```dart
/// final bar = BarInstance(
///   id: 1,
///   nom: 'Bar Le Palmier',
///   adresse: '+221 77 123 45 67',
/// );
/// ```
@HiveType(typeId: 6)
class BarInstance {
  /// Identifiant unique du bar.
  @HiveField(0)
  final int id;

  /// Nom commercial du bar.
  ///
  /// Affiché sur les rapports PDF et dans l'interface.
  @HiveField(1)
  final String nom;

  /// Coordonnées de contact du bar.
  ///
  /// Peut contenir un numéro de téléphone, une adresse email
  /// ou une adresse physique.
  @HiveField(2)
  final String adresse;

  /// Crée une nouvelle instance de [BarInstance].
  ///
  /// [id] : identifiant unique du bar (requis)
  /// [nom] : nom commercial du bar (requis)
  /// [adresse] : coordonnées de contact (requis)
  BarInstance({
    required this.id,
    required this.nom,
    required this.adresse,
  });
}
