import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/models/modele.dart';

class Bar extends ChangeNotifier {
  late Box<Boisson> _boissonBox;
  late Box<Boisson> _boissonCongeleeBox;
  late Box<Casier> _casierBox;
  late Box<Vente> _venteBox;

  List<Boisson> _boissons = [];
  List<Boisson> _boissonsCongelees = [];
  List<Casier> _casiers = [];
  List<Vente> _ventes = [];

  List<Boisson> get boissons => _boissons;
  List<Boisson> get boissonsCongelees => _boissonsCongelees;
  List<Casier> get casiers => _casiers;
  List<Vente> get ventes => _ventes;

  Future<void> initHive() async {
    _boissonBox = await Hive.openBox<Boisson>("boissonsBox");
    _boissonCongeleeBox = await Hive.openBox<Boisson>("boissonsCongeleesBox");
    _casierBox = await Hive.openBox<Casier>("casiersBox");
    _venteBox = await Hive.openBox<Vente>("ventesBox");

    _boissons = _boissonBox.values.toList();
    _boissonsCongelees = _boissonCongeleeBox.values.toList();
    _casiers = _casierBox.values.toList();
    _ventes = _venteBox.values.toList();

    notifyListeners();
  }

  Future<void> ajouterBoisson(Boisson boisson) async {
    if (!_boissonBox.containsKey(boisson.id)) {
      await _boissonBox.put(
          boisson.id, boisson); // Utilisation de boisson.id comme clé

      _boissons = _boissonBox.values.toList();
    } else {
      modifierBoisson(boisson);
    }
    notifyListeners();
  }

  Future<void> congelerBoisson(Boisson boisson, int quantite) async {
    // Diminuer le stock et mettre à jour dans Hive
    boisson.stock -= quantite;
    await _boissonBox.put(boisson.id, boisson);

    Boisson boissonCongele = Boisson(
      id: DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF,
      nom: boisson.nom,
      prix: boisson.prix,
      modele: boisson.modele,
      stock: quantite,
      description: boisson.description,
      estFroid: true,
      imagePath: boisson.imagePath,
      dateAjout: boisson.dateAjout,
      dateModification: boisson.dateModification,
    );

    if (!_boissonCongeleeBox.containsKey(boissonCongele.id)) {
      await _boissonCongeleeBox.put(
          boissonCongele.id, boisson); // Utilisation de vetement.id comme clé

      _boissonsCongelees = _boissonCongeleeBox.values.toList();
    } else {
      modifierBoissonCongelee(boissonCongele);
    }
    notifyListeners();
  }

  Future<void> decongelerBoisson(Boisson boisson, int quantite) async {
    // Diminuer le stock et mettre à jour dans Hive
    boisson.stock -= quantite;
    await _boissonCongeleeBox.put(boisson.id, boisson);
    ajouterBoisson(Boisson(
      id: DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF,
      nom: boisson.nom,
      prix: boisson.prix,
      modele: boisson.modele,
      stock: quantite,
      description: boisson.description,
      estFroid: false,
      imagePath: boisson.imagePath,
      dateAjout: boisson.dateAjout,
      dateModification: boisson.dateModification,
    ));
    notifyListeners();
  }

  Future<void> ajouterCasier(Casier casier) async {
    if (!_casierBox.containsKey(casier.id)) {
      // Diminuer le stock et mettre à jour dans Hive
      casier.boisson.stock -= casier.quantiteBoisson;
      await _boissonBox.put(casier.boisson.id, casier.boisson);

      await _casierBox.put(
          casier.id, casier); // Utilisation de vetement.id comme clé

      _casiers = _casierBox.values.toList();
    } else {
      modifierCasier(casier);
    }
    notifyListeners();
  }

  Future<void> ajouterVente(Vente vente) async {
    if (vente.boisson.stock >= vente.quantiteVendu) {
      // Diminuer le stock et mettre à jour dans Hive
      vente.boisson.stock -= vente.quantiteVendu;
      await _boissonBox.put(vente.boisson.id, vente.boisson);

      // Ajouter la vente dans Hive
      await _venteBox.put(vente.id, vente);

      // Mettre à jour la liste en mémoire
      _ventes = _venteBox.values.toList();
    }
    notifyListeners();
  }

  Future<void> supprimerBoisson(Boisson boisson) async {
    if (_boissonBox.containsKey(boisson.id)) {
      await _boissonBox.delete(boisson.id);
      _boissons = _boissonBox.values.toList();
    }
    notifyListeners();
  }

  Future<void> supprimerBoissonCongelee(Boisson boisson) async {
    if (_boissonCongeleeBox.containsKey(boisson.id)) {
      await _boissonCongeleeBox.delete(boisson.id);
      _boissonsCongelees = _boissonCongeleeBox.values.toList();
    }
    notifyListeners();
  }

  Future<void> supprimerCasier(Casier casier) async {
    if (_casierBox.containsKey(casier.id)) {
      await _casierBox.delete(casier.id);
      _casiers = _casierBox.values.toList();
    }
    notifyListeners();
  }

  void supprimerVente(int id) {
    // Trouver la vente dans Hive avec la clé ID
    Vente? vente = _venteBox.get(id);

    if (vente != null) {
      // Supprimer la vente
      _venteBox.delete(id);

      // Mettre à jour la liste en mémoire
      _ventes = _venteBox.values.toList();
    }

    notifyListeners();
  }

