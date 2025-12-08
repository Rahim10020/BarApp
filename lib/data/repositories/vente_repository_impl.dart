import 'package:projet7/data/repositories/base_repository_impl.dart';
import 'package:projet7/domain/repositories/i_vente_repository.dart';
import 'package:projet7/domain/entities/vente.dart';

/// Implémentation concrète du repository des ventes.
///
/// Étend [BaseRepositoryImpl] avec les opérations spécifiques aux ventes :
/// filtrage par période (jour, semaine, mois) et calcul des revenus.
///
/// Les filtres de date incluent les bornes (startDate et endDate inclus).
class VenteRepositoryImpl extends BaseRepositoryImpl<Vente>
    implements IVenteRepository {
  VenteRepositoryImpl(super.datasource);

  @override
  List<Vente> getByDateRange(DateTime startDate, DateTime endDate) {
    return getAll().where((v) {
      return v.dateVente.isAfter(startDate.subtract(const Duration(days: 1))) &&
          v.dateVente.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
  }

  @override
  List<Vente> getToday() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return getByDateRange(startOfDay, endOfDay);
  }

  @override
  List<Vente> getThisWeek() {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final startOfWeekDay =
        DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
    final endOfWeek = startOfWeekDay.add(const Duration(days: 7));
    return getByDateRange(startOfWeekDay, endOfWeek);
  }

  @override
  List<Vente> getThisMonth() {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 1);
    return getByDateRange(startOfMonth, endOfMonth);
  }

  @override
  double getTotalRevenue(DateTime startDate, DateTime endDate) {
    final ventes = getByDateRange(startDate, endDate);
    return ventes.fold(0.0, (sum, v) => sum + v.montantTotal);
  }

  @override
  List<Vente> getBySalesWithDrink(String drinkName) {
    final lowerDrinkName = drinkName.toLowerCase();
    return getAll().where((v) {
      return v.lignesVente.any((ligne) =>
          (ligne.boisson.nom ?? '').toLowerCase().contains(lowerDrinkName));
    }).toList();
  }
}
