// import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
// import 'package:projet7/models/bar_instance.dart';
// import 'package:projet7/models/boisson.dart';
// import 'package:projet7/models/casier.dart';
// import 'package:projet7/models/commande.dart';
// import 'package:projet7/models/fournisseur.dart';
// import 'package:projet7/models/ligne_commande.dart';
// import 'package:projet7/models/ligne_vente.dart';
// import 'package:projet7/models/refrigerateur.dart';
// import 'package:projet7/models/vente.dart';

// class BarProvider extends ChangeNotifier {
//   late Box<BarInstance> _barInstanceBox;
//   List<BarInstance> _barInstances = [];
//   late Box<Boisson> _boissonBox;
//   List<Boisson> _boissons = [];
//   late Box<Casier> _casierBox;
//   List<Casier> _casiers = [];
//   late Box<Commande> _commandeBox;
//   List<Commande> _commandes = [];
//   late Box<Fournisseur> _fournisseurBox;
//   List<Fournisseur> _fournisseurs = [];
//   late Box<LigneCommande> _ligneCommandeBox;
//   List<LigneCommande> _ligneCommandes = [];
//   late Box<LigneVente> _ligneVenteBox;
//   List<LigneVente> _ligneVentes = [];
//   late Box<Refrigerateur> _refrigerateurBox;
//   List<Refrigerateur> _refrigerateurs = [];
//   late Box<Vente> _venteBox;
//   List<Vente> _ventes = [];

//   List<Vente> get ventes => _ventes;
//   List<Refrigerateur> get refrigerateurs => _refrigerateurs;
//   List<LigneVente> get ligneVentes => _ligneVentes;
//   List<LigneCommande> get ligneCommandes => _ligneCommandes;
//   List<Fournisseur> get fournisseurs => _fournisseurs;
//   List<Commande> get commandes => _commandes;
//   List<Casier> get casiers => _casiers;
//   List<Boisson> get boissons => _boissons;
//   List<BarInstance> get barInstances => _barInstances;

//   /// Permet d'initialiser le provider
//   Future<void> initHive() async {
//     _barInstanceBox = await Hive.openBox<BarInstance>("barInstancesBox");
//     _barInstances = _barInstanceBox.values.toList();
//     _boissonBox = await Hive.openBox<Boisson>("boissonsBox");
//     _boissons = _boissonBox.values.toList();
//     _casierBox = await Hive.openBox<Casier>("casiersBox");
//     _casiers = _casierBox.values.toList();
//     _commandeBox = await Hive.openBox<Commande>("commandesBox");
//     _commandes = _commandeBox.values.toList();
//     _fournisseurBox = await Hive.openBox<Fournisseur>("fournisseursBox");
//     _fournisseurs = _fournisseurBox.values.toList();
//     _ligneCommandeBox = await Hive.openBox<LigneCommande>("lignesCommandesBox");
//     _ligneCommandes = _ligneCommandeBox.values.toList();
//     _ligneVenteBox = await Hive.openBox<LigneVente>("lignesVentesBox");
//     _ligneVentes = _ligneVenteBox.values.toList();
//     _refrigerateurBox = await Hive.openBox<Refrigerateur>("refrigerateursBox");
//     _refrigerateurs = _refrigerateurBox.values.toList();
//     _venteBox = await Hive.openBox<Vente>("ventesBox");
//     _ventes = _venteBox.values.toList();
//     notifyListeners();
//   }

//   // Opérations d'ajout

//   Future<void> ajouterBarInstance(BarInstance barInstance) async {
//     if (!_barInstanceBox.containsKey(barInstance.id)) {
//       // Utilisation de barInstance.id comme clé
//       await _barInstanceBox.put(barInstance.id, barInstance);

//       _barInstances = _barInstanceBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> ajouterBoisson(Boisson boisson) async {
//     if (!_boissonBox.containsKey(boisson.id)) {
//       // Utilisation de boisson.id comme clé
//       await _boissonBox.put(boisson.id, boisson);

//       _boissons = _boissonBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> ajouterCasier(Casier casier) async {
//     if (!_casierBox.containsKey(casier.id)) {
//       // Utilisation de casier.id comme clé
//       await _casierBox.put(casier.id, casier);

//       _casiers = _casierBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> ajouterCommande(Commande commande) async {
//     if (!_commandeBox.containsKey(commande.id)) {
//       // Utilisation de commande.id comme clé
//       await _commandeBox.put(commande.id, commande);

