import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/vente.dart';

class VenteProvider extends ChangeNotifier {
  late Box<Vente> _venteBox;
  List<Vente> _ventes = [];

  List<Vente> get ventes => _ventes;

  /// Permet d'initialiser le provider
  Future<void> init() async {
    _venteBox = await Hive.openBox<Vente>("ventesBox");
    _ventes = _venteBox.values.toList();
    notifyListeners();
  }

  Future<void> ajouter(Vente vente) async {
    if (!_venteBox.containsKey(vente.id)) {
      // Utilisation de vente.id comme clé
      await _venteBox.put(vente.id, vente);

      _ventes = _venteBox.values.toList();

      notifyListeners();
    }
  }

  Future<Vente?> trouver(int id) async {
    return _venteBox.get(id);
  }

  Future<void> modifier(Vente vente) async {
    if (_venteBox.containsKey(vente.id)) {
      // Mise à jour directe via l'id
      _venteBox.put(vente.id, vente);

      _ventes = _venteBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> supprimer(int id) async {
    if (_venteBox.containsKey(id)) {
      await _venteBox.delete(id);
      _ventes = _venteBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> viderBoissons() async {
    await _venteBox.clear();
    _ventes = _venteBox.values.toList();
    notifyListeners();
  }
}
