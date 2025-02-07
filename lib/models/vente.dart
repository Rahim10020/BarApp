import 'package:isar/isar.dart';
import 'boisson.dart';

part 'vente.g.dart';

@Collection()
class Vente {
  Id id = Isar.autoIncrement; // ID auto-géré par Isar

  late DateTime date; // Date de la vente
  final IsarLink<Boisson> boisson =
      IsarLink<Boisson>(); // Relation avec Boisson
  late int quantiteVendu; // Nombre de boissons vendues

  Vente({
    required this.date,
    required this.quantiteVendu,
  });

  // Constructeur par défaut requis par Isar
  Vente.empty();

  // Méthode pour calculer le montant de la vente
  double get montantVente {
    return (boisson.value?.prix ?? 0) * quantiteVendu;
  }

  // Méthode pour effectuer une vente et l’enregistrer dans Isar
  // static Future<Vente?> effectuerVente(
  //     Isar isar, Congelateur congelateur, Boisson boisson, int quantite) async {
  //   if (quantite <= 0) return null; // Vérification simple

  //   final vente = Vente(
  //     date: DateTime.now(),
  //     quantiteVendu: quantite,
  //   );

  //   vente.boisson.value = boisson; // Associer la boisson vendue

  //   return await isar.writeTxn(() async {
  //     await congelateur.retirerBoisson(
  //         boisson, quantite); // Mise à jour congelateur
  //     await isar.ventes.put(vente); // Enregistrement de la vente
  //     await vente.boisson.save(); // Sauvegarde de la relation avec Boisson
  //     return vente;
  //   });
  // }
}
