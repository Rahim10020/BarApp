import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/bar_instance.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/models/vente.dart';

class BarProvider with ChangeNotifier {
  late Box<BarInstance> _barBox;
  late Box<Boisson> _boissonBox;
  late Box<Casier> _casierBox;
  late Box<Commande> _commandeBox;
  late Box<Fournisseur> _fournisseurBox;
  late Box<Refrigerateur> _refrigerateurBox;
  late Box<Vente> _venteBox;

  BarInstance? _currentBar;

  BarProvider() {
    _initHive();
  }

  Future<void> _initHive() async {
    _barBox = await Hive.openBox<BarInstance>('bars');
    _boissonBox = await Hive.openBox<Boisson>('boissons');
    _casierBox = await Hive.openBox<Casier>('casiers');
    _commandeBox = await Hive.openBox<Commande>('commandes');
    _fournisseurBox = await Hive.openBox<Fournisseur>('fournisseurs');
    _refrigerateurBox = await Hive.openBox<Refrigerateur>('refrigerateurs');
    _venteBox = await Hive.openBox<Vente>('ventes');

    if (_barBox.isEmpty) {
      _currentBar = null;
    } else {
      _currentBar = _barBox.values.first;
    }
    notifyListeners();
  }

  int generateUniqueId() => DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF;

  Future<void> ajouterBoissonsAuRefrigerateur(
      int casierId, int refrigerateurId, int nombre) async {
    // Récupérer le casier et le réfrigérateur depuis Hive
    var casier = _casierBox.values.firstWhere((c) => c.id == casierId,
        orElse: () => throw Exception('Casier non trouvé'));
    var refrigerateur = _refrigerateurBox.values.firstWhere(
        (r) => r.id == refrigerateurId,
        orElse: () => throw Exception('Réfrigérateur non trouvé'));

    // Vérifier qu'il y a assez de boissons dans le casier
    if (casier.boissons.length < nombre || nombre <= 0) {
      throw Exception(
          'Nombre de boissons invalide ou insuffisant dans le casier');
    }

    // Initialiser la liste des boissons du réfrigérateur si elle est null
    refrigerateur.boissons ??= [];

    // Transférer les boissons (prendre les "nombre" premières boissons du casier)
    List<Boisson> boissonsATransferer = casier.boissons.sublist(0, nombre);
    refrigerateur.boissons!.addAll(boissonsATransferer);
    casier.boissons.removeRange(0, nombre);

    // Mettre à jour le nombre total de boissons dans le casier
    casier.boissonTotal = casier.boissons.length;

    // Sauvegarder les modifications dans Hive
    int casierIndex = _casierBox.values.toList().indexOf(casier);
    int refrigerateurIndex =
        _refrigerateurBox.values.toList().indexOf(refrigerateur);
    await _casierBox.putAt(casierIndex, casier);
    await _refrigerateurBox.putAt(refrigerateurIndex, refrigerateur);

    // Notifier les écouteurs pour mettre à jour l'UI
    notifyListeners();
  }

  // BarInstance
  BarInstance? get currentBar => _currentBar;
  Future<void> createBar(String nom, String adresse) async {
    _currentBar =
        BarInstance(id: generateUniqueId(), nom: nom, adresse: adresse);
    await _barBox.add(_currentBar!);
    notifyListeners();
  }

  // Boissons
  List<Boisson> get boissons => _boissonBox.values.toList();
  Future<void> addBoisson(Boisson boisson) async {
    await _boissonBox.add(boisson);
    notifyListeners();
  }

  Future<void> updateBoisson(Boisson boisson) async {
    await _boissonBox.putAt(
        _boissonBox.values.toList().indexOf(boisson), boisson);
    notifyListeners();
  }

  Future<void> deleteBoisson(Boisson boisson) async {
    await _boissonBox.deleteAt(_boissonBox.values.toList().indexOf(boisson));
    notifyListeners();
  }

  // Casiers
  List<Casier> get casiers => _casierBox.values.toList();
  Future<void> addCasier(Casier casier) async {
    await _casierBox.add(casier);
    notifyListeners();
  }

  Future<void> updateCasier(Casier casier) async {
    await _casierBox.putAt(_casierBox.values.toList().indexOf(casier), casier);
    notifyListeners();
  }

  Future<void> deleteCasier(Casier casier) async {
    await _casierBox.deleteAt(_casierBox.values.toList().indexOf(casier));
    notifyListeners();
  }

  // Commandes
  List<Commande> get commandes => _commandeBox.values.toList();
  Future<void> addCommande(Commande commande) async {
    await _commandeBox.add(commande);
    notifyListeners();
  }

  Future<void> deleteCommande(Commande commande) async {
    await _commandeBox.deleteAt(_commandeBox.values.toList().indexOf(commande));
    notifyListeners();
  }

  // Fournisseurs
  List<Fournisseur> get fournisseurs => _fournisseurBox.values.toList();
  Future<void> addFournisseur(Fournisseur fournisseur) async {
    await _fournisseurBox.add(fournisseur);
    notifyListeners();
  }

  // Réfrigérateurs
  List<Refrigerateur> get refrigerateurs => _refrigerateurBox.values.toList();
  Future<void> addRefrigerateur(Refrigerateur refrigerateur) async {
    await _refrigerateurBox.add(refrigerateur);
    notifyListeners();
  }

  Future<void> updateRefrigerateur(Refrigerateur refrigerateur) async {
    await _refrigerateurBox.putAt(
        _refrigerateurBox.values.toList().indexOf(refrigerateur),
        refrigerateur);
    notifyListeners();
  }

  Future<void> deleteRefrigerateur(Refrigerateur refrigerateur) async {
    await _refrigerateurBox
        .deleteAt(_refrigerateurBox.values.toList().indexOf(refrigerateur));
    notifyListeners();
  }

  // Ventes
  List<Vente> get ventes => _venteBox.values.toList();
  Future<void> addVente(Vente vente) async {
    await _venteBox.add(vente);
    notifyListeners();
  }
}
