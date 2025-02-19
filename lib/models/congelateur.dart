// import 'package:isar/isar.dart';
// import 'stock_boisson.dart';

// part 'congelateur.g.dart';

// @Collection()
// class Congelateur {
//   Id id = Isar.autoIncrement;

//   final IsarLinks<StockBoisson> stockBoissons = IsarLinks();

//   Congelateur();

//   // Ajouter une boisson au stock
//   // Future<void> ajouterBoisson(Isar isar, Boisson boisson, int quantite) async {
//   //   await isar.writeTxn(() async {
//   //     // Vérifier si la boisson est déjà stockée
//   //     final stockExistant =
//   //         stockBoissons.where((s) => s.boisson.value == boisson).firstOrNull;
//   //     if (stockExistant != null) {
//   //       stockExistant.quantite += quantite;
//   //       await isar.stockBoissons.put(stockExistant);
//   //     } else {
//   //       final nouveauStock = StockBoisson()
//   //         ..boisson.value = boisson
//   //         ..quantite = quantite;
//   //       stockBoissons.add(nouveauStock);
//   //       await isar.stockBoissons.put(nouveauStock);
//   //     }
//   //     await stockBoissons.save();
//   //   });
//   // }

//   // // Retirer une boisson du stock
//   // Future<void> retirerBoisson(Isar isar, Boisson boisson, int quantite) async {
//   //   await isar.writeTxn(() async {
//   //     final stockExistant =
//   //         stockBoissons.where((s) => s.boisson.value == boisson).firstOrNull;
//   //     if (stockExistant == null || stockExistant.quantite < quantite) {
//   //       throw Exception("Quantité insuffisante dans le congélateur");
//   //     }
//   //     stockExistant.quantite -= quantite;
//   //     if (stockExistant.quantite == 0) {
//   //       stockBoissons.remove(stockExistant);
//   //       await isar.stockBoissons.delete(stockExistant.id!);
//   //     } else {
//   //       await isar.stockBoissons.put(stockExistant);
//   //     }
//   //     await stockBoissons.save();
//   //   });
//   // }

//   // // Calculer le prix total du stock
//   // double calculPrixTotalStock() {
//   //   return stockBoissons.fold(0, (total, stock) {
//   //     return total + (stock.boisson.value!.prix * stock.quantite);
//   //   });
//   // }
// }
