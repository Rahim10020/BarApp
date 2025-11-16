import 'package:projet7/data/repositories/base_repository_impl.dart';
import 'package:projet7/domain/repositories/i_boisson_repository.dart';
import 'package:projet7/models/boisson.dart';

/// Implémentation du repository des boissons
class BoissonRepositoryImpl extends BaseRepositoryImpl<Boisson>
    implements IBoissonRepository {
  BoissonRepositoryImpl(super.datasource);

  @override
  List<Boisson> searchByName(String query) {
    final lowerQuery = query.toLowerCase();
    return getAll()
        .where((b) => (b.nom ?? '').toLowerCase().contains(lowerQuery))
        .toList();
  }

  @override
  List<Boisson> getColdDrinks() {
    return getAll().where((b) => b.estFroid == true).toList();
  }

  @override
  List<Boisson> getByModele(String modele) {
    return getAll().where((b) => b.modele?.name == modele).toList();
  }

  @override
  List<Boisson> getExpiringSoon({int daysThreshold = 7}) {
    final now = DateTime.now();
    return getAll().where((b) {
      if (b.dateExpiration == null) return false;
      final daysUntilExpiry = b.dateExpiration!.difference(now).inDays;
      return daysUntilExpiry <= daysThreshold && daysUntilExpiry >= 0;
    }).toList();
  }

  @override
  List<Boisson> getExpired() {
    final now = DateTime.now();
    return getAll().where((b) {
      if (b.dateExpiration == null) return false;
      return b.dateExpiration!.isBefore(now);
    }).toList();
  }
}
