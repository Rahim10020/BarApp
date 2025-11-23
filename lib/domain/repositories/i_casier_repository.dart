import 'package:projet7/models/casier.dart';
import 'i_base_repository.dart';

/// Repository pour la gestion des casiers de boissons.
///
/// Cette interface étend [IBaseRepository] avec des fonctionnalités spécifiques
/// aux casiers : recherche par contenu, filtrage par état, comptage des boissons.
///
/// Un casier est un conteneur physique regroupant plusieurs boissons du même type.
abstract class ICasierRepository extends IBaseRepository<Casier> {
  /// Récupère les casiers contenant une boisson spécifique.
  ///
  /// [drinkName] : nom de la boisson à rechercher.
  /// Retourne les casiers contenant au moins une boisson avec ce nom.
  List<Casier> getWithDrink(String drinkName);

  /// Récupère tous les casiers qui ne sont pas vides.
  ///
  /// Retourne les casiers ayant au moins une boisson.
  /// Utile pour afficher l'inventaire disponible.
  List<Casier> getNonEmpty();

  /// Compte le nombre total de boissons dans tous les casiers.
  ///
  /// Additionne les boissons de tous les casiers du repository.
  /// Utilisé pour les statistiques d'inventaire.
  int getTotalDrinksCount();
}
