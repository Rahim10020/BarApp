import 'package:flutter/material.dart';
import 'package:projet7/core/di/repository_manager.dart';
import 'package:projet7/domain/repositories/i_bar_repository.dart';
import 'package:projet7/domain/repositories/i_boisson_repository.dart';
import 'package:projet7/domain/repositories/i_casier_repository.dart';
import 'package:projet7/domain/repositories/i_commande_repository.dart';
import 'package:projet7/domain/repositories/i_fournisseur_repository.dart';
import 'package:projet7/domain/repositories/i_refrigerateur_repository.dart';
import 'package:projet7/domain/repositories/i_vente_repository.dart';
import 'package:projet7/domain/usecases/backup_restore_usecase.dart';
import 'package:projet7/domain/usecases/generate_pdf_usecase.dart';
import 'package:projet7/domain/usecases/get_inventory_alerts_usecase.dart';
import 'package:projet7/domain/usecases/get_statistics_usecase.dart';
import 'package:projet7/domain/usecases/transfer_drinks_to_fridge_usecase.dart';
import 'package:projet7/models/bar_instance.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/models/vente.dart';

/// Provider principal de l'application utilisant l'architecture clean.
///
/// Cette classe sert de pont entre l'interface utilisateur et la logique métier.
/// Elle délègue toutes les opérations aux repositories et use cases appropriés,
/// et notifie les widgets lors de changements de données.
///
/// Implémente [ChangeNotifier] pour la gestion d'état avec Provider.
///
/// Fonctionnalités principales :
/// - Gestion CRUD pour toutes les entités (boissons, casiers, ventes, etc.)
/// - Opérations complexes via use cases (transferts, statistiques, PDF)
/// - Alertes d'inventaire (stock bas, expirations)
/// - Sauvegarde et restauration des données
///
/// Exemple d'utilisation :
/// ```dart
/// final provider = Provider.of<BarAppProvider>(context);
/// await provider.addBoisson(nouvelleBoisson);
/// ```
class BarAppProvider with ChangeNotifier {
  final RepositoryManager _manager = RepositoryManager();

  // === REPOSITORIES (via getters pour faciliter l'accès) ===
  late IBarRepository _barRepo;
  late IBoissonRepository _boissonRepo;
  late ICasierRepository _casierRepo;
  late ICommandeRepository _commandeRepo;
  late IFournisseurRepository _fournisseurRepo;
  late IRefrigerateurRepository _refrigerateurRepo;
  late IVenteRepository _venteRepo;

  // === USE CASES ===
  late TransferDrinksToFridgeUseCase _transferDrinksUseCase;
  late GetInventoryAlertsUseCase _inventoryAlertsUseCase;
  late GetStatisticsUseCase _statisticsUseCase;
  late GeneratePdfUseCase _generatePdfUseCase;
  late BackupRestoreUseCase _backupRestoreUseCase;

  bool _isInitialized = false;

  BarAppProvider() {
    _initializeSync();
  }

  void _initializeSync() async {
    if (_isInitialized) return;

    await _manager.initialize();

    // Récupérer les repositories
    _barRepo = _manager.barRepository;
    _boissonRepo = _manager.boissonRepository;
    _casierRepo = _manager.casierRepository;
    _commandeRepo = _manager.commandeRepository;
    _fournisseurRepo = _manager.fournisseurRepository;
    _refrigerateurRepo = _manager.refrigerateurRepository;
    _venteRepo = _manager.venteRepository;

    // Récupérer les use cases
    _transferDrinksUseCase = _manager.transferDrinksUseCase;
    _inventoryAlertsUseCase = _manager.inventoryAlertsUseCase;
    _statisticsUseCase = _manager.statisticsUseCase;
    _generatePdfUseCase = _manager.generatePdfUseCase;
    _backupRestoreUseCase = _manager.backupRestoreUseCase;

    _isInitialized = true;
    notifyListeners();
  }

  // === BAR INSTANCE ===
  bool get isInitialized => _isInitialized;

  BarInstance? get currentBar {
    if (!_isInitialized) return null;
    return _barRepo.getCurrentBar();
  }

  Future<void> createBar(String nom, String adresse) async {
    await _barRepo.createBar(nom, adresse);
    notifyListeners();
  }

  // === BOISSONS ===
  List<Boisson> get boissons => _boissonRepo.getAll();

  Future<void> addBoisson(Boisson boisson) async {
    await _boissonRepo.add(boisson);
    notifyListeners();
  }

  Future<void> updateBoisson(Boisson boisson) async {
    await _boissonRepo.update(boisson);
    notifyListeners();
  }

  Future<void> deleteBoisson(Boisson boisson) async {
    await _boissonRepo.delete(boisson);
    notifyListeners();
  }

  // === CASIERS ===
  List<Casier> get casiers => _casierRepo.getAll();

  Future<void> addCasier(Casier casier) async {
    await _casierRepo.add(casier);
    notifyListeners();
  }

  Future<void> updateCasier(Casier casier) async {
    await _casierRepo.update(casier);
    notifyListeners();
  }

