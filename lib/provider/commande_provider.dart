import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/commande.dart';

class CommandeProvider extends ChangeNotifier {
  late Box<Commande> _commandeBox;
  List<Commande> _commandes = [];

  List<Commande> get commandes => _commandes;

  /// Permet d'initialiser le provider
  Future<void> init() async {
    _commandeBox = await Hive.openBox<Commande>("commandesBox");
    _commandes = _commandeBox.values.toList();
    notifyListeners();
  }

  Future<void> ajouter(Commande commande) async {
    if (!_commandeBox.containsKey(commande.id)) {
      // Utilisation de commande.id comme clé
      await _commandeBox.put(commande.id, commande);

      _commandes = _commandeBox.values.toList();

      notifyListeners();
    }
  }

  Future<Commande?> trouver(int id) async {
    return _commandeBox.get(id);
  }

  Future<void> modifier(Commande commande) async {
    if (_commandeBox.containsKey(commande.id)) {
      // Mise à jour directe via l'id
      _commandeBox.put(commande.id, commande);

      _commandes = _commandeBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> supprimer(int id) async {
    if (_commandeBox.containsKey(id)) {
      await _commandeBox.delete(id);
      _commandes = _commandeBox.values.toList();

      notifyListeners();
    }
  }

  Future<void> vider() async {
    await _commandeBox.clear();
    _commandes = _commandeBox.values.toList();
    notifyListeners();
  }
}
