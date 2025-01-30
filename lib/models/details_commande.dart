import 'package:projet7/models/boisson.dart';

class DetailsCommande {
  final Boisson boisson;
  final int nbCasiers;

  DetailsCommande({
    required this.boisson,
    required this.nbCasiers,
  });

  // methode me permettant de calculer le prix total pour chaque boisson de la commande en fonction du nombre de casiers
  // cela retourne le prix total d'une boisson de la commande
  double calculPrixTotal() {
    return nbCasiers * boisson.calculerPrixPourCasier();
  }
}
