import 'package:projet7/domain/repositories/i_casier_repository.dart';
import 'package:projet7/domain/repositories/i_refrigerateur_repository.dart';

/// Modèle représentant une alerte d'inventaire.
///
/// Peut être de type 'low_stock' (stock bas) ou 'expiry' (expiration).
class InventoryAlert {
  /// Type d'alerte : 'low_stock' ou 'expiry'.
  final String type;

  /// Message descriptif de l'alerte.
  final String message;

  /// Date d'expiration (pour les alertes de type 'expiry').
  final DateTime? expiryDate;

  /// Niveau de stock actuel (pour les alertes de type 'low_stock').
  final int? stockLevel;

  /// Crée une nouvelle alerte d'inventaire.
  InventoryAlert({
    required this.type,
    required this.message,
    this.expiryDate,
    this.stockLevel,
  });
}

/// Use case pour détecter et récupérer les alertes d'inventaire.
///
/// Analyse les stocks des réfrigérateurs et casiers pour identifier :
/// - Les produits en stock bas (sous un seuil configurable)
/// - Les produits proches de leur date d'expiration
/// - Les produits déjà expirés
class GetInventoryAlertsUseCase {
  final IRefrigerateurRepository refrigerateurRepository;
  final ICasierRepository casierRepository;

  GetInventoryAlertsUseCase({
    required this.refrigerateurRepository,
    required this.casierRepository,
  });

  /// Récupère toutes les alertes (stock bas + expirations)
  List<InventoryAlert> execute({
    int lowStockThreshold = 5,
    int daysBeforeExpiry = 7,
  }) {
    final alerts = <InventoryAlert>[];

    // Alertes de stock bas (réfrigérateurs)
    alerts.addAll(_getLowStockAlertsFromFridges(lowStockThreshold));

    // Alertes de stock bas (casiers)
    alerts.addAll(_getLowStockAlertsFromCases(lowStockThreshold));

    // Alertes d'expiration
    alerts.addAll(_getExpiryAlerts(daysBeforeExpiry));

    return alerts;
  }

  /// Alertes de stock bas pour les réfrigérateurs
  List<InventoryAlert> _getLowStockAlertsFromFridges(int threshold) {
    final alerts = <InventoryAlert>[];

    for (final refrigerateur in refrigerateurRepository.getAll()) {
      if (refrigerateur.boissons != null) {
        // Grouper par nom de boisson
        final groupedBoissons = <String, int>{};
        for (final boisson in refrigerateur.boissons!) {
          final key = boisson.nom ?? 'Sans nom';
          groupedBoissons[key] = (groupedBoissons[key] ?? 0) + 1;
        }

        // Créer des alertes pour les stocks bas
        groupedBoissons.forEach((nom, count) {
          if (count <= threshold) {
            alerts.add(InventoryAlert(
              type: 'low_stock',
              message:
                  'Stock faible (Frigo #${refrigerateur.id}): $nom ($count unités)',
              stockLevel: count,
            ));
          }
        });
      }
    }

    return alerts;
  }

  /// Alertes de stock bas pour les casiers
  List<InventoryAlert> _getLowStockAlertsFromCases(int threshold) {
    final alerts = <InventoryAlert>[];

    for (final casier in casierRepository.getAll()) {
      if (casier.boissons.isNotEmpty) {
        // Grouper par nom de boisson
        final groupedBoissons = <String, int>{};
        for (final boisson in casier.boissons) {
          final key = boisson.nom ?? 'Sans nom';
          groupedBoissons[key] = (groupedBoissons[key] ?? 0) + 1;
        }

        // Créer des alertes pour les stocks bas
        groupedBoissons.forEach((nom, count) {
          if (count <= threshold) {
            alerts.add(InventoryAlert(
              type: 'low_stock',
              message: 'Stock faible (Casier #${casier.id}): $nom ($count unités)',
              stockLevel: count,
            ));
          }
        });
      }
    }

    return alerts;
  }

  /// Alertes d'expiration
  List<InventoryAlert> _getExpiryAlerts(int daysBeforeExpiry) {
    final alerts = <InventoryAlert>[];
    final now = DateTime.now();

    for (final refrigerateur in refrigerateurRepository.getAll()) {
      if (refrigerateur.boissons != null) {
        for (final boisson in refrigerateur.boissons!) {
          if (boisson.dateExpiration != null) {
            final daysUntilExpiry =
                boisson.dateExpiration!.difference(now).inDays;

            if (daysUntilExpiry <= daysBeforeExpiry && daysUntilExpiry >= 0) {
              alerts.add(InventoryAlert(
                type: 'expiry',
                message:
                    'Expiration proche: ${boisson.nom ?? 'Sans nom'} expire dans $daysUntilExpiry jours',
                expiryDate: boisson.dateExpiration,
              ));
            } else if (daysUntilExpiry < 0) {
              alerts.add(InventoryAlert(
                type: 'expiry',
                message: 'Expiré: ${boisson.nom ?? 'Sans nom'} a expiré',
                expiryDate: boisson.dateExpiration,
              ));
            }
          }
        }
      }
    }

    return alerts;
  }

  /// Vérifie s'il y a des alertes de stock bas
  bool hasLowStockAlerts({int threshold = 5}) {
    return execute(lowStockThreshold: threshold)
        .any((alert) => alert.type == 'low_stock');
  }

  /// Vérifie s'il y a des alertes d'expiration
  bool hasExpiryAlerts({int daysBeforeExpiry = 7}) {
    return execute(daysBeforeExpiry: daysBeforeExpiry)
        .any((alert) => alert.type == 'expiry');
  }
}
