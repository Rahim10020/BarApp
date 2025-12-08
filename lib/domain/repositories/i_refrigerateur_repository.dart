import 'package:projet7/domain/entities/refrigerateur.dart';
import 'i_base_repository.dart';

/// Repository pour la gestion des réfrigérateurs et du stockage froid.
///
/// Cette interface étend [IBaseRepository] avec des fonctionnalités spécifiques
/// aux réfrigérateurs : filtrage par température, alertes de stock bas.
///
/// Utilisée pour le suivi des équipements de stockage froid et leur contenu.
abstract class IRefrigerateurRepository extends IBaseRepository<Refrigerateur> {
  /// Récupère les réfrigérateurs dans une plage de température.
  ///
  /// [min] : température minimale en °C.
  /// [max] : température maximale en °C.
  /// Utile pour le contrôle qualité du stockage.
  List<Refrigerateur> getByTemperatureRange(double min, double max);

  /// Récupère les réfrigérateurs ayant un stock bas.
  ///
  /// [threshold] : seuil minimum de boissons (défaut: 5).
  /// Retourne les frigos avec moins de [threshold] boissons.
  List<Refrigerateur> getLowStockRefrigerators({int threshold = 5});

  /// Compte le nombre total de boissons dans tous les frigos.
  ///
  /// Utilisé pour les statistiques d'inventaire global.
  int getTotalDrinksCount();

  /// Récupère le nombre de boissons par réfrigérateur.
  ///
  /// Retourne une Map où la clé est l'ID du frigo et la valeur le nombre de boissons.
  /// Utile pour visualiser la répartition du stock.
  Map<int, int> getDrinksCountByRefrigerateur();
}
