import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/boisson.dart';

class BoissonProvider extends ChangeNotifier {
  late Box<Boisson> _boissonBox;
  List<Boisson> _boissons = [];

  List<Boisson> get boissons => _boissons;

  /// Permet d'initialiser le provider
  Future<void> init() async {
    _boissonBox = await Hive.openBox<Boisson>("boissonsBox");
    _boissons = _boissonBox.values.toList();
    notifyListeners();
  }

  Future<void> ajouter(Boisson boisson) async {
    if (!_boissonBox.containsKey(boisson.id)) {
      // Utilisation de boisson.id comme clé
      await _boissonBox.put(boisson.id, boisson);

      _boissons = _boissonBox.values.toList();

      notifyListeners();
    }
  }

  Future<Boisson?> trouver(int id) async {
    return _boissonBox.get(id);
  }

  Future<void> modifier(Boisson boisson) async {
    if (_boissonBox.containsKey(boisson.id)) {
      // Mise à jour directe via l'id
      _boissonBox.put(boisson.id, boisson);

      _boissons = _boissonBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> supprimer(int id) async {
    if (_boissonBox.containsKey(id)) {
      await _boissonBox.delete(id);
      _boissons = _boissonBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> vider() async {
    await _boissonBox.clear();
    _boissons = _boissonBox.values.toList();
    notifyListeners();
  }
}
