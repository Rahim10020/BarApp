import 'package:projet7/data/repositories/base_repository_impl.dart';
import 'package:projet7/domain/repositories/i_casier_repository.dart';
import 'package:projet7/domain/entities/casier.dart';

/// Implémentation concrète du repository des casiers.
///
/// Étend [BaseRepositoryImpl] avec les opérations spécifiques aux casiers :
/// recherche par contenu, filtrage par état et comptage des boissons.
class CasierRepositoryImpl extends BaseRepositoryImpl<Casier>
    implements ICasierRepository {
  CasierRepositoryImpl(super.datasource);

  @override
  List<Casier> getWithDrink(String drinkName) {
    final lowerDrinkName = drinkName.toLowerCase();
    return getAll().where((c) {
      return c.boissons
          .any((b) => (b.nom ?? '').toLowerCase().contains(lowerDrinkName));
    }).toList();
  }

  @override
  List<Casier> getNonEmpty() {
    return getAll().where((c) => c.boissons.isNotEmpty).toList();
  }

  @override
  int getTotalDrinksCount() {
    return getAll().fold(0, (sum, c) => sum + c.boissons.length);
  }
}
