import 'package:projet7/models/casier.dart';

/// Utilitaires pour le tri et le filtrage des casiers.
///
/// Fournit des méthodes statiques pour organiser les casiers
/// par prix ou par contenu.
class CasierUtil {
  /// Trie les casiers par prix total croissant.
  ///
  /// [casiers] : Liste de casiers à trier.
  /// Retourne une nouvelle liste triée du moins cher au plus cher.
  static List<Casier> trierCasierParPrix(List<Casier> casiers) {
    List<Casier> casiersParPrix = List.from(casiers);
    casiersParPrix.sort(
      (a, b) => a.getPrixTotal().compareTo(b.getPrixTotal()),
    );
    return casiersParPrix;
  }

  /// Trie les casiers par type de boisson.
  ///
  /// [casiers] : Liste de casiers à trier.
  /// Retourne une nouvelle liste triée par nom de boisson.
  ///
  /// Note: Cette méthode est actuellement un placeholder et retourne
  /// la liste sans modification.
  static List<Casier> trierCasierParBoisson(List<Casier> casiers) {
    List<Casier> casiersParBoisson = List.from(casiers);
    // casiers.sort(
    //   (a, b) => a.boisson.nom!.compareTo(b.boisson.nom!),
    // );

    return casiersParBoisson;
  }

  /// Retourne les casiers les plus récents.
  ///
  /// [casiers] : Liste de casiers à filtrer.
  /// Retourne une liste des casiers triés par date de création récente.
  ///
  /// Note: Cette méthode est actuellement un placeholder et retourne
  /// la liste sans modification.
  static List<Casier> getRecentsCasiers(List<Casier> casiers) {
    List<Casier> casiersRecents = List.from(casiers);
    // casiers.sort(
    //   (a, b) => a.boisson.nom!.compareTo(b.boisson.nom!),
    // );

    return casiersRecents;
  }
}
