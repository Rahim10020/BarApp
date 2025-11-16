import 'package:projet7/models/vente.dart';
import 'i_base_repository.dart';

/// Repository pour les ventes
abstract class IVenteRepository extends IBaseRepository<Vente> {
  /// Récupère les ventes par période
  List<Vente> getByDateRange(DateTime startDate, DateTime endDate);

  /// Récupère les ventes du jour
  List<Vente> getToday();

  /// Récupère les ventes de la semaine
  List<Vente> getThisWeek();

  /// Récupère les ventes du mois
  List<Vente> getThisMonth();

  /// Calcule le revenu total sur une période
  double getTotalRevenue(DateTime startDate, DateTime endDate);

  /// Récupère les ventes contenant une boisson spécifique
  List<Vente> getBySalesWithDrink(String drinkName);
}
