import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projet7/models/boisson.dart';

class BoissonDatabase extends ChangeNotifier {
  // Initialiser la base de donnees
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([BoissonSchema], directory: dir.path);
  }

  // liste de boissons
  final List<Boisson> mesBoissons = [];

  // CRUD operations

  // create - add to the database
  Future<void> ajouterBoisson(String nom, double prix, int casier,
      int nbParCasiers, Modele modele) async {
    final newNom = Boisson()..nom = nom;
    final newPrix = Boisson()..prix = prix;
    final newCasier = Boisson()..casiers = casier;
    final newNbCasiers = Boisson()..nbBouteilleParCasier = nbParCasiers;
    final newModele = Boisson()..modele = modele;

    await isar.writeTxn(() => isar.boissons.put(newNom));
    await isar.writeTxn(() => isar.boissons.put(newPrix));
    await isar.writeTxn(() => isar.boissons.put(newCasier));
    await isar.writeTxn(() => isar.boissons.put(newNbCasiers));
    await isar.writeTxn(() => isar.boissons.put(newModele));

    fetchBoissons();
  }
  // read

  Future<void> fetchBoissons() async {
    List<Boisson> fetchedBoissons = await isar.boissons.where().findAll();
    mesBoissons.clear();
    mesBoissons.addAll(fetchedBoissons);
    notifyListeners();
  }

  // update
  Future<void> updateBoisson(
      int id, double prix, int casier, int nbParCasiers, Modele modele) async {
    final maBoisson = await isar.boissons.get(id);
    if (maBoisson != null) {
      maBoisson.modele = modele;
      maBoisson.casiers = casier;
      maBoisson.nbBouteilleParCasier = nbParCasiers;
      maBoisson.prix = prix;

      await isar.writeTxn(() => isar.boissons.put(maBoisson));
      await fetchBoissons();
    }
  }

  // delete

  Future<void> deleteBoisson(int id) async {
    await isar.writeTxn(() => isar.boissons.delete(id));
    await fetchBoissons();
  }
}
