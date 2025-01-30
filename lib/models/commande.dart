import 'package:projet7/models/details_commande.dart';

class Commande {
  final DateTime date;
  final List<DetailsCommande> detailsCommandes;

  Commande({
    required this.date,
    required this.detailsCommandes,
  });

  // methode pour calculer le prix total de la commande
  double prixTotal() {
    return detailsCommandes.fold(0, (total, detail) {
      return total + detail.calculPrixTotal();
    });
  }
}
