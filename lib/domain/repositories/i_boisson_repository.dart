import 'package:projet7/models/boisson.dart';
import 'i_base_repository.dart';

/// Repository pour les boissons
abstract class IBoissonRepository extends IBaseRepository<Boisson> {
  /// Recherche des boissons par nom
  List<Boisson> searchByName(String query);

  /// Récupère les boissons froides
  List<Boisson> getColdDrinks();

  /// Récupère les boissons par modèle
  List<Boisson> getByModele(String modele);

  /// Récupère les boissons proches de l'expiration
  List<Boisson> getExpiringSoon({int daysThreshold = 7});

  /// Récupère les boissons expirées
  List<Boisson> getExpired();
}
