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
import 'package:collection/collection.dart';

class BarProvider with ChangeNotifier {
  late Box<BarInstance> _barBox;
  late Box<Boisson> _boissonBox;
  late Box<Commande> _commandeBox;
  late Box<Fournisseur> _fournisseurBox;
  late Box<Refrigerateur> _refrigerateurBox;
  late Box<Vente> _venteBox;
  late Box<IdCounter> _idCounterBox;

  BarInstance? _currentBar;

  BarProvider();

  Future<void> initProvider() async {
    await _initHive();
  }

  Future<void> _initHive() async {
    _barBox = await Hive.openBox<BarInstance>('bars');
    _boissonBox = await Hive.openBox<Boisson>('boissons');
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

  Future<void> updateBar(String nom, String adresse) async {
    if (_currentBar == null) {
      throw Exception('Aucun bar configuré');
    }
    if (nom.trim().isEmpty || adresse.trim().isEmpty) {
      throw Exception('Le nom et l\'adresse ne peuvent pas être vides');
    }
    _currentBar = BarInstance(
      id: _currentBar!.id,
      nom: nom.trim(),
      adresse: adresse.trim(),
    );
    int index =
        _barBox.values.toList().indexWhere((b) => b.id == _currentBar!.id);
    if (index != -1) {
      await _barBox.putAt(index, _currentBar!);
      notifyListeners();
    } else {
      throw Exception('Bar non trouvé pour mise à jour');
    }
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

  Map<Boisson, int> getBoissonsDansRefrigerateurs() {
    Map<Boisson, int> boissonsDisponibles = {};
    for (var refrigerateur in _refrigerateurBox.values) {
      if (refrigerateur.boissons != null) {
        for (var boisson in refrigerateur.boissons!) {
          var key = boisson;
          boissonsDisponibles[key] = (boissonsDisponibles[key] ?? 0) + 1;
        }
      }
    }
    return boissonsDisponibles;
  }

  Map<Boisson, int> getBoissonsDansRefrigerateur(int refrigerateurId) {
    Map<Boisson, int> boissonsDisponibles = {};
    var refrigerateur = _refrigerateurBox.values.firstWhere(
      (r) => r.id == refrigerateurId,
      orElse: () => throw Exception('Réfrigérateur non trouvé'),
    );
    if (refrigerateur.boissons != null) {
      for (var boisson in refrigerateur.boissons!) {
        var key = boisson;
        boissonsDisponibles[key] = (boissonsDisponibles[key] ?? 0) + 1;
      }
    }
    return boissonsDisponibles;
  }

  Future<String> generateCommandePdf(Commande commande) async {
    final pdf = pw.Document();
    final now = DateTime.now();

    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.blueGrey800,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.blueGrey700,
    );
    final infoStyle = pw.TextStyle(fontSize: 14, color: PdfColors.black);
    final tableHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    final tableCellStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);
    final footerStyle = pw.TextStyle(fontSize: 10, color: PdfColors.grey600);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.blueGrey100,
            border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.blueGrey800, width: 2)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Commande #${commande.id}',
                style: headerStyle,
              ),
              pw.Text(
                'Généré le ${Helpers.formatterDate(now)}',
                style: footerStyle,
              ),
            ],
          ),
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Généré par BAR App',
            style: footerStyle,
          ),
        ),
        build: (context) => [
          pw.SizedBox(height: 20),
          // Détails du bar
          pw.Text('Détails du bar', style: subHeaderStyle),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text('Nom: ${commande.barInstance.nom}', style: infoStyle),
          pw.Text('Adresse: ${commande.barInstance.adresse}', style: infoStyle),
          pw.SizedBox(height: 20),
          // Détails de la commande
          pw.Text('Détails de la commande', style: subHeaderStyle),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text('Numéro: ${commande.id}', style: infoStyle),
          pw.Text('Date: ${Helpers.formatterDate(commande.dateCommande)}',
              style: infoStyle),
          pw.Text(
              'Montant total: ${Helpers.formatterEnCFA(commande.montantTotal)}',
              style: infoStyle),
          pw.Text(
            'Fournisseur: ${commande.fournisseur?.nom ?? "Inconnu"}',
            style: infoStyle,
          ),
          if (commande.fournisseur != null) ...[
            pw.Text(
                'Adresse: ${commande.fournisseur!.adresse ?? "Non spécifié"}',
                style: infoStyle),
          ],
          pw.SizedBox(height: 20),
          // Lignes de commande
          pw.Text('Casiers commandés', style: subHeaderStyle),
          pw.SizedBox(height: 10),
          if (commande.lignesCommande.isEmpty)
            pw.Text('Aucun casier dans cette commande', style: infoStyle)
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: {
                0: pw.FixedColumnWidth(100),
                1: pw.FlexColumnWidth(),
                2: pw.FixedColumnWidth(80),
                3: pw.FixedColumnWidth(100),
              },
              children: [
                pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: PdfColors.blueGrey700),
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
                      child: pw.Text('Quantité', style: tableHeaderStyle),
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
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                ligne.casier.boissons.isNotEmpty
                                    ? ligne.casier.boissons[0].nom ?? 'Sans nom'
                                    : 'Aucune boisson',
                                style: tableCellStyle,
                              ),
                              if (ligne.casier.boissons.isNotEmpty &&
                                  ligne.casier.boissons[0].modele != null)
                                pw.Text(
                                  'Modèle: ${ligne.casier.boissons[0].modele!.name}',
                                  style: tableCellStyle.copyWith(fontSize: 10),
                                ),
                              if (ligne.casier.boissons.isNotEmpty &&
                                  ligne.casier.boissons[0].description !=
                                      null &&
                                  ligne.casier.boissons[0].description!
                                      .isNotEmpty)
                                pw.Text(
                                  'Desc: ${ligne.casier.boissons[0].description}',
                                  style: tableCellStyle.copyWith(fontSize: 10),
                                ),
                            ],
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
          pw.SizedBox(height: 20),
          // Résumé
          pw.Text('Résumé', style: subHeaderStyle),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text('Nombre total de casiers: ${commande.lignesCommande.length}',
              style: infoStyle),
        ],
      ),
    );

    final directory = await getDownloadsDirectory();
    if (directory == null) {
      throw Exception('Impossible d\'accéder au dossier de téléchargements');
    }
    final filePath =
        '${directory.path}/commande_${commande.id}_${now.millisecondsSinceEpoch}.pdf';
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }

    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  Future<String> generateVentePdf(Vente vente) async {
    final pdf = pw.Document();
    final now = DateTime.now();

    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.blueGrey800,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.blueGrey700,
    );
    final infoStyle = pw.TextStyle(fontSize: 14, color: PdfColors.black);
    final tableHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    final tableCellStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);
    final footerStyle = pw.TextStyle(fontSize: 10, color: PdfColors.grey600);

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Container(
          padding: const pw.EdgeInsets.all(10),
          decoration: pw.BoxDecoration(
            color: PdfColors.blueGrey100,
            border: pw.Border(
                bottom: pw.BorderSide(color: PdfColors.blueGrey800, width: 2)),
          ),
          child: pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'Vente #${vente.id}',
                style: headerStyle,
              ),
              pw.Text(
                'Généré le ${Helpers.formatterDate(now)}',
                style: footerStyle,
              ),
            ],
          ),
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.center,
          margin: const pw.EdgeInsets.only(top: 10),
          child: pw.Text(
            'Généré par BAR App',
            style: footerStyle,
          ),
        ),
        build: (context) => [
          pw.SizedBox(height: 20),
          // Détails du bar
          pw.Text('Détails du bar', style: subHeaderStyle),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text('Nom: ${_currentBar?.nom ?? "Bar Inconnu"}',
              style: infoStyle),
          pw.Text('Adresse: ${_currentBar?.adresse ?? "Non spécifiée"}',
              style: infoStyle),
          pw.SizedBox(height: 20),
          // Détails de la vente
          pw.Text('Détails de la vente', style: subHeaderStyle),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text('Numéro: ${vente.id}', style: infoStyle),
          pw.Text('Date: ${Helpers.formatterDate(vente.dateVente)}',
              style: infoStyle),
          pw.Text(
              'Montant total: ${Helpers.formatterEnCFA(vente.montantTotal)}',
              style: infoStyle),
          pw.SizedBox(height: 20),
          // Lignes de vente
          pw.Text('Articles vendus', style: subHeaderStyle),
          pw.SizedBox(height: 10),
          if (vente.lignesVente.isEmpty)
            pw.Text('Aucun article vendu', style: infoStyle)
          else
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey400),
              columnWidths: {
                0: pw.FlexColumnWidth(),
                1: pw.FixedColumnWidth(80),
                2: pw.FixedColumnWidth(100),
              },
              children: [
                pw.TableRow(
                  decoration:
                      const pw.BoxDecoration(color: PdfColors.blueGrey700),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Boisson', style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Quantité', style: tableHeaderStyle),
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
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text(
                                ligne.boisson.nom ?? 'Sans nom',
                                style: tableCellStyle,
                              ),
                              if (ligne.boisson.modele != null)
                                pw.Text(
                                  'Modèle: ${ligne.boisson.modele!.name}',
                                  style: tableCellStyle.copyWith(fontSize: 10),
                                ),
                              if (ligne.boisson.description != null &&
                                  ligne.boisson.description!.isNotEmpty)
                                pw.Text(
                                  'Desc: ${ligne.boisson.description}',
                                  style: tableCellStyle.copyWith(fontSize: 10),
                                ),
                            ],
                          ),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text('1', style: tableCellStyle),
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
          pw.SizedBox(height: 20),
          // Résumé
          pw.Text('Résumé', style: subHeaderStyle),
          pw.Divider(),
          pw.SizedBox(height: 10),
          pw.Text('Nombre total d\'articles: ${vente.lignesVente.length}',
              style: infoStyle),
        ],
      ),
    );

    final directory = await getDownloadsDirectory();
    if (directory == null) {
      throw Exception('Impossible d\'accéder au dossier de téléchargements');
    }
    final filePath =
        '${directory.path}/vente_${vente.id}_${now.millisecondsSinceEpoch}.pdf';
    final file = File(filePath);

    if (await file.exists()) {
      await file.delete();
    }

    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  Future<void> ajouterBoissonsAuRefrigerateur(
      int commandeId, int refrigerateurId, int nombre) async {
    Commande? commande = _commandeBox.values.firstWhere(
      (c) => c.id == commandeId,
      orElse: () => throw Exception('Commande non trouvée'),
    );

    var refrigerateur = _refrigerateurBox.values.firstWhere(
      (r) => r.id == refrigerateurId,
      orElse: () => throw Exception('Réfrigérateur non trouvé'),
    );

    Casier? casier = commande.lignesCommande
        .firstWhereOrNull(
          (ligne) =>
              ligne.casier.boissons.isNotEmpty &&
              ligne.casier.boissonTotal >= nombre,
        )
        ?.casier;

    if (casier == null || casier.boissons.length < nombre || nombre <= 0) {
      throw Exception(
          'Nombre de boissons invalide ou insuffisant dans la commande');
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

    int commandeIndex = _commandeBox.values.toList().indexOf(commande);
    await _commandeBox.putAt(commandeIndex, commande);

    int refrigerateurIndex =
        _refrigerateurBox.values.toList().indexOf(refrigerateur);
    await _refrigerateurBox.putAt(refrigerateurIndex, refrigerateur);

    notifyListeners();
  }

  Future<void> retirerBoissonsDuRefrigerateur(
      int commandeId, int refrigerateurId, Boisson boisson) async {
    var refrigerateur = _refrigerateurBox.values.firstWhere(
      (r) => r.id == refrigerateurId,
      orElse: () => throw Exception('Réfrigérateur non trouvé'),
    );

    if (refrigerateur.boissons == null ||
        !refrigerateur.boissons!.contains(boisson)) {
      throw Exception('Boisson non trouvée dans le réfrigérateur');
    }

    Commande? commande = _commandeBox.values.firstWhere(
      (c) => c.id == commandeId,
      orElse: () => throw Exception('Commande non trouvée'),
    );

    Casier? casier = commande.lignesCommande
        .firstWhereOrNull(
          (ligne) =>
              ligne.casier.boissons.isNotEmpty &&
              ligne.casier.boissons.first.nom == boisson.nom &&
              ligne.casier.boissons.first.modele == boisson.modele,
        )
        ?.casier;

    if (casier == null) {
      casier = Casier(
        id: await generateUniqueId("Casier"),
        boissonTotal: 0,
        boissons: [],
      );
      commande.lignesCommande.add(LigneCommande(
        id: await generateUniqueId("LigneCommande"),
        montant: boisson.prix.isNotEmpty ? boisson.prix[0] : 0.0,
        casier: casier,
      ));
    }

    casier.boissons.add(Boisson(
      id: await generateUniqueId("Boisson"),
      nom: boisson.nom,
      prix: List.from(boisson.prix),
      estFroid: boisson.estFroid,
      modele: boisson.modele,
      description: boisson.description,
    ));
    casier.boissonTotal = casier.boissons.length;

    refrigerateur.boissons!.remove(boisson);

    int commandeIndex = _commandeBox.values.toList().indexOf(commande);
    await _commandeBox.putAt(commandeIndex, commande);

    int refrigerateurIndex =
        _refrigerateurBox.values.toList().indexOf(refrigerateur);
    await _refrigerateurBox.putAt(refrigerateurIndex, refrigerateur);

    notifyListeners();
  }

  Future<void> retirerBoissonDuRefrigerateurSansCommande(
      int refrigerateurId, Boisson boisson) async {
    var refrigerateur = _refrigerateurBox.values.firstWhere(
      (r) => r.id == refrigerateurId,
      orElse: () => throw Exception('Réfrigérateur non trouvé'),
    );

    if (refrigerateur.boissons == null ||
        !refrigerateur.boissons!.contains(boisson)) {
      throw Exception('Boisson non trouvée dans le réfrigérateur');
    }

    refrigerateur.boissons!.remove(boisson);

    int refrigerateurIndex =
        _refrigerateurBox.values.toList().indexOf(refrigerateur);
    await _refrigerateurBox.putAt(refrigerateurIndex, refrigerateur);

    notifyListeners();
  }

  Future<void> addVente(
      Vente vente, Map<Boisson, int> boissonToRefrigerateur) async {
    for (var ligne in vente.lignesVente) {
      int refrigerateurId = boissonToRefrigerateur[ligne.boisson]!;
      var boissonsDisponibles = getBoissonsDansRefrigerateur(refrigerateurId);
      int quantiteDisponible = boissonsDisponibles.entries
          .firstWhere(
            (entry) =>
                entry.key.nom == ligne.boisson.nom &&
                entry.key.modele == ligne.boisson.modele,
            orElse: () => throw Exception(
                'Boisson ${ligne.boisson.nom} non disponible dans le réfrigérateur'),
          )
          .value;
      if (1 > quantiteDisponible) {
        throw Exception(
            'Boisson ${ligne.boisson.nom} épuisée dans le réfrigérateur');
      }
    }

    for (var ligne in vente.lignesVente) {
      int refrigerateurId = boissonToRefrigerateur[ligne.boisson]!;
      var refrigerateur = _refrigerateurBox.values.firstWhere(
        (r) => r.id == refrigerateurId,
      );
      var boissonToRemove = refrigerateur.boissons!.firstWhere(
        (b) => b.nom == ligne.boisson.nom && b.modele == ligne.boisson.modele,
      );
      await retirerBoissonDuRefrigerateurSansCommande(
          refrigerateurId, boissonToRemove);
    }

    await _venteBox.add(vente);
    notifyListeners();
  }

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

  List<Commande> get commandes => _commandeBox.values.toList();
  Future<void> addCommande(Commande commande) async {
    await _commandeBox.add(commande);
    notifyListeners();
  }

  Future<void> deleteCommande(Commande commande) async {
    await _commandeBox.deleteAt(_commandeBox.values.toList().indexOf(commande));
    notifyListeners();
  }

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

  List<Vente> get ventes => _venteBox.values.toList();

  Future<void> deleteVente(Vente vente) async {
    await _venteBox.deleteAt(_venteBox.values.toList().indexOf(vente));
    notifyListeners();
  }
}
