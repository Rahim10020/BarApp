import 'package:isar/isar.dart';
import 'boisson.dart';

part 'details_commande.g.dart';

@Collection()
class DetailsCommande {
  Id id = Isar.autoIncrement;

  final IsarLink<Boisson> boisson = IsarLink();
  final int nbCasiers;

  DetailsCommande({
    required this.nbCasiers,
  });

  // Méthode pour calculer le prix total pour chaque boisson de la commande
  double calculPrixTotal() {
    return nbCasiers * (boisson.value?.calculerPrixPourCasier() ?? 0);
  }
}
