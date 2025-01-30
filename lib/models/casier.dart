import 'package:projet7/models/boisson.dart';

class Casier {
  final int identifiant;
  final Boisson boisson; // un casier ne contient qu'un seul type de boisson
  int nbBouteillesRestantes; // lorsqu'on va enlever les bouteilles pour mettre dans le congelateur, cette variable va contenir le bouteille qui reste.

  Casier({
    required this.identifiant,
    required this.boisson,
    required this.nbBouteillesRestantes,
  });

  // methode qui me permet de calculer le prix des boissons qui reste
  double prixBoissonRestant() {
    return nbBouteillesRestantes * boisson.prix;
  }

  // 
}
