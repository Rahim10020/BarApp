import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/casier.dart';

class CasierProvider extends ChangeNotifier {
  late Box<Casier> _casierBox;
  List<Casier> _casiers = [];

  List<Casier> get casiers => _casiers;

  /// Permet d'initialiser le provider
  Future<void> init() async {
    _casierBox = await Hive.openBox<Casier>("casiersBox");
    _casiers = _casierBox.values.toList();
    notifyListeners();
  }

  Future<void> ajouter(Casier casier) async {
    if (!_casierBox.containsKey(casier.id)) {
      // Utilisation de casier.id comme clé
      await _casierBox.put(casier.id, casier);

      _casiers = _casierBox.values.toList();

      notifyListeners();
    }
  }

  Future<Casier?> trouver(int id) async {
    return _casierBox.get(id);
  }

  Future<void> modifier(Casier casier) async {
    if (_casierBox.containsKey(casier.id)) {
      // Mise à jour directe via l'id
      _casierBox.put(casier.id, casier);

      _casiers = _casierBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> supprimer(int id) async {
    if (_casierBox.containsKey(id)) {
      await _casierBox.delete(id);
      _casiers = _casierBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> vider() async {
    await _casierBox.clear();
    _casiers = _casierBox.values.toList();
    notifyListeners();
  }
}
