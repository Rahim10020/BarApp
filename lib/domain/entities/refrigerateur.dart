import 'package:hive/hive.dart';
import 'package:projet7/domain/entities/boisson.dart';

part 'refrigerateur.g.dart';

/// Modèle représentant un réfrigérateur/unité de stockage froid.
///
/// Cette classe est persistée dans Hive avec le typeId 8.
/// Un réfrigérateur permet de stocker des boissons à une température
/// contrôlée et de suivre leur inventaire.
///
/// Exemple d'utilisation :
/// ```dart
/// final frigo = Refrigerateur(
///   id: 1,
///   nom: 'Frigo Principal',
///   temperature: 4.0,
///   boissons: [boisson1, boisson2],
/// );
/// print('Contenu: ${frigo.getBoissonTotal()} boissons');
/// ```
@HiveType(typeId: 8)
class Refrigerateur {
  /// Identifiant unique du réfrigérateur.
  @HiveField(0)
  final int id;

  /// Nom ou emplacement du réfrigérateur.
  ///
  /// Ex: "Frigo Principal", "Frigo Comptoir", etc.
  @HiveField(1)
  String nom;

  /// Température de fonctionnement en degrés Celsius.
  ///
  /// Utilisée pour le suivi des conditions de stockage.
  /// Valeur typique entre 2°C et 8°C.
  @HiveField(2)
  double? temperature;

  /// Liste des boissons stockées dans le réfrigérateur.
  ///
  /// Peut être null si le réfrigérateur est vide ou non initialisé.
  @HiveField(3)
  List<Boisson>? boissons;

  /// Crée une nouvelle instance de [Refrigerateur].
  ///
  /// [id] : identifiant unique du réfrigérateur (requis)
  /// [nom] : nom ou emplacement (requis)
  /// [temperature] : température en °C
  /// [boissons] : liste des boissons stockées
  Refrigerateur({
    required this.id,
    required this.nom,
    this.temperature,
    this.boissons,
  });

  /// Calcule le prix total de toutes les boissons dans le réfrigérateur.
  ///
  /// Additionne le dernier prix de chaque boisson.
  ///
  /// Retourne le prix total en FCFA, ou 0 si le réfrigérateur est vide.
  double getPrixTotal() {
    double prixTotal = 0.0;

    if (boissons != null) {
      for (Boisson boisson in boissons!) {
        prixTotal += boisson.prix.last;
      }
    }

    return prixTotal;
  }

  /// Retourne le nombre total de boissons dans le réfrigérateur.
  ///
  /// Retourne 0 si la liste des boissons est null ou vide.
  int getBoissonTotal() {
    if (boissons != null) {
      return boissons!.length;
    }
    return 0;
  }
}
