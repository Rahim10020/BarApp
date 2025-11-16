import 'package:projet7/models/refrigerateur.dart';
import 'i_base_repository.dart';

/// Repository pour les réfrigérateurs
abstract class IRefrigerateurRepository extends IBaseRepository<Refrigerateur> {
  /// Récupère les réfrigérateurs par plage de température
  List<Refrigerateur> getByTemperatureRange(double min, double max);

  /// Récupère les réfrigérateurs ayant du stock bas
  List<Refrigerateur> getLowStockRefrigerators({int threshold = 5});

  /// Compte le nombre total de boissons dans tous les frigos
  int getTotalDrinksCount();

  /// Récupère le nombre de boissons par frigo
  Map<int, int> getDrinksCountByRefrigerateur();
}
