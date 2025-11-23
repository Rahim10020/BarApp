import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';

/// Utilitaires pour le filtrage des boissons par taille.
///
/// Fournit des méthodes statiques pour filtrer une liste de boissons
/// selon leur modèle (petit ou grand).
class BoissonUtil {
  static List<Boisson> getPetitModele(List<Boisson> boissons) {
    return boissons.where((b) => b.modele == Modele.petit).toList();
  }

  static List<Boisson> getGrandModele(List<Boisson> boissons) {
    return boissons.where((b) => b.modele == Modele.grand).toList();
  }
}
