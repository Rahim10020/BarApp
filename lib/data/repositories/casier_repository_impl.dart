import 'package:projet7/data/datasources/hive_local_datasource.dart';
import 'package:projet7/data/repositories/base_repository_impl.dart';
import 'package:projet7/domain/repositories/i_casier_repository.dart';
import 'package:projet7/models/casier.dart';

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