//       _commandes = _commandeBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> ajouterFournisseur(Fournisseur fournisseur) async {
//     if (!_fournisseurBox.containsKey(fournisseur.id)) {
//       // Utilisation de fournisseur.id comme clé
//       await _fournisseurBox.put(fournisseur.id, fournisseur);

//       _fournisseurs = _fournisseurBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> ajouterLigneCommande(LigneCommande ligneCommande) async {
//     if (!_ligneCommandeBox.containsKey(ligneCommande.id)) {
//       // Utilisation de ligneCommande.id comme clé
//       await _ligneCommandeBox.put(ligneCommande.id, ligneCommande);

//       _ligneCommandes = _ligneCommandeBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> ajouterLigneVente(LigneVente ligneVente) async {
//     if (!_ligneVenteBox.containsKey(ligneVente.id)) {
//       // Utilisation de ligneVente.id comme clé
//       await _ligneVenteBox.put(ligneVente.id, ligneVente);

//       _ligneVentes = _ligneVenteBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> ajouterRefrigerateur(Refrigerateur refrigerateur) async {
//     if (!_refrigerateurBox.containsKey(refrigerateur.id)) {
//       // Utilisation de refrigerateur.id comme clé
//       await _refrigerateurBox.put(refrigerateur.id, refrigerateur);

//       _refrigerateurs = _refrigerateurBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> ajouterVente(Vente vente) async {
//     if (!_venteBox.containsKey(vente.id)) {
//       // Utilisation de vente.id comme clé
//       await _venteBox.put(vente.id, vente);

//       _ventes = _venteBox.values.toList();

//       notifyListeners();
//     }
//   }

//   // Opérations de lecture

//   Future<BarInstance?> trouverBarInstance(int id) async {
//     return _barInstanceBox.get(id);
//   }

//   Future<Boisson?> trouverBoisson(int id) async {
//     return _boissonBox.get(id);
//   }

//   Future<Casier?> trouverCasier(int id) async {
//     return _casierBox.get(id);
//   }

//   Future<Commande?> trouverCommande(int id) async {
//     return _commandeBox.get(id);
//   }

//   Future<Fournisseur?> trouverFournisseur(int id) async {
//     return _fournisseurBox.get(id);
//   }

//   Future<LigneCommande?> trouverLigneCommande(int id) async {
//     return _ligneCommandeBox.get(id);
//   }

//   Future<LigneVente?> trouverLigneVente(int id) async {
//     return _ligneVenteBox.get(id);
//   }

//   Future<Refrigerateur?> trouverRefrigerateur(int id) async {
//     return _refrigerateurBox.get(id);
//   }

//   Future<Vente?> trouverVente(int id) async {
//     return _venteBox.get(id);
//   }

//   // Opérations de modification

//   Future<void> modifierBarInstance(BarInstance barInstance) async {
//     if (_barInstanceBox.containsKey(barInstance.id)) {
//       // Mise à jour directe via l'id
//       _barInstanceBox.put(barInstance.id, barInstance);

//       _barInstances = _barInstanceBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> modifierBoisson(Boisson boisson) async {
//     if (_boissonBox.containsKey(boisson.id)) {
//       // Mise à jour directe via l'id
//       _boissonBox.put(boisson.id, boisson);

//       _boissons = _boissonBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> modifierCasier(Casier casier) async {
//     if (_casierBox.containsKey(casier.id)) {
//       // Mise à jour directe via l'id
//       _casierBox.put(casier.id, casier);

//       _casiers = _casierBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> modifierCommande(Commande commande) async {
//     if (_commandeBox.containsKey(commande.id)) {
//       // Mise à jour directe via l'id
//       _commandeBox.put(commande.id, commande);

//       _commandes = _commandeBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> modifierFournisseur(Fournisseur fournisseur) async {
//     if (_fournisseurBox.containsKey(fournisseur.id)) {
//       // Mise à jour directe via l'id
//       _fournisseurBox.put(fournisseur.id, fournisseur);

//       _fournisseurs = _fournisseurBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> modifierLigneCommande(LigneCommande ligneCommande) async {
//     if (_ligneCommandeBox.containsKey(ligneCommande.id)) {
//       // Mise à jour directe via l'id
//       _ligneCommandeBox.put(ligneCommande.id, ligneCommande);

