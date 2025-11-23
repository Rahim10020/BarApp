import 'package:projet7/models/vente.dart';

/// Utilitaires pour l'analyse et le tri des ventes.
///
/// Fournit des méthodes statiques pour organiser les ventes
/// par popularité, valeur totale ou quantité vendue.
///
/// Utilisé principalement pour générer des rapports et tableaux de bord.
class VenteUtil {
  /// Retourne les ventes triées par popularité (quantité vendue).
  ///
  /// [ventes] : Liste de ventes à analyser.
  /// Retourne une liste triée par quantité totale décroissante.
  ///
  /// Note: Cette méthode agrège les ventes par type de boisson
  /// et trie par la quantité totale vendue.
  static List<Vente> getVentesPopulaire(List<Vente> ventes) {
    List<Vente> ventesPopulaires = [];
    List<int> quantitesTotales = [];

    // Parcourir toutes les ventes et cumuler la quantité pour les boissons identiques
    // for (var vente in ventes) {
    //   int index = ventesPopulaires.indexWhere(
    //     (v) => v.boisson.id == vente.boisson.id,
    //   );

    //   if (index == -1) {
    //     ventesPopulaires.add(vente);
    //     quantitesTotales.add(vente.quantiteVendu);
    //   } else {
    //     quantitesTotales[index] += vente.quantiteVendu;
    //   }
    // }

    List<Vente> ventesTries = List.from(ventesPopulaires);

    ventesTries.sort((a, b) {
      int indexA = ventesPopulaires.indexOf(a);
      int indexB = ventesPopulaires.indexOf(b);
      return quantitesTotales[indexB].compareTo(quantitesTotales[indexA]);
    });

    return ventesTries;
  }

  /// Groupe les ventes par type de boisson.
  ///
  /// [ventes] : Liste de ventes à grouper.
  /// Retourne une liste de listes, où chaque sous-liste contient
  /// toutes les ventes d'un même type de boisson.
  static List<List<Vente>> getVentesPopulaire2(List<Vente> ventes) {
    Map<int, List<Vente>> ventesGroupees = {};

    // for (var vente in ventes) {
    //   ventesGroupees.putIfAbsent(vente.boisson.id, () => []).add(vente);
    // }

    return ventesGroupees.values.toList();
  }

  /// Retourne les ventes triées par valeur totale décroissante.
  ///
  /// [ventes] : Liste de ventes à analyser.
  /// Retourne une liste groupée et triée par la valeur totale
  /// (quantité × prix) de chaque type de boisson.
  static List<List<Vente>> getVentesLesPlusVendues(List<Vente> ventes) {
    List<List<Vente>> ventesGroupees = getVentesPopulaire2(ventes);

    // Trier les ventes en fonction de la valeur totale (quantité * prix)
    // ventesGroupees.sort((a, b) {
    //   double totalA =
    //       a.fold(0, (sum, v) => sum + (v.quantiteVendu * v.boisson.prix.last));
    //   double totalB =
    //       b.fold(0, (sum, v) => sum + (v.quantiteVendu * v.boisson.prix.last));
    //   return totalB.compareTo(totalA); // Tri décroissant
    // });

    return ventesGroupees;
  }

  /// Trie les ventes par prix total décroissant.
  ///
  /// [ventes] : Liste de ventes à trier.
  /// Retourne une nouvelle liste triée de la plus grande
  /// à la plus petite vente en termes de montant.
  static List<Vente> getGrandesVentes(List<Vente> ventes) {
    List<Vente> ventesTriees = List.from(ventes);
    ventesTriees.sort((a, b) => (b.getPrixTotal()).compareTo(a.getPrixTotal()));
    return ventesTriees;
  }

  /// Trie les ventes par prix total croissant.
  ///
  /// [ventes] : Liste de ventes à trier.
  /// Retourne une nouvelle liste triée de la plus petite
  /// à la plus grande vente en termes de montant.
  static List<Vente> getPetitesVentes(List<Vente> ventes) {
    List<Vente> ventesTriees = List.from(ventes);
    ventesTriees.sort((a, b) => (a.getPrixTotal()).compareTo(b.getPrixTotal()));
    return ventesTriees;
  }
}
