import 'package:projet7/domain/repositories/i_casier_repository.dart';
import 'package:projet7/domain/repositories/i_commande_repository.dart';
import 'package:projet7/domain/repositories/i_refrigerateur_repository.dart';
import 'package:projet7/domain/repositories/i_vente_repository.dart';

/// Modèle pour les statistiques
class BarStatistics {
  final Map<String, double> revenueByDrink;
  final List<MapEntry<String, int>> topSellingDrinks;
  final Map<DateTime, double> revenueTrends;
  final Map<String, int> inventoryLevels;
  final double totalRevenue;
  final int totalOrders;
  final double averageOrderValue;
  final double totalOrderCost;

  BarStatistics({
    required this.revenueByDrink,
    required this.topSellingDrinks,
    required this.revenueTrends,
    required this.inventoryLevels,
    required this.totalRevenue,
    required this.totalOrders,
    required this.averageOrderValue,
    required this.totalOrderCost,
  });
}

/// Use case pour calculer les statistiques du bar
class GetStatisticsUseCase {
  final IVenteRepository venteRepository;
  final ICommandeRepository commandeRepository;
  final IRefrigerateurRepository refrigerateurRepository;
  final ICasierRepository casierRepository;

  GetStatisticsUseCase({
    required this.venteRepository,
    required this.commandeRepository,
    required this.refrigerateurRepository,
    required this.casierRepository,
  });

  /// Calcule toutes les statistiques pour une période donnée
  BarStatistics execute({
    required DateTime startDate,
    required DateTime endDate,
    String period = 'daily', // 'daily', 'weekly', 'monthly'
    int topDrinksLimit = 10,
  }) {
    return BarStatistics(
      revenueByDrink: _getRevenueByDrink(startDate, endDate),
      topSellingDrinks: _getTopSellingDrinks(startDate, endDate, topDrinksLimit),
      revenueTrends: _getRevenueTrends(startDate, endDate, period),
      inventoryLevels: _getInventoryLevels(),
      totalRevenue: venteRepository.getTotalRevenue(startDate, endDate),
      totalOrders: venteRepository.getByDateRange(startDate, endDate).length,
      averageOrderValue: _getAverageOrderValue(startDate, endDate),
      totalOrderCost: commandeRepository.getTotalOrderCost(startDate, endDate),
    );
  }

  /// Revenus par boisson
  Map<String, double> _getRevenueByDrink(DateTime startDate, DateTime endDate) {
    final ventes = venteRepository.getByDateRange(startDate, endDate);
    final revenue = <String, double>{};

    for (final vente in ventes) {
      for (final ligne in vente.lignesVente) {
        final drinkName = ligne.boisson.nom ?? 'Sans nom';
        revenue[drinkName] = (revenue[drinkName] ?? 0) + ligne.getMontant();
      }
    }

    return revenue;
  }

  /// Top des boissons les plus vendues
  List<MapEntry<String, int>> _getTopSellingDrinks(
    DateTime startDate,
    DateTime endDate,
    int limit,
  ) {
    final ventes = venteRepository.getByDateRange(startDate, endDate);
    final salesCount = <String, int>{};

    for (final vente in ventes) {
      for (final ligne in vente.lignesVente) {
        final drinkName = ligne.boisson.nom ?? 'Sans nom';
        salesCount[drinkName] = (salesCount[drinkName] ?? 0) + 1;
      }
    }

    final sorted = salesCount.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return sorted.take(limit).toList();
  }

  /// Tendances de revenus (par jour/semaine/mois)
  Map<DateTime, double> _getRevenueTrends(
    DateTime startDate,
    DateTime endDate,
    String period,
  ) {
    final ventes = venteRepository.getByDateRange(startDate, endDate);
    final trends = <DateTime, double>{};

    for (final vente in ventes) {
      DateTime key;
      switch (period) {
        case 'daily':
          key = DateTime(
            vente.dateVente.year,
            vente.dateVente.month,
            vente.dateVente.day,
          );
          break;
        case 'weekly':
          final weekStart = vente.dateVente
              .subtract(Duration(days: vente.dateVente.weekday - 1));
          key = DateTime(weekStart.year, weekStart.month, weekStart.day);
          break;
        case 'monthly':
          key = DateTime(vente.dateVente.year, vente.dateVente.month, 1);
          break;
        default:
          key = DateTime(
            vente.dateVente.year,
            vente.dateVente.month,
            vente.dateVente.day,
          );
      }
      trends[key] = (trends[key] ?? 0) + vente.montantTotal;
    }

    return trends;
  }

  /// Niveaux d'inventaire (total de chaque boisson)
  Map<String, int> _getInventoryLevels() {
    final inventory = <String, int>{};

    // Compter depuis les réfrigérateurs
    for (final refrigerateur in refrigerateurRepository.getAll()) {
      if (refrigerateur.boissons != null) {
        for (final boisson in refrigerateur.boissons!) {
          final key = boisson.nom ?? 'Sans nom';
          inventory[key] = (inventory[key] ?? 0) + 1;
        }
      }
    }

    // Compter depuis les casiers
    for (final casier in casierRepository.getAll()) {
      for (final boisson in casier.boissons) {
        final key = boisson.nom ?? 'Sans nom';
        inventory[key] = (inventory[key] ?? 0) + 1;
      }
    }

    return inventory;
  }

  /// Valeur moyenne des commandes
  double _getAverageOrderValue(DateTime startDate, DateTime endDate) {
    final ventes = venteRepository.getByDateRange(startDate, endDate);
    if (ventes.isEmpty) return 0.0;

    final total = ventes.fold(0.0, (sum, v) => sum + v.montantTotal);
    return total / ventes.length;
  }
}