//       _ligneCommandes = _ligneCommandeBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> modifierLigneVente(LigneVente ligneVente) async {
//     if (_ligneVenteBox.containsKey(ligneVente.id)) {
//       // Mise à jour directe via l'id
//       _ligneVenteBox.put(ligneVente.id, ligneVente);

//       _ligneVentes = _ligneVenteBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> modifierRefrigerateur(Refrigerateur refrigerateur) async {
//     if (_refrigerateurBox.containsKey(refrigerateur.id)) {
//       // Mise à jour directe via l'id
//       _refrigerateurBox.put(refrigerateur.id, refrigerateur);

//       _refrigerateurs = _refrigerateurBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> modifierVente(Vente vente) async {
//     if (_venteBox.containsKey(vente.id)) {
//       // Mise à jour directe via l'id
//       _venteBox.put(vente.id, vente);

//       _ventes = _venteBox.values.toList();

//       notifyListeners();
//     }
//   }

//   // Opérations de suppression

//   Future<void> supprimerBarInstance(int id) async {
//     if (_barInstanceBox.containsKey(id)) {
//       await _barInstanceBox.delete(id);
//       _barInstances = _barInstanceBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> supprimerBoisson(int id) async {
//     if (_boissonBox.containsKey(id)) {
//       await _boissonBox.delete(id);
//       _boissons = _boissonBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> supprimerCasier(int id) async {
//     if (_casierBox.containsKey(id)) {
//       await _casierBox.delete(id);
//       _casiers = _casierBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> supprimerCommande(int id) async {
//     if (_commandeBox.containsKey(id)) {
//       await _commandeBox.delete(id);
//       _commandes = _commandeBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> supprimerFournisseur(int id) async {
//     if (_fournisseurBox.containsKey(id)) {
//       await _fournisseurBox.delete(id);
//       _fournisseurs = _fournisseurBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> supprimerLigneCommande(int id) async {
//     if (_ligneCommandeBox.containsKey(id)) {
//       await _ligneCommandeBox.delete(id);
//       _ligneCommandes = _ligneCommandeBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> supprimerLigneVente(int id) async {
//     if (_ligneVenteBox.containsKey(id)) {
//       await _ligneVenteBox.delete(id);
//       _ligneVentes = _ligneVenteBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> supprimerRefrigerateur(int id) async {
//     if (_refrigerateurBox.containsKey(id)) {
//       await _refrigerateurBox.delete(id);
//       _refrigerateurs = _refrigerateurBox.values.toList();

//       notifyListeners();
//     }
//   }

//   Future<void> supprimerVente(int id) async {
//     if (_venteBox.containsKey(id)) {
//       await _venteBox.delete(id);
//       _ventes = _venteBox.values.toList();

//       notifyListeners();
//     }
//   }

//   // Opérations secondaires

//   Future<void> viderBarInstances() async {
//     await _barInstanceBox.clear();
//     _barInstances = _barInstanceBox.values.toList();
//     notifyListeners();
//   }

//   Future<void> viderBoissons() async {
//     await _boissonBox.clear();
//     _boissons = _boissonBox.values.toList();
//     notifyListeners();
//   }

//   Future<void> viderCasiers() async {
//     await _casierBox.clear();
//     _casiers = _casierBox.values.toList();
//     notifyListeners();
//   }

//   Future<void> viderCommandes() async {
//     await _commandeBox.clear();
//     _commandes = _commandeBox.values.toList();
//     notifyListeners();
//   }

//   Future<void> viderFournisseurs() async {
//     await _fournisseurBox.clear();
//     _fournisseurs = _fournisseurBox.values.toList();
//     notifyListeners();
//   }

//   Future<void> viderLignesCommande() async {
//     await _ligneCommandeBox.clear();
//     _ligneCommandes = _ligneCommandeBox.values.toList();
//     notifyListeners();
//   }

//   Future<void> viderLignesVente() async {
//     await _ligneVenteBox.clear();
//     _ligneVentes = _ligneVenteBox.values.toList();
//     notifyListeners();
//   }

//   Future<void> viderRefrigerateurs() async {
//     await _refrigerateurBox.clear();
//     _refrigerateurs = _refrigerateurBox.values.toList();
//     notifyListeners();
//   }

//   Future<void> viderVentes() async {
//     await _venteBox.clear();
//     _ventes = _venteBox.values.toList();
//     notifyListeners();
//   }
// }

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
