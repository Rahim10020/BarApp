import 'package:projet7/models/vente.dart';
import 'i_base_repository.dart';

/// Repository pour la gestion des ventes et l'analyse des revenus.
///
/// Cette interface étend [IBaseRepository] avec des fonctionnalités spécifiques
/// aux ventes : filtrage par période, calcul des revenus, recherche par produit.
///
/// Utilisée pour l'enregistrement des transactions et la génération de rapports.
abstract class IVenteRepository extends IBaseRepository<Vente> {
  /// Récupère les ventes effectuées dans une période donnée.
  ///
  /// [startDate] : date de début de la période (incluse).
  /// [endDate] : date de fin de la période (incluse).
  List<Vente> getByDateRange(DateTime startDate, DateTime endDate);

  /// Récupère toutes les ventes du jour en cours.
  ///
  /// Utile pour le tableau de bord quotidien.
  List<Vente> getToday();

  /// Récupère les ventes de la semaine en cours.
  ///
  /// Retourne les ventes depuis le lundi de la semaine actuelle.
  List<Vente> getThisWeek();

  /// Récupère les ventes du mois en cours.
  ///
  /// Retourne les ventes depuis le premier jour du mois actuel.
  List<Vente> getThisMonth();

  /// Calcule le revenu total généré sur une période.
  ///
  /// [startDate] : date de début de la période.
  /// [endDate] : date de fin de la période.
  /// Retourne la somme des montants de toutes les ventes en FCFA.
  double getTotalRevenue(DateTime startDate, DateTime endDate);

  /// Récupère les ventes contenant une boisson spécifique.
  ///
  /// [drinkName] : nom de la boisson recherchée.
  /// Utile pour analyser la performance d'un produit.
  List<Vente> getBySalesWithDrink(String drinkName);
}
