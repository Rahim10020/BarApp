// import 'package:flutter/material.dart';
// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:projet7/models/boisson.dart';
// import 'package:projet7/models/casier.dart';

// class IsarDatabase extends ChangeNotifier {
//   // Initialiser la base de donnees
//   static late Isar isar;

//   static Future<void> initialize() async {
//     final dir = await getApplicationDocumentsDirectory();
//     isar = await Isar.open([BoissonSchema, CasierSchema], directory: dir.path);
//   }

//   // --------------------------  GERAGE DES BOISSONS ------------------------------

//   // liste de boissons
//   final List<Boisson> mesBoissons = [];

//   // CRUD operations

//   // create - add to the database
//   Future<void> ajouterBoisson(String nom, double prix, int casier,
//       int nbParCasiers, Modele modele) async {
//     final newNom = Boisson()..nom = nom;
//     final newPrix = Boisson()..prix = prix;
//     final newCasier = Boisson()..casiers = casier;
//     final newNbCasiers = Boisson()..nbBouteilleParCasier = nbParCasiers;
//     final newModele = Boisson()..modele = modele;

//     await isar.writeTxn(() => isar.boissons.put(newNom));
//     await isar.writeTxn(() => isar.boissons.put(newPrix));
//     await isar.writeTxn(() => isar.boissons.put(newCasier));
//     await isar.writeTxn(() => isar.boissons.put(newNbCasiers));
//     await isar.writeTxn(() => isar.boissons.put(newModele));

//     fetchBoissons();
//   }
//   // read

//   Future<void> fetchBoissons() async {
//     List<Boisson> fetchedBoissons = await isar.boissons.where().findAll();
//     mesBoissons.clear();
//     mesBoissons.addAll(fetchedBoissons);
//     notifyListeners();
//   }

//   // update
//   Future<void> updateBoisson(
//       int id, double prix, int casier, int nbParCasiers, Modele modele) async {
//     final maBoisson = await isar.boissons.get(id);
//     if (maBoisson != null) {
//       maBoisson.modele = modele;
//       maBoisson.casiers = casier;
//       maBoisson.nbBouteilleParCasier = nbParCasiers;
//       maBoisson.prix = prix;

//       await isar.writeTxn(() => isar.boissons.put(maBoisson));
//       await fetchBoissons();
//     }
//   }

//   // delete

//   Future<void> deleteBoisson(int id) async {
//     await isar.writeTxn(() => isar.boissons.delete(id));
//     await fetchBoissons();
//   }

//   // --------------------------- GERAGE DES CASIERS ------------------------

//   // CRUD OPERATIONS

//   // liste De casiers
//   List<Casier> mesCasiers = [];
//   // create
//   Future<void> ajouterCasier(int nbr) async {
//     final newNBR = Casier()..nbBouteillesRestantes = nbr;
//     await isar.writeTxn(() => isar.casiers.put(newNBR));
//     await fetchCasiers();
//   }

//   // read
//   Future<void> fetchCasiers() async {
//     List<Casier> fetchedCasiers = await isar.casiers.where().findAll();
//     mesCasiers.clear();
//     mesCasiers.addAll(fetchedCasiers);
//     notifyListeners();
//   }

//   // update
//   Future<void> updateCasier(int id, int nbRest) async {
//     final casier = await isar.casiers.get(id);
//     if (casier != null) {
//       casier.nbBouteillesRestantes = nbRest;
//       await isar.writeTxn(() => isar.casiers.put(casier));
//       await fetchCasiers();
//     }
//   }
//   // delete

//   Future<void> deleteCasier(int id) async {
//     await isar.writeTxn(() => isar.casiers.delete(id));
//     await fetchCasiers();
//   }
// }
