import 'package:projet7/data/datasources/hive_local_datasource.dart';
import 'package:projet7/data/repositories/base_repository_impl.dart';
import 'package:projet7/domain/repositories/i_commande_repository.dart';
import 'package:projet7/models/commande.dart';

class CommandeRepositoryImpl extends BaseRepositoryImpl<Commande>
    implements ICommandeRepository {
  CommandeRepositoryImpl(super.datasource);

  @override
  List<Commande> getByDateRange(DateTime startDate, DateTime endDate) {
    return getAll().where((c) {
      return c.dateCommande
              .isAfter(startDate.subtract(const Duration(days: 1))) &&
          c.dateCommande.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  List<Commande> getByFournisseur(int fournisseurId) {
    return getAll().where((c) => c.fournisseur.id == fournisseurId).toList();
  }

  @override
  double getTotalOrderCost(DateTime startDate, DateTime endDate) {
    final commandes = getByDateRange(startDate, endDate);
    return commandes.fold(0.0, (sum, c) => sum + c.montantTotal);
  }

  @override
  List<Commande> getRecent({int limit = 10}) {
    final sorted = getAll()
      ..sort((a, b) => b.dateCommande.compareTo(a.dateCommande));
    return sorted.take(limit).toList();
  }
}
