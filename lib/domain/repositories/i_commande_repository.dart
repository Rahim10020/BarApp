import 'package:projet7/models/commande.dart';
import 'i_base_repository.dart';

/// Repository pour la gestion des commandes auprès des fournisseurs.
///
/// Cette interface étend [IBaseRepository] avec des fonctionnalités spécifiques
/// aux commandes : filtrage par période, par fournisseur et calcul des coûts.
///
/// Utilisée pour le suivi des approvisionnements et l'analyse des dépenses.
abstract class ICommandeRepository extends IBaseRepository<Commande> {
  /// Récupère les commandes effectuées dans une période donnée.
  ///
  /// [startDate] : date de début de la période (incluse).
  /// [endDate] : date de fin de la période (incluse).
  List<Commande> getByDateRange(DateTime startDate, DateTime endDate);

  /// Récupère les commandes passées à un fournisseur spécifique.
  ///
  /// [fournisseurId] : identifiant du fournisseur.
  /// Utile pour analyser les relations avec un fournisseur.
  List<Commande> getByFournisseur(int fournisseurId);

  /// Calcule le coût total des commandes sur une période.
  ///
  /// [startDate] : date de début de la période.
  /// [endDate] : date de fin de la période.
  /// Retourne la somme des montants de toutes les commandes en FCFA.
  double getTotalOrderCost(DateTime startDate, DateTime endDate);

  /// Récupère les commandes les plus récentes.
  ///
  /// [limit] : nombre maximum de commandes à retourner (défaut: 10).
  /// Triées par date décroissante.
  List<Commande> getRecent({int limit = 10});
}
