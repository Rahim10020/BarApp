import 'package:projet7/models/commande.dart';
import 'i_base_repository.dart';

/// Repository pour les commandes fournisseurs
abstract class ICommandeRepository extends IBaseRepository<Commande> {
  /// Récupère les commandes par période
  List<Commande> getByDateRange(DateTime startDate, DateTime endDate);

  /// Récupère les commandes d'un fournisseur spécifique
  List<Commande> getByFournisseur(int fournisseurId);

  /// Calcule le coût total des commandes sur une période
  double getTotalOrderCost(DateTime startDate, DateTime endDate);

  /// Récupère les commandes récentes
  List<Commande> getRecent({int limit = 10});
}
