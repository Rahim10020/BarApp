import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';

/// Utilitaires pour le filtrage des boissons par taille.
///
/// Fournit des méthodes statiques pour filtrer une liste de boissons
/// selon leur modèle (petit ou grand).
class BoissonUtil {
  /// Filtre et retourne uniquement les boissons de petit modèle.
  ///
  /// [boissons] : Liste de boissons à filtrer.
  /// Retourne une nouvelle liste contenant uniquement les boissons
  /// dont le modèle est [Modele.petit].
  static List<Boisson> getPetitModele(List<Boisson> boissons) {
    return boissons.where((b) => b.modele == Modele.petit).toList();
  }

  /// Filtre et retourne uniquement les boissons de grand modèle.
  ///
  /// [boissons] : Liste de boissons à filtrer.
  /// Retourne une nouvelle liste contenant uniquement les boissons
  /// dont le modèle est [Modele.grand].
  static List<Boisson> getGrandModele(List<Boisson> boissons) {
    return boissons.where((b) => b.modele == Modele.grand).toList();
  }
}
