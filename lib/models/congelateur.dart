import 'package:projet7/models/boisson.dart';

class Congelateur {
  final Map<Boisson, int> stockBoissons =
      {}; //cle = boisson et valeur = quantite de boissons

  // methode qui me permet d'ajouter une boisson au congelateur
  void ajouterBoisson(Boisson boisson, int quantite) {
    // si cette boisson existe deja dans le congelateur, on va juste incrementer sa quantite
    if (stockBoissons.containsKey(boisson)) {
      stockBoissons[boisson] = stockBoissons[boisson]! + quantite;
    } else {
      stockBoissons[boisson] = quantite;
    }
  }

  // methode qui me permet de retirer une boisson du congelateur
  void retirerBoisson(Boisson boisson, int quantite) {
    if (!stockBoissons.containsKey(boisson) ||
        stockBoissons[boisson]! < quantite) {
      throw Exception("Quantite insuffisante dans le congelateur");
    }
    stockBoissons[boisson] = stockBoissons[boisson]! - quantite;
    if (stockBoissons[boisson] == 0) {
      stockBoissons.remove(boisson);
    }
  }

  // methode qui me permet de recuperer la quantite totale d'une certaine boisson
  int getQuantiteTotal(Boisson boisson) {
    return stockBoissons[boisson] ?? 0;
  }

  // methode qui me permet de calculer le prix total des boissons qui sont dans le congelateur
  double calculPrixTotalStock() {
    return stockBoissons.entries.fold(0, (total, entry) {
      return total + (entry.key.prix * entry.value);
    });
  }
}
