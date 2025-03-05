import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/refrigerateur.dart';

class RefrigerateurProvider extends ChangeNotifier {
  late Box<Refrigerateur> _refrigerateurBox;
  List<Refrigerateur> _refrigerateurs = [];

  List<Refrigerateur> get refrigerateurs => _refrigerateurs;

  /// Permet d'initialiser le provider
  Future<void> init() async {
    _refrigerateurBox = await Hive.openBox<Refrigerateur>("refrigerateursBox");
    _refrigerateurs = _refrigerateurBox.values.toList();

    notifyListeners();
  }

  Future<void> ajouter(Refrigerateur refrigerateur) async {
    if (!_refrigerateurBox.containsKey(refrigerateur.id)) {
      // Utilisation de refrigerateur.id comme clé
      await _refrigerateurBox.put(refrigerateur.id, refrigerateur);

      _refrigerateurs = _refrigerateurBox.values.toList();

      notifyListeners();
    }
  }

  Future<Refrigerateur?> trouver(int id) async {
    return _refrigerateurBox.get(id);
  }

  Future<void> modifier(Refrigerateur refrigerateur) async {
    if (_refrigerateurBox.containsKey(refrigerateur.id)) {
      // Mise à jour directe via l'id
      _refrigerateurBox.put(refrigerateur.id, refrigerateur);

      _refrigerateurs = _refrigerateurBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> supprimer(int id) async {
    if (_refrigerateurBox.containsKey(id)) {
      await _refrigerateurBox.delete(id);
      _refrigerateurs = _refrigerateurBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> vider() async {
    await _refrigerateurBox.clear();
    _refrigerateurs = _refrigerateurBox.values.toList();
    notifyListeners();
  }
}
