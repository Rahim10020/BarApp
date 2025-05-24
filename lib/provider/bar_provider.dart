import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/bar_instance.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/id_counter.dart';
import 'package:projet7/models/ligne_commande.dart';
import 'package:projet7/models/ligne_vente.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/models/vente.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:projet7/utils/helpers.dart';
import 'package:collection/collection.dart'; // Ajouté pour firstWhereOrNull

class BarProvider with ChangeNotifier {
  late Box<BarInstance> _barBox;
  late Box<Boisson> _boissonBox;
  late Box<Casier> _casierBox;
  late Box<Commande> _commandeBox;
  late Box<Fournisseur> _fournisseurBox;
  late Box<Refrigerateur> _refrigerateurBox;
  late Box<Vente> _venteBox;
  late Box<IdCounter> _idCounterBox;

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
    _idCounterBox = await Hive.openBox<IdCounter>('id_counters');

    if (_barBox.isEmpty) {
      _currentBar = null;
    } else {
      _currentBar = _barBox.values.first;
    }
    notifyListeners();
  }

  Future<int> generateUniqueId(String entityType) async {
    IdCounter? counter = _idCounterBox.values.firstWhere(
      (c) => c.entityType == entityType,
      orElse: () => IdCounter(entityType: entityType, lastId: 0),
    );

    counter.lastId += 1;

    if (_idCounterBox.values.any((c) => c.entityType == entityType)) {
      int index = _idCounterBox.values
          .toList()
          .indexWhere((c) => c.entityType == entityType);
      await _idCounterBox.putAt(index, counter);
    } else {
      await _idCounterBox.add(counter);
    }

    return counter.lastId;
  }

  Future<String> generateCommandePdf(Commande commande) async {
    final pdf = pw.Document();

    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.grey800,
    );
    final infoStyle = pw.TextStyle(fontSize: 14, color: PdfColors.black);
    final tableHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    final tableCellStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey800, width: 2)),
              ),
              child: pw.Text(
                'Bar: ${commande.barInstance.nom}',
                style: headerStyle,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Commande #${commande.id}', style: subHeaderStyle),
            pw.SizedBox(height: 10),
            pw.Text('Date: ${Helpers.formatterDate(commande.dateCommande)}',
                style: infoStyle),
            pw.Text(
                'Montant Total: ${Helpers.formatterEnCFA(commande.montantTotal)}',
                style: infoStyle),
            pw.Text(
              'Fournisseur: ${commande.fournisseur != null ? commande.fournisseur!.nom : "Inconnu"}',
              style: infoStyle,
            ),
            pw.SizedBox(height: 20),
            pw.Text('Lignes de Commande:', style: subHeaderStyle),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey800),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Casier ID', style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Boisson', style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Nombre de Boissons',
                          style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Montant', style: tableHeaderStyle),
                    ),
                  ],
                ),
                ...commande.lignesCommande.map((ligne) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('Casier #${ligne.casier.id}',
                              style: tableCellStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            ligne.casier.boissons.isNotEmpty
                                ? ligne.casier.boissons[0].nom ?? 'Sans nom'
                                : 'Aucune boisson',
                            style: tableCellStyle,
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('${ligne.casier.boissonTotal}',
                              style: tableCellStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(Helpers.formatterEnCFA(ligne.montant),
                              style: tableCellStyle),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );

    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/commande_${commande.id}.pdf';
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }

    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  Future<String> generateVentePdf(Vente vente) async {
    final pdf = pw.Document();

    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.black,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.grey800,
    );
    final infoStyle = pw.TextStyle(fontSize: 14, color: PdfColors.black);
    final tableHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    final tableCellStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.grey100,
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.grey800, width: 2)),
              ),
              child: pw.Text(
                'Bar: ${_currentBar?.nom ?? "Bar Inconnu"}',
                style: headerStyle,
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Vente #${vente.id}', style: subHeaderStyle),
            pw.SizedBox(height: 10),
            pw.Text('Date: ${Helpers.formatterDate(vente.dateVente)}',
                style: infoStyle),
            pw.Text(
                'Montant Total: ${Helpers.formatterEnCFA(vente.montantTotal)}',
                style: infoStyle),
            pw.SizedBox(height: 20),
            pw.Text('Lignes de Vente:', style: subHeaderStyle),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey800),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Boisson', style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Montant', style: tableHeaderStyle),
                    ),
                  ],
                ),
                ...vente.lignesVente.map((ligne) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(ligne.boisson.nom ?? 'Sans nom',
                              style: tableCellStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(Helpers.formatterEnCFA(ligne.montant),
                              style: tableCellStyle),
                        ),
                      ],
                    )),
              ],
            ),
          ],
        ),
      ),
    );

    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/vente_${vente.id}.pdf';
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }

    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  Future<void> ajouterBoissonsAuRefrigerateur(
      int casierId, int refrigerateurId, int nombre) async {
    Casier? casier = _casierBox.values.firstWhere(
      (c) => c.id == casierId,
      orElse: () => throw Exception('Casier non trouvé'),
    );

    var refrigerateur = _refrigerateurBox.values.firstWhere(
      (r) => r.id == refrigerateurId,
      orElse: () => throw Exception('Réfrigérateur non trouvé'),
    );

    if (casier.boissons.length < nombre || nombre <= 0) {
      throw Exception(
          'Nombre de boissons invalide ou insuffisant dans le casier');
    }

    refrigerateur.boissons ??= [];

    List<Boisson> boissonsATransferer = [];
    for (var b in casier.boissons.sublist(0, nombre)) {
      int newId = await generateUniqueId("Boisson");
      boissonsATransferer.add(Boisson(
        id: newId,
        nom: b.nom,
        prix: List.from(b.prix),
        estFroid: true,
        modele: b.modele,
        description: b.description,
      ));
    }

    refrigerateur.boissons!.addAll(boissonsATransferer);

    casier.boissons.removeRange(0, nombre);
    casier.boissonTotal = casier.boissons.length;

    int casierIndex = _casierBox.values.toList().indexOf(casier);
    await _casierBox.putAt(casierIndex, casier);

    int refrigerateurIndex =
        _refrigerateurBox.values.toList().indexOf(refrigerateur);
    await _refrigerateurBox.putAt(refrigerateurIndex, refrigerateur);

    notifyListeners();
  }

  Future<void> retirerBoissonsDuRefrigerateur(
      int refrigerateurId, Boisson boisson) async {
    var refrigerateur = _refrigerateurBox.values.firstWhere(
      (r) => r.id == refrigerateurId,
      orElse: () => throw Exception('Réfrigérateur non trouvé'),
    );

    if (refrigerateur.boissons == null ||
        !refrigerateur.boissons!.contains(boisson)) {
      throw Exception('Boisson non trouvée dans le réfrigérateur');
    }

    // Trouver un casier correspondant (même nom et modèle)
    Casier? casier = _casierBox.values.firstWhereOrNull(
      (c) =>
          c.boissons.isNotEmpty &&
          c.boissons.first.nom == boisson.nom &&
          c.boissons.first.modele == boisson.modele,
    );

    // Si aucun casier n'existe, créer un nouveau
    if (casier == null) {
      int newId = await generateUniqueId("Casier");
      casier = Casier(
        id: newId,
        boissonTotal: 0,
        boissons: [],
      );
    }

    // Ajouter la boisson au casier
    casier.boissons.add(Boisson(
      id: await generateUniqueId("Boisson"),
      nom: boisson.nom,
      prix: List.from(boisson.prix),
      estFroid: boisson.estFroid,
      modele: boisson.modele,
      description: boisson.description,
    ));
    casier.boissonTotal = casier.boissons.length;

    // Mettre à jour ou ajouter le casier
    if (_casierBox.values.contains(casier)) {
      int casierIndex = _casierBox.values.toList().indexOf(casier);
      await _casierBox.putAt(casierIndex, casier);
    } else {
      await _casierBox.add(casier);
    }

    // Retirer la boisson du réfrigérateur
    refrigerateur.boissons!.remove(boisson);

    int refrigerateurIndex =
        _refrigerateurBox.values.toList().indexOf(refrigerateur);
    await _refrigerateurBox.putAt(refrigerateurIndex, refrigerateur);

    notifyListeners();
  }

  // BarInstance
  BarInstance? get currentBar => _currentBar;
  List<BarInstance> get bars => _barBox.values.toList();
  set currentBar(BarInstance? bar) {
    _currentBar = bar;
    notifyListeners();
  }

  Future<void> createBar(String nom, String adresse) async {
    _currentBar = BarInstance(
      id: await generateUniqueId("BarInstance"),
      nom: nom,
      adresse: adresse,
    );
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
    int index =
        _boissonBox.values.toList().indexWhere((b) => b.id == boisson.id);
    if (index != -1) {
      await _boissonBox.putAt(index, boisson);
      notifyListeners();
    } else {
      throw Exception('Boisson non trouvée pour mise à jour');
    }
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

  Future<void> updateCasier(Casier casier, int index) async {
    if (index < 0 || index >= _casierBox.length) {
      throw Exception('Index invalide pour mise à jour du casier');
    }
    await _casierBox.putAt(index, casier);
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

  Future<void> updateFournisseur(Fournisseur fournisseur) async {
    int index = _fournisseurBox.values
        .toList()
        .indexWhere((f) => f.id == fournisseur.id);
    if (index != -1) {
      await _fournisseurBox.putAt(index, fournisseur);
      notifyListeners();
    } else {
      throw Exception('Fournisseur non trouvé pour mise à jour');
    }
  }

  Future<void> deleteFournisseur(Fournisseur fournisseur) async {
    await _fournisseurBox
        .deleteAt(_fournisseurBox.values.toList().indexOf(fournisseur));
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

  Future<void> deleteVente(Vente vente) async {
    await _venteBox.deleteAt(_venteBox.values.toList().indexOf(vente));
    notifyListeners();
  }
}
