import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projet7/models/bar_instance.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/id_counter.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/models/vente.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:projet7/utils/helpers.dart';

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

  // int generateUniqueId() => DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF;

  Future<int> generateUniqueId(String entityType) async {
    IdCounter? counter = _idCounterBox.values.firstWhere(
      (c) => c.entityType == entityType,
      orElse: () => IdCounter(entityType: entityType, lastId: 0),
    );

    counter.lastId += 1;

    if (_idCounterBox.values.any(
      (c) => c.entityType == entityType,
    )) {
      int index = _idCounterBox.values.toList().indexWhere(
            (c) => c.entityType == entityType,
          );
      await _idCounterBox.putAt(index, counter);
    } else {
      await _idCounterBox.add(counter);
    }

    return counter.lastId;
  }

  Future<String> generateCommandePdf(Commande commande) async {
    final pdf = pw.Document();

    // Définir les styles
    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown800,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown600,
    );
    const infoStyle = pw.TextStyle(fontSize: 14, color: PdfColors.black);
    final tableHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    const tableCellStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // En-tête avec le nom du bar
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.brown100,
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.brown600, width: 2)),
              ),
              child: pw.Text(
                'Bar: ${commande.barInstance.nom}',
                style: headerStyle,
              ),
            ),
            pw.SizedBox(height: 20),

            // Titre de la commande
            pw.Text('Commande #${commande.id}', style: subHeaderStyle),
            pw.SizedBox(height: 10),

            // Informations générales
            pw.Text('Date: ${Helpers.formatterDate(commande.dateCommande)}',
                style: infoStyle),
            pw.Text(
                'Montant Total: ${Helpers.formatterEnCFA(commande.getPrixTotal())}',
                style: infoStyle),
            pw.Text(
              'Fournisseur: ${commande.fournisseur != null ? commande.fournisseur!.nom : "Inconnu"}',
              style: infoStyle,
            ),
            pw.SizedBox(height: 20),

            // Section des lignes de commande
            pw.Text('Lignes de Commande:', style: subHeaderStyle),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.brown400),
              children: [
                // En-tête du tableau
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.brown600),
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
                // Lignes de commande
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
                          child: pw.Text(
                              Helpers.formatterEnCFA(ligne.getMontant()),
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

    // Sauvegarder dans le répertoire "Téléchargements"
    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/commande_${commande.id}.pdf';
    final file = File(filePath);

    // Supprimer l'ancien PDF s'il existe
    if (await file.exists()) {
      await file.delete();
    }

    // Sauvegarder le nouveau PDF
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  Future<String> generateVentePdf(Vente vente) async {
    final pdf = pw.Document();

    // Définir les styles
    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown800,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown600,
    );
    const infoStyle = pw.TextStyle(fontSize: 14, color: PdfColors.black);
    final tableHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    const tableCellStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // En-tête avec le nom du bar
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.brown100,
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.brown600, width: 2)),
              ),
              child: pw.Text(
                'Bar: ${_currentBar?.nom ?? "Bar Inconnu"}',
                style: headerStyle,
              ),
            ),
            pw.SizedBox(height: 20),

            // Titre de la vente
            pw.Text('Vente #${vente.id}', style: subHeaderStyle),
            pw.SizedBox(height: 10),

            // Informations générales
            pw.Text('Date: ${Helpers.formatterDate(vente.dateVente)}',
                style: infoStyle),
            pw.Text(
                'Montant Total: ${Helpers.formatterEnCFA(vente.getPrixTotal())}',
                style: infoStyle),
            pw.SizedBox(height: 20),

            // Section des lignes de vente
            pw.Text('Lignes de Vente:', style: subHeaderStyle),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.brown400),
              children: [
                // En-tête du tableau
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.brown600),
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
                // Lignes de vente
                ...vente.lignesVente.map((ligne) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(ligne.boisson.nom ?? 'Sans nom',
                              style: tableCellStyle),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                              Helpers.formatterEnCFA(ligne.getMontant()),
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

    // Sauvegarder dans le répertoire "Téléchargements"
    final directory = await getDownloadsDirectory();
    final filePath = '${directory!.path}/vente_${vente.id}.pdf';
    final file = File(filePath);

    // Supprimer l'ancien PDF s'il existe
    if (await file.exists()) {
      await file.delete();
    }

    // Sauvegarder le nouveau PDF
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }

  Future<void> ajouterBoissonsAuRefrigerateur(
      int casierId, int refrigerateurId, int nombre) async {
    // Trouver le casier dans les lignes de commande
    Casier? casier;
    for (var commande in _commandeBox.values) {
      try {
        casier = commande.lignesCommande
            .map((ligne) => ligne.casier)
            .firstWhere((c) => c.id == casierId);
        break; // Found it, exit the loop
      } catch (e) {
        // Casier not found in this commande, continue to next
        continue;
      }
    }
    if (casier == null) throw Exception('Casier non trouvé dans les commandes');

    var refrigerateur = _refrigerateurBox.values.firstWhere(
        (r) => r.id == refrigerateurId,
        orElse: () => throw Exception('Réfrigérateur non trouvé'));

    if (casier.boissons.length < nombre || nombre <= 0) {
      throw Exception(
          'Nombre de boissons invalide ou insuffisant dans le casier');
    }

    refrigerateur.boissons ??= [];

    // Transférer les boissons et mettre estFroid à true

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

    // Ne pas modifier le casier d’origine dans _casierBox, juste le réfrigérateur
    int refrigerateurIndex =
        _refrigerateurBox.values.toList().indexOf(refrigerateur);
    await _refrigerateurBox.putAt(refrigerateurIndex, refrigerateur);

    notifyListeners();
  }

  // BarInstance
  BarInstance? get currentBar => _currentBar;
  Future<void> createBar(String nom, String adresse) async {
    _currentBar = BarInstance(
        id: await generateUniqueId("BarInstance"), nom: nom, adresse: adresse);
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

  Future<void> deleteVente(Vente vente) async {
    await _venteBox.deleteAt(_venteBox.values.toList().indexOf(vente));
    notifyListeners();
  }

  // Inventory alerts
  List<String> getLowStockAlerts() {
    List<String> alerts = [];
    const int lowStockThreshold = 5; // Configurable threshold

    // Check refrigerators
    for (var refrigerateur in refrigerateurs) {
      if (refrigerateur.boissons != null) {
        var groupedBoissons = <String, int>{};
        for (var boisson in refrigerateur.boissons!) {
          var key = boisson.nom ?? 'Sans nom';
          groupedBoissons[key] = (groupedBoissons[key] ?? 0) + 1;
        }

        groupedBoissons.forEach((nom, count) {
          if (count <= lowStockThreshold) {
            alerts.add(
                'Stock faible (Réfrigérateur): $nom ($count unités restantes)');
          }
        });
      }
    }

    // Check cases
    for (var casier in casiers) {
      if (casier.boissons.isNotEmpty) {
        var groupedBoissons = <String, int>{};
        for (var boisson in casier.boissons) {
          var key = boisson.nom ?? 'Sans nom';
          groupedBoissons[key] = (groupedBoissons[key] ?? 0) + 1;
        }

        groupedBoissons.forEach((nom, count) {
          if (count <= lowStockThreshold) {
            alerts.add(
                'Stock faible (Casier #${casier.id}): $nom ($count unités restantes)');
          }
        });
      }
    }

    return alerts;
  }

  bool hasLowStockAlerts() {
    return getLowStockAlerts().isNotEmpty;
  }

  List<String> getExpiryAlerts() {
    List<String> alerts = [];
    const int daysBeforeExpiry = 7; // Alert 7 days before expiry

    for (var refrigerateur in refrigerateurs) {
      if (refrigerateur.boissons != null) {
        for (var boisson in refrigerateur.boissons!) {
          if (boisson.dateExpiration != null) {
            final daysUntilExpiry =
                boisson.dateExpiration!.difference(DateTime.now()).inDays;
            if (daysUntilExpiry <= daysBeforeExpiry && daysUntilExpiry >= 0) {
              alerts.add(
                  'Expiration proche: ${boisson.nom ?? 'Sans nom'} expire dans $daysUntilExpiry jours');
            } else if (daysUntilExpiry < 0) {
              alerts.add('Expiré: ${boisson.nom ?? 'Sans nom'} a expiré');
            }
          }
        }
      }
    }

    return alerts;
  }

  bool hasExpiryAlerts() {
    return getExpiryAlerts().isNotEmpty;
  }

  Future<void> backupData() async {
    // Backup all data to JSON files
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backup');
    if (!await backupDir.exists()) {
      await backupDir.create();
    }

    // Backup each box
    await _backupBox(_barBox, '${backupDir.path}/bars.json');
    await _backupBox(_boissonBox, '${backupDir.path}/boissons.json');
    await _backupBox(_casierBox, '${backupDir.path}/casiers.json');
    await _backupBox(_commandeBox, '${backupDir.path}/commandes.json');
    await _backupBox(_fournisseurBox, '${backupDir.path}/fournisseurs.json');
    await _backupBox(
        _refrigerateurBox, '${backupDir.path}/refrigerateurs.json');
    await _backupBox(_venteBox, '${backupDir.path}/ventes.json');
    await _backupBox(_idCounterBox, '${backupDir.path}/id_counters.json');
  }

  Future<void> _backupBox(Box box, String path) async {
    final data = box.toMap();
    final file = File(path);
    await file.writeAsString(jsonEncode(data));
  }

  Future<void> restoreData() async {
    final directory = await getApplicationDocumentsDirectory();
    final backupDir = Directory('${directory.path}/backup');

    if (!await backupDir.exists()) {
      throw Exception('Aucune sauvegarde trouvée');
    }

    // Restore each box
    await _restoreBox(_barBox, '${backupDir.path}/bars.json');
    await _restoreBox(_boissonBox, '${backupDir.path}/boissons.json');
    await _restoreBox(_casierBox, '${backupDir.path}/casiers.json');
    await _restoreBox(_commandeBox, '${backupDir.path}/commandes.json');
    await _restoreBox(_fournisseurBox, '${backupDir.path}/fournisseurs.json');
    await _restoreBox(
        _refrigerateurBox, '${backupDir.path}/refrigerateurs.json');
    await _restoreBox(_venteBox, '${backupDir.path}/ventes.json');
    await _restoreBox(_idCounterBox, '${backupDir.path}/id_counters.json');

    // Reload current bar
    if (_barBox.isEmpty) {
      _currentBar = null;
    } else {
      _currentBar = _barBox.values.first;
    }
    notifyListeners();
  }

  Future<void> _restoreBox(Box box, String path) async {
    final file = File(path);
    if (await file.exists()) {
      final data = jsonDecode(await file.readAsString());
      await box.clear();
      for (var entry in data.entries) {
        await box.put(entry.key, entry.value);
      }
    }
  }

  // Statistics methods
  Map<String, double> getRevenueByDrink(DateTime startDate, DateTime endDate) {
    final filteredSales = ventes
        .where((v) =>
            v.dateVente.isAfter(startDate.subtract(const Duration(days: 1))) &&
            v.dateVente.isBefore(endDate.add(const Duration(days: 1))))
        .toList();

    final revenueByDrink = <String, double>{};
    for (final vente in filteredSales) {
      for (final ligne in vente.lignesVente) {
        final drinkName = ligne.boisson.nom ?? 'Sans nom';
        revenueByDrink[drinkName] =
            (revenueByDrink[drinkName] ?? 0) + ligne.getMontant();
      }
    }
    return revenueByDrink;
  }

  List<MapEntry<String, int>> getTopSellingDrinks(
      DateTime startDate, DateTime endDate,
      {int limit = 10}) {
    final filteredSales = ventes
        .where((v) =>
            v.dateVente.isAfter(startDate.subtract(const Duration(days: 1))) &&
            v.dateVente.isBefore(endDate.add(const Duration(days: 1))))
        .toList();

    final salesByDrink = <String, int>{};
    for (final vente in filteredSales) {
      for (final ligne in vente.lignesVente) {
        final drinkName = ligne.boisson.nom ?? 'Sans nom';
        salesByDrink[drinkName] = (salesByDrink[drinkName] ?? 0) + 1;
      }
    }

    final sorted = salesByDrink.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(limit).toList();
  }

  Map<DateTime, double> getRevenueTrends(
      DateTime startDate, DateTime endDate, String period) {
    final filteredSales = ventes
        .where((v) =>
            v.dateVente.isAfter(startDate.subtract(const Duration(days: 1))) &&
            v.dateVente.isBefore(endDate.add(const Duration(days: 1))))
        .toList();

    final trends = <DateTime, double>{};
    for (final vente in filteredSales) {
      DateTime key;
      switch (period) {
        case 'daily':
          key = DateTime(
              vente.dateVente.year, vente.dateVente.month, vente.dateVente.day);
          break;
        case 'weekly':
          final weekStart = vente.dateVente
              .subtract(Duration(days: vente.dateVente.weekday - 1));
          key = DateTime(weekStart.year, weekStart.month, weekStart.day);
          break;
        case 'monthly':
          key = DateTime(vente.dateVente.year, vente.dateVente.month, 1);
          break;
        default:
          key = DateTime(
              vente.dateVente.year, vente.dateVente.month, vente.dateVente.day);
      }
      trends[key] = (trends[key] ?? 0) + vente.montantTotal;
    }
    return trends;
  }

  Map<String, int> getInventoryLevels() {
    final inventory = <String, int>{};

    // Count from refrigerators
    for (final refrigerateur in refrigerateurs) {
      if (refrigerateur.boissons != null) {
        for (final boisson in refrigerateur.boissons!) {
          final key = boisson.nom ?? 'Sans nom';
          inventory[key] = (inventory[key] ?? 0) + 1;
        }
      }
    }

    // Count from cases
    for (final casier in casiers) {
      for (final boisson in casier.boissons) {
        final key = boisson.nom ?? 'Sans nom';
        inventory[key] = (inventory[key] ?? 0) + 1;
      }
    }

    return inventory;
  }

  Future<String> generateStatisticsPdf(
      DateTime startDate, DateTime endDate, String period) async {
    final pdf = pw.Document();

    // Get data
    final revenueByDrink = getRevenueByDrink(startDate, endDate);
    final topSellingDrinks = getTopSellingDrinks(startDate, endDate);
    final inventoryLevels = getInventoryLevels();

    final filteredSales = ventes
        .where((v) =>
            v.dateVente.isAfter(startDate.subtract(const Duration(days: 1))) &&
            v.dateVente.isBefore(endDate.add(const Duration(days: 1))))
        .toList();

    final totalRevenue =
        filteredSales.fold(0.0, (sum, v) => sum + v.montantTotal);
    final totalOrders = filteredSales.length;
    final averageOrderValue =
        totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

    final filteredOrders = commandes
        .where((c) =>
            c.dateCommande
                .isAfter(startDate.subtract(const Duration(days: 1))) &&
            c.dateCommande.isBefore(endDate.add(const Duration(days: 1))))
        .toList();

    final totalOrderCost =
        filteredOrders.fold(0.0, (sum, c) => sum + c.montantTotal);

    // Définir les styles
    final headerStyle = pw.TextStyle(
      fontSize: 24,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown800,
    );
    final subHeaderStyle = pw.TextStyle(
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.brown600,
    );
    const infoStyle = pw.TextStyle(fontSize: 14, color: PdfColors.black);
    final tableHeaderStyle = pw.TextStyle(
      fontSize: 12,
      fontWeight: pw.FontWeight.bold,
      color: PdfColors.white,
    );
    const tableCellStyle = pw.TextStyle(fontSize: 12, color: PdfColors.black);

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            // En-tête
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: const pw.BoxDecoration(
                color: PdfColors.brown100,
                border: pw.Border(
                    bottom: pw.BorderSide(color: PdfColors.brown600, width: 2)),
              ),
              child: pw.Text(
                'Rapport Statistique - ${_currentBar?.nom ?? "Bar"}',
                style: headerStyle,
              ),
            ),
            pw.SizedBox(height: 20),

            // Période
            pw.Text(
                'Période: ${Helpers.formatterDate(startDate)} - ${Helpers.formatterDate(endDate)}',
                style: infoStyle),
            pw.SizedBox(height: 20),

            // Statistiques générales
            pw.Text('Statistiques Générales:', style: subHeaderStyle),
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.brown400),
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.brown600),
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Métrique', style: tableHeaderStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Valeur', style: tableHeaderStyle),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Revenus totaux', style: tableCellStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(Helpers.formatterEnCFA(totalRevenue),
                          style: tableCellStyle),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Nombre de ventes', style: tableCellStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('$totalOrders', style: tableCellStyle),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Panier moyen', style: tableCellStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(Helpers.formatterEnCFA(averageOrderValue),
                          style: tableCellStyle),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Coûts totaux', style: tableCellStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(Helpers.formatterEnCFA(totalOrderCost),
                          style: tableCellStyle),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text('Bénéfice', style: tableCellStyle),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                          Helpers.formatterEnCFA(totalRevenue - totalOrderCost),
                          style: tableCellStyle),
                    ),
                  ],
                ),
              ],
            ),
            pw.SizedBox(height: 20),

            // Boissons les plus vendues
            if (topSellingDrinks.isNotEmpty) ...[
              pw.Text('Boissons les plus vendues:', style: subHeaderStyle),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.brown400),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.brown600),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Boisson', style: tableHeaderStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Ventes', style: tableHeaderStyle),
                      ),
                    ],
                  ),
                  ...topSellingDrinks.map((entry) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(entry.key, style: tableCellStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('${entry.value}',
                                style: tableCellStyle),
                          ),
                        ],
                      )),
                ],
              ),
              pw.SizedBox(height: 20),
            ],

            // Revenus par boisson
            if (revenueByDrink.isNotEmpty) ...[
              pw.Text('Revenus par boisson:', style: subHeaderStyle),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.brown400),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.brown600),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Boisson', style: tableHeaderStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Revenus', style: tableHeaderStyle),
                      ),
                    ],
                  ),
                  ...revenueByDrink.entries.map((entry) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(entry.key, style: tableCellStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(Helpers.formatterEnCFA(entry.value),
                                style: tableCellStyle),
                          ),
                        ],
                      )),
                ],
              ),
              pw.SizedBox(height: 20),
            ],

            // Niveaux d'inventaire
            if (inventoryLevels.isNotEmpty) ...[
              pw.Text('Niveaux d\'inventaire:', style: subHeaderStyle),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.brown400),
                children: [
                  pw.TableRow(
                    decoration:
                        const pw.BoxDecoration(color: PdfColors.brown600),
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Boisson', style: tableHeaderStyle),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Unités', style: tableHeaderStyle),
                      ),
                    ],
                  ),
                  ...inventoryLevels.entries.map((entry) => pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(entry.key, style: tableCellStyle),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text('${entry.value}',
                                style: tableCellStyle),
                          ),
                        ],
                      )),
                ],
              ),
            ],
          ],
        ),
      ),
    );

    // Sauvegarder dans le répertoire "Téléchargements"
    final directory = await getDownloadsDirectory();
    if (directory == null) {
      throw Exception('Impossible d\'accéder au répertoire de téléchargements');
    }
    final filePath =
        '${directory.path}/rapport_statistiques_${Helpers.formatterDate(DateTime.now()).replaceAll('/', '-')}.pdf';
    final file = File(filePath);

    // Supprimer l'ancien PDF s'il existe
    if (await file.exists()) {
      await file.delete();
    }

    // Sauvegarder le nouveau PDF
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }
}
