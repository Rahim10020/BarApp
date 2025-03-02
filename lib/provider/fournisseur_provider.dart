import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/fournisseur.dart';

class FournisseurProvider extends ChangeNotifier {
  late Box<Fournisseur> _fournisseurBox;
  List<Fournisseur> _fournisseurs = [];

  List<Fournisseur> get fournisseurs => _fournisseurs;

  /// Permet d'initialiser le provider
  Future<void> init() async {
    _fournisseurBox = await Hive.openBox<Fournisseur>("fournisseursBox");
    _fournisseurs = _fournisseurBox.values.toList();
    notifyListeners();
  }

  Future<void> ajouter(Fournisseur fournisseur) async {
    if (!_fournisseurBox.containsKey(fournisseur.id)) {
      // Utilisation de fournisseur.id comme clé
      await _fournisseurBox.put(fournisseur.id, fournisseur);

      _fournisseurs = _fournisseurBox.values.toList();

      notifyListeners();
    }
  }

  Future<Fournisseur?> trouver(int id) async {
    return _fournisseurBox.get(id);
  }

  Future<void> modifier(Fournisseur fournisseur) async {
    if (_fournisseurBox.containsKey(fournisseur.id)) {
      // Mise à jour directe via l'id
      _fournisseurBox.put(fournisseur.id, fournisseur);

      _fournisseurs = _fournisseurBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> supprimer(int id) async {
    if (_fournisseurBox.containsKey(id)) {
      await _fournisseurBox.delete(id);
      _fournisseurs = _fournisseurBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> vider() async {
    await _fournisseurBox.clear();
    _fournisseurs = _fournisseurBox.values.toList();
    notifyListeners();
  }
}
