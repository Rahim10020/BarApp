import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:projet7/models/casier.dart';

class CasierDatabase extends ChangeNotifier {
  static late Isar isar;

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([CasierSchema], directory: dir.path);
  }

  // CRUD OPERATIONS

  // liste De casiers
  List<Casier> mesCasiers = [];
  // create
  Future<void> ajouterCasier(int nbr) async {
    final newNBR = Casier()..nbBouteillesRestantes = nbr;
    await isar.writeTxn(() => isar.casiers.put(newNBR));
    await fetchCasiers();
  }

  // read
  Future<void> fetchCasiers() async {
    List<Casier> fetchedCasiers = await isar.casiers.where().findAll();
    mesCasiers.clear();
    mesCasiers.addAll(fetchedCasiers);
    notifyListeners();
  }

  // update
  Future<void> updateCasier(int id, int nbRest) async {
    final casier = await isar.casiers.get(id);
    if (casier != null) {
      casier.nbBouteillesRestantes = nbRest;
      await isar.writeTxn(() => isar.casiers.put(casier));
      await fetchCasiers();
    }
  }
  // delete

  Future<void> deleteCasier(int id) async {
    await isar.writeTxn(() => isar.casiers.delete(id));
    await fetchCasiers();
  }
}
