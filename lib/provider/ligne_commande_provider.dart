import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/ligne_commande.dart';

class LigneCommandeProvider extends ChangeNotifier {
  late Box<LigneCommande> _ligneCommandeBox;
  List<LigneCommande> _ligneCommandes = [];

  List<LigneCommande> get ligneCommandes => _ligneCommandes;

  /// Permet d'initialiser le provider
  Future<void> init() async {
    _ligneCommandeBox = await Hive.openBox<LigneCommande>("lignesCommandesBox");
    _ligneCommandes = _ligneCommandeBox.values.toList();
    notifyListeners();
  }

  Future<void> ajouter(LigneCommande ligneCommande) async {
    if (!_ligneCommandeBox.containsKey(ligneCommande.id)) {
      // Utilisation de ligneCommande.id comme clé
      await _ligneCommandeBox.put(ligneCommande.id, ligneCommande);

      _ligneCommandes = _ligneCommandeBox.values.toList();

      notifyListeners();
    }
  }

  Future<LigneCommande?> trouver(int id) async {
    return _ligneCommandeBox.get(id);
  }

  Future<void> modifier(LigneCommande ligneCommande) async {
    if (_ligneCommandeBox.containsKey(ligneCommande.id)) {
      // Mise à jour directe via l'id
      _ligneCommandeBox.put(ligneCommande.id, ligneCommande);

      _ligneCommandes = _ligneCommandeBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> supprimer(int id) async {
    if (_ligneCommandeBox.containsKey(id)) {
      await _ligneCommandeBox.delete(id);
      _ligneCommandes = _ligneCommandeBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> vider() async {
    await _ligneCommandeBox.clear();
    _ligneCommandes = _ligneCommandeBox.values.toList();
    notifyListeners();
  }
}