  Future<void> deleteCasier(Casier casier) async {
    await _casierRepo.delete(casier);
    notifyListeners();
  }

  // === COMMANDES ===
  List<Commande> get commandes => _commandeRepo.getAll();

  Future<void> addCommande(Commande commande) async {
    await _commandeRepo.add(commande);
    notifyListeners();
  }

  Future<void> deleteCommande(Commande commande) async {
    await _commandeRepo.delete(commande);
    notifyListeners();
  }

  // === FOURNISSEURS ===
  List<Fournisseur> get fournisseurs => _fournisseurRepo.getAll();

  Future<void> addFournisseur(Fournisseur fournisseur) async {
    await _fournisseurRepo.add(fournisseur);
    notifyListeners();
  }

  // === RÉFRIGÉRATEURS ===
  List<Refrigerateur> get refrigerateurs => _refrigerateurRepo.getAll();

  Future<void> addRefrigerateur(Refrigerateur refrigerateur) async {
    await _refrigerateurRepo.add(refrigerateur);
    notifyListeners();
  }

  Future<void> updateRefrigerateur(Refrigerateur refrigerateur) async {
    await _refrigerateurRepo.update(refrigerateur);
    notifyListeners();
  }

  Future<void> deleteRefrigerateur(Refrigerateur refrigerateur) async {
    await _refrigerateurRepo.delete(refrigerateur);
    notifyListeners();
  }

  // === VENTES ===
  List<Vente> get ventes => _venteRepo.getAll();

  Future<void> addVente(Vente vente) async {
    await _venteRepo.add(vente);
    notifyListeners();
  }

  Future<void> deleteVente(Vente vente) async {
    await _venteRepo.delete(vente);
    notifyListeners();
  }

  // === OPÉRATIONS COMPLEXES (USE CASES) ===

  /// Transfert de boissons d'un casier vers un réfrigérateur
  Future<void> ajouterBoissonsAuRefrigerateur(
    int casierId,
    int refrigerateurId,
    int nombre,
  ) async {
    await _transferDrinksUseCase.execute(
      casierId: casierId,
      refrigerateurId: refrigerateurId,
      nombre: nombre,
    );
    notifyListeners();
  }

  /// Récupère les alertes d'inventaire (stock bas + expiration)
  List<String> getLowStockAlerts() {
    final alerts = _inventoryAlertsUseCase.execute();
    return alerts
        .where((a) => a.type == 'low_stock')
        .map((a) => a.message)
        .toList();
  }

  bool hasLowStockAlerts() {
    return _inventoryAlertsUseCase.hasLowStockAlerts();
  }

  List<String> getExpiryAlerts() {
    final alerts = _inventoryAlertsUseCase.execute();
    return alerts
        .where((a) => a.type == 'expiry')
        .map((a) => a.message)
        .toList();
  }

  bool hasExpiryAlerts() {
    return _inventoryAlertsUseCase.hasExpiryAlerts();
  }

  /// Génération de PDFs
  Future<String> generateCommandePdf(Commande commande) async {
    return await _generatePdfUseCase.generateCommandePdf(commande);
  }

  Future<String> generateVentePdf(Vente vente) async {
    return await _generatePdfUseCase.generateVentePdf(vente);
  }

  Future<String> generateStatisticsPdf(
    DateTime startDate,
    DateTime endDate,
    String period,
  ) async {
    return await _generatePdfUseCase.generateStatisticsPdf(
      startDate: startDate,
      endDate: endDate,
      period: period,
    );
  }

  /// Statistiques
  Map<String, double> getRevenueByDrink(DateTime startDate, DateTime endDate) {
    final stats = _statisticsUseCase.execute(
      startDate: startDate,
      endDate: endDate,
    );
    return stats.revenueByDrink;
  }

  List<MapEntry<String, int>> getTopSellingDrinks(
    DateTime startDate,
    DateTime endDate, {
    int limit = 10,
  }) {
    final stats = _statisticsUseCase.execute(
      startDate: startDate,
      endDate: endDate,
      topDrinksLimit: limit,
    );
    return stats.topSellingDrinks;
  }

  Map<DateTime, double> getRevenueTrends(
    DateTime startDate,
    DateTime endDate,
    String period,
  ) {
    final stats = _statisticsUseCase.execute(
      startDate: startDate,
      endDate: endDate,
      period: period,
    );
    return stats.revenueTrends;
  }

  Map<String, int> getInventoryLevels() {
    final stats = _statisticsUseCase.execute(
      startDate: DateTime.now(),
      endDate: DateTime.now(),
    );
    return stats.inventoryLevels;
  }

  /// Backup et restauration
  Future<void> backupData() async {
    await _backupRestoreUseCase.backupData();
  }

  Future<void> restoreData() async {
    await _backupRestoreUseCase.restoreData();
    notifyListeners();
  }

  /// Génération d'IDs uniques
  Future<int> generateUniqueId(String entityType) async {
    return await _manager.idGenerator.generateUniqueId(entityType);
  }
}
