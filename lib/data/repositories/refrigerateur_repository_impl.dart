import 'package:projet7/data/datasources/hive_local_datasource.dart';
import 'package:projet7/data/repositories/base_repository_impl.dart';
import 'package:projet7/domain/repositories/i_refrigerateur_repository.dart';
import 'package:projet7/models/refrigerateur.dart';

class RefrigerateurRepositoryImpl extends BaseRepositoryImpl<Refrigerateur>
    implements IRefrigerateurRepository {
  RefrigerateurRepositoryImpl(super.datasource);

  @override
  List<Refrigerateur> getByTemperatureRange(double min, double max) {
    return getAll()
        .where((r) => r.temperature >= min && r.temperature <= max)
        .toList();
  }

  @override
  List<Refrigerateur> getLowStockRefrigerators({int threshold = 5}) {
    return getAll().where((r) {
      final count = r.boissons?.length ?? 0;
      return count <= threshold && count > 0;
    }).toList();
  }

  @override
  int getTotalDrinksCount() {
    return getAll().fold(0, (sum, r) => sum + (r.boissons?.length ?? 0));
  }

  @override
  Map<int, int> getDrinksCountByRefrigerateur() {
    final result = <int, int>{};
    for (final r in getAll()) {
      result[r.id] = r.boissons?.length ?? 0;
    }
    return result;
  }
}
