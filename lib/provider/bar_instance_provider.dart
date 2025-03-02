import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/bar_instance.dart';

class BarInstanceProvider extends ChangeNotifier {
  late Box<BarInstance> _barInstanceBox;
  List<BarInstance> _barInstances = [];

  List<BarInstance> get barInstances => _barInstances;

  /// Permet d'initialiser le provider
  Future<void> init() async {
    _barInstanceBox = await Hive.openBox<BarInstance>("barInstancesBox");
    _barInstances = _barInstanceBox.values.toList();
    notifyListeners();
  }

  Future<void> ajouter(BarInstance barInstance) async {
    if (!_barInstanceBox.containsKey(barInstance.id)) {
      // Utilisation de barInstance.id comme clé
      await _barInstanceBox.put(barInstance.id, barInstance);

      _barInstances = _barInstanceBox.values.toList();

      notifyListeners();
    }
  }

  Future<BarInstance?> trouver(int id) async {
    return _barInstanceBox.get(id);
  }

  Future<void> modifier(BarInstance barInstance) async {
    if (_barInstanceBox.containsKey(barInstance.id)) {
      // Mise à jour directe via l'id
      _barInstanceBox.put(barInstance.id, barInstance);

      _barInstances = _barInstanceBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> supprimer(int id) async {
    if (_barInstanceBox.containsKey(id)) {
      await _barInstanceBox.delete(id);
      _barInstances = _barInstanceBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> vider() async {
    await _barInstanceBox.clear();
    _barInstances = _barInstanceBox.values.toList();
    notifyListeners();
  }
}
