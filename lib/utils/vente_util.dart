import 'package:projet7/models/vente.dart';

class VenteUtil {
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

  static List<List<Vente>> getVentesPopulaire2(List<Vente> ventes) {
    Map<int, List<Vente>> ventesGroupees = {};

    // for (var vente in ventes) {
    //   ventesGroupees.putIfAbsent(vente.boisson.id, () => []).add(vente);
    // }

    return ventesGroupees.values.toList();
  }

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

  static List<Vente> getGrandesVentes(List<Vente> ventes) {
    List<Vente> ventesTriees = List.from(ventes);
    ventesTriees.sort((a, b) => (b.getPrixTotal()).compareTo(a.getPrixTotal()));
    return ventesTriees;
  }

  static List<Vente> getPetitesVentes(List<Vente> ventes) {
    List<Vente> ventesTriees = List.from(ventes);
    ventesTriees.sort((a, b) => (a.getPrixTotal()).compareTo(b.getPrixTotal()));
    return ventesTriees;
  }
}
