import 'package:projet7/models/casier.dart';
import 'i_base_repository.dart';

/// Repository pour les casiers
abstract class ICasierRepository extends IBaseRepository<Casier> {
  /// Récupère les casiers contenant une boisson spécifique
  List<Casier> getWithDrink(String drinkName);

  /// Récupère les casiers non vides
  List<Casier> getNonEmpty();

  /// Compte le nombre total de boissons dans tous les casiers
  int getTotalDrinksCount();
}
