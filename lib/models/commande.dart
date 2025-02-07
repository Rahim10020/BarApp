import 'package:isar/isar.dart';
import 'details_commande.dart';

part 'commande.g.dart';

@Collection()
class Commande {
  Id id = Isar.autoIncrement; // ID auto-géré par Isar

  late DateTime date; // Date de la commande
  final IsarLinks<DetailsCommande> detailsCommandes =
      IsarLinks(); // Relation avec DetailsCommande

  // Constructeur vide requis par Isar
  Commande();

  // Méthode pour calculer le prix total de la commande
  double get prixTotal {
    return detailsCommandes.fold(0, (total, detail) {
      return total + detail.calculPrixTotal();
    });
  }

  // Méthode pour sauvegarder une commande dans Isar
  // static Future<Commande> creerCommande(Isar isar, List<DetailsCommande> details) async {
  //   final commande = Commande(date: DateTime.now());
  //   commande.detailsCommandes.addAll(details); // Associer les détails

  //   await isar.writeTxn(() async {
  //     await isar.commandes.put(commande); // Sauvegarde de la commande
  //     await commande.detailsCommandes.save(); // Sauvegarde de la relation
  //   });

  //   return commande;
  // }
}
