import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/congelateur.dart';

class Vente {
  final DateTime date; // la date de la vente
  final Boisson boisson; // le type de boisson vendu
  final int quantiteVendu; // le nombre total de ce type de boisson vendu
  final double
      montantVente; // le montant de la vente ( qu'il faut calculer en fonction du prix du type de boisson vendu )

  Vente({
    required this.date,
    required this.boisson,
    required this.quantiteVendu,
  }) : montantVente = quantiteVendu * boisson.prix;

  // methode me permettant d'effectuer une vente ( c'est ici que je retire la boisson du congelateur)
  static Vente effectuerVente(
      Congelateur congelateur, Boisson boisson, int quantite) {
    // on va d'abord retirer la boisson qu'on veut vendre
    congelateur.retirerBoisson(boisson, quantite);
    return Vente(
      date: DateTime.now(),
      boisson: boisson,
      quantiteVendu: quantite,
    );
  }
}
