import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/ligne_vente.dart';

class LigneVenteProvider extends ChangeNotifier {
  late Box<LigneVente> _ligneVenteBox;
  List<LigneVente> _ligneVentes = [];

  List<LigneVente> get ligneVentes => _ligneVentes;

  /// Permet d'initialiser le provider
  Future<void> init() async {
    _ligneVenteBox = await Hive.openBox<LigneVente>("lignesVentesBox");
    _ligneVentes = _ligneVenteBox.values.toList();
    notifyListeners();
  }

  Future<void> ajouter(LigneVente ligneVente) async {
    if (!_ligneVenteBox.containsKey(ligneVente.id)) {
      // Utilisation de ligneVente.id comme clé
      await _ligneVenteBox.put(ligneVente.id, ligneVente);

      _ligneVentes = _ligneVenteBox.values.toList();

      notifyListeners();
    }
  }

  Future<LigneVente?> trouver(int id) async {
    return _ligneVenteBox.get(id);
  }

  Future<void> modifier(LigneVente ligneVente) async {
    if (_ligneVenteBox.containsKey(ligneVente.id)) {
      // Mise à jour directe via l'id
      _ligneVenteBox.put(ligneVente.id, ligneVente);

      _ligneVentes = _ligneVenteBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> supprimer(int id) async {
    if (_ligneVenteBox.containsKey(id)) {
      await _ligneVenteBox.delete(id);
      _ligneVentes = _ligneVenteBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> vider() async {
    await _ligneVenteBox.clear();
    _ligneVentes = _ligneVenteBox.values.toList();
    notifyListeners();
  }
}