  void modifierBoisson(Boisson boisson) {
    if (_boissonBox.containsKey(boisson.id)) {
      _boissonBox.put(boisson.id, boisson); // Mise à jour directe via l'ID

      _boissons = _boissonBox.values.toList();

      notifyListeners();
    }
  }

  void modifierBoissonCongelee(Boisson boisson) {
    if (_boissonCongeleeBox.containsKey(boisson.id)) {
      _boissonCongeleeBox.put(
          boisson.id, boisson); // Mise à jour directe via l'ID

      _boissonsCongelees = _boissonCongeleeBox.values.toList();

      notifyListeners();
    }
  }

  void modifierCasier(Casier casier) {
    if (_casierBox.containsKey(casier.id)) {
      _casierBox.put(casier.id, casier); // Mise à jour directe via l'ID

      // _casierHistoriqueBox.put(
      //     casier.id, casier); // Mise à jour directe via l'ID

      _casiers = _casierBox.values.toList();

      // _vetementsHistorique = _vetementHistoriqueBox.values.toList();
      notifyListeners();
    }
  }

  List<Casier> getRecentCasiers() {
    List<Casier> casiersTriees = List.from(_casiers);
    casiersTriees.sort((a, b) => b.dateCreation.compareTo(a.dateCreation));
    return casiersTriees;
  }

  List<Vente> getVentesPopulaire() {
    List<Vente> ventesPopulaires = [];
    List<int> quantitesTotales = [];

    // Parcourir toutes les ventes et cumuler la quantité pour chaque vêtement
    for (var vente in _ventes) {
      int index = ventesPopulaires.indexWhere(
        (v) => v.boisson.id == vente.boisson.id,
      );

      if (index == -1) {
        ventesPopulaires.add(vente);
        quantitesTotales.add(vente.quantiteVendu);
      } else {
        quantitesTotales[index] += vente.quantiteVendu;
      }
    }

    List<Vente> ventesTries = List.from(ventesPopulaires);

    ventesTries.sort((a, b) {
      int indexA = ventesPopulaires.indexOf(a);
      int indexB = ventesPopulaires.indexOf(b);
      return quantitesTotales[indexB].compareTo(quantitesTotales[indexA]);
    });

    return ventesTries;
  }

  List<List<Vente>> getVentesPopulaire2() {
    Map<int, List<Vente>> ventesGroupees = {};

    for (var vente in _ventes) {
      ventesGroupees.putIfAbsent(vente.boisson.id, () => []).add(vente);
    }

    return ventesGroupees.values.toList();
  }

  List<List<Vente>> getVentesLesPlusVendues() {
    List<List<Vente>> ventesGroupees = getVentesPopulaire2();

    // Trier les ventes en fonction de la valeur totale (quantité * prix)
    ventesGroupees.sort((a, b) {
      double totalA =
          a.fold(0, (sum, v) => sum + (v.quantiteVendu * v.boisson.prix.last));
      double totalB =
          b.fold(0, (sum, v) => sum + (v.quantiteVendu * v.boisson.prix.last));
      return totalB.compareTo(totalA); // Tri décroissant
    });

    return ventesGroupees;
  }

  List<Boisson> getPetitModele() {
    return _boissons.where((b) => b.modele == Modele.petit).toList();
  }

  List<Boisson> getGrandModele() {
    return _boissons.where((b) => b.modele == Modele.grand).toList();
  }

  List<Casier> trierCasierParPrix(List<Casier> casiers) {
    List<Casier> casiersParPrix = List.from(casiers);
    casiersParPrix.sort(
      (a, b) => a.prixTotal.compareTo(b.prixTotal),
    );
    return casiersParPrix;
  }

  List<Casier> trierCasierParBoisson(List<Casier> casiers) {
    List<Casier> casiersParBoisson = List.from(casiers);
    casiers.sort(
      (a, b) => a.boisson.nom!.compareTo(b.boisson.nom!),
    );

    return casiersParBoisson;
  }

  String getPrixTotal() {
    double totalPrix = 0.0;

    for (Vente vente in _ventes) {
      totalPrix += vente.prixTotal;
    }

    return NumberFormat.currency(
            locale: "fr_FR", symbol: "FCFA", decimalDigits: 0)
        .format(totalPrix);
  }

  List<Vente> getGrandesVentes() {
    List<Vente> ventesTriees = List.from(_ventes);
    ventesTriees.sort((a, b) => (b.quantiteVendu * b.boisson.prix.last)
        .compareTo(a.quantiteVendu * a.boisson.prix.last));
    return ventesTriees;
  }

  List<Vente> getPetitesVentes() {
    List<Vente> ventesTriees = List.from(_ventes);
    ventesTriees.sort((a, b) => (a.quantiteVendu * a.boisson.prix.last)
        .compareTo(b.quantiteVendu * b.boisson.prix.last));
    return ventesTriees;
  }

  Future<void> viderBoissons() async {
    await _boissonBox.clear();
    _boissons = _boissonBox.values.toList();
    notifyListeners();
  }

  Future<void> viderVentes() async {
    await _venteBox.clear();
    _ventes = _venteBox.values.toList();
    notifyListeners();
  }
}
