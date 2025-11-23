import 'package:hive/hive.dart';
import 'modele.dart';

part 'boisson.g.dart';

/// Modèle représentant une boisson dans l'inventaire du bar.
///
/// Cette classe est persistée dans Hive avec le typeId 0.
/// Elle contient toutes les informations relatives à une boisson :
/// identification, prix, caractéristiques et date d'expiration.
///
/// Exemple d'utilisation :
/// ```dart
/// final boisson = Boisson(
///   id: 1,
///   nom: 'Coca-Cola',
///   prix: [500.0, 750.0], // Prix petit et grand
///   estFroid: true,
///   modele: Modele.petit,
/// );
/// ```
@HiveType(typeId: 0)
class Boisson extends HiveObject {
  /// Identifiant unique de la boisson.
  @HiveField(0)
  int id;

  /// Nom de la boisson (ex: "Coca-Cola", "Fanta", etc.).
  @HiveField(1)
  String? nom;

  /// Liste des prix de la boisson.
  ///
  /// Généralement contient deux valeurs :
  /// - Index 0 : prix pour le petit modèle
  /// - Index 1 : prix pour le grand modèle
  ///
  /// Les prix sont exprimés en FCFA (Franc CFA).
  @HiveField(2)
  List<double> prix;

  /// Indique si la boisson doit être servie froide.
  ///
  /// Si `true`, la boisson devrait être stockée dans un réfrigérateur.
  @HiveField(3)
  bool estFroid;

  /// Taille/modèle de la boisson (petit ou grand).
  @HiveField(4)
  Modele? modele;

  /// Description détaillée de la boisson.
  ///
  /// Peut contenir des informations sur les ingrédients,
  /// l'origine ou d'autres détails pertinents.
  @HiveField(5)
  String? description;

  /// Date d'expiration de la boisson.
  ///
  /// Utilisée pour générer des alertes d'inventaire
  /// lorsque des produits approchent de leur date limite.
  @HiveField(6)
  DateTime? dateExpiration;

  /// Crée une nouvelle instance de [Boisson].
  ///
  /// [id] : identifiant unique de la boisson (requis)
  /// [nom] : nom de la boisson
  /// [prix] : liste des prix (requis)
  /// [estFroid] : indique si la boisson est froide (requis)
  /// [modele] : taille de la boisson
  /// [description] : description détaillée
  /// [dateExpiration] : date d'expiration
  Boisson({
    required this.id,
    this.nom,
    required this.prix,
    required this.estFroid,
    this.modele,
    this.description,
    this.dateExpiration,
  });

  /// Retourne le modèle de la boisson sous forme de chaîne lisible.
  ///
  /// Retourne :
  /// - "Petit" si le modèle est [Modele.petit]
  /// - "Grand" si le modèle est [Modele.grand]
  /// - `null` si aucun modèle n'est défini
  String? getModele() => modele == Modele.petit
      ? 'Petit'
      : modele == Modele.grand
          ? 'Grand'
          : null;
}
