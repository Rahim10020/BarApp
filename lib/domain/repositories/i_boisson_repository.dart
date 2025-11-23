import 'package:projet7/models/boisson.dart';
import 'i_base_repository.dart';

/// Repository pour la gestion des boissons avec des méthodes de recherche avancées.
///
/// Cette interface étend [IBaseRepository] avec des fonctionnalités spécifiques
/// aux boissons : recherche par nom, filtrage par température, gestion des expirations.
///
/// Utilisée pour toutes les opérations liées à l'inventaire des boissons.
abstract class IBoissonRepository extends IBaseRepository<Boisson> {
  /// Recherche des boissons dont le nom contient la requête.
  ///
  /// [query] : texte à rechercher dans le nom des boissons.
  /// La recherche est insensible à la casse.
  List<Boisson> searchByName(String query);

  /// Récupère toutes les boissons marquées comme froides.
  ///
  /// Retourne les boissons où [Boisson.estFroid] est `true`.
  /// Utile pour identifier les produits nécessitant une réfrigération.
  List<Boisson> getColdDrinks();

  /// Récupère les boissons filtrées par modèle/taille.
  ///
  /// [modele] : taille recherchée ("petit" ou "grand").
  List<Boisson> getByModele(String modele);

  /// Récupère les boissons proches de leur date d'expiration.
  ///
  /// [daysThreshold] : nombre de jours avant expiration (défaut: 7).
  /// Utile pour générer des alertes d'inventaire.
  List<Boisson> getExpiringSoon({int daysThreshold = 7});

  /// Récupère les boissons dont la date d'expiration est dépassée.
  ///
  /// Ces produits ne devraient plus être vendus.
  List<Boisson> getExpired();
}
