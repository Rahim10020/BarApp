import 'package:hive/hive.dart';
import 'package:projet7/core/utils/id_generator.dart';
import 'package:projet7/data/datasources/hive_local_datasource.dart';
import 'package:projet7/data/repositories/bar_repository_impl.dart';
import 'package:projet7/data/repositories/boisson_repository_impl.dart';
import 'package:projet7/data/repositories/casier_repository_impl.dart';
import 'package:projet7/data/repositories/commande_repository_impl.dart';
import 'package:projet7/data/repositories/fournisseur_repository_impl.dart';
import 'package:projet7/data/repositories/refrigerateur_repository_impl.dart';
import 'package:projet7/data/repositories/vente_repository_impl.dart';
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
import 'package:projet7/models/id_counter.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/models/vente.dart';

/// Gestionnaire centralisé pour l'injection de dépendances de l'application.
///
/// Cette classe singleton gère l'initialisation et l'accès à tous les
/// repositories, use cases et services de l'application.
///
/// Implémente un pattern simple de Dependency Injection sans librairie externe,
/// assurant que toutes les dépendances sont créées et injectées correctement.
///
/// **Important** : Appeler [initialize] avant d'accéder aux getters.
///
/// Exemple d'utilisation :
/// ```dart
/// await RepositoryManager().initialize();
/// final venteRepo = RepositoryManager().venteRepository;
/// ```
class RepositoryManager {
  // === SINGLETON ===
  static final RepositoryManager _instance = RepositoryManager._internal();
  factory RepositoryManager() => _instance;
  RepositoryManager._internal();

  // === BOXES HIVE ===
  late Box<BarInstance> _barBox;
  late Box<Boisson> _boissonBox;
  late Box<Casier> _casierBox;
  late Box<Commande> _commandeBox;
  late Box<Fournisseur> _fournisseurBox;
  late Box<Refrigerateur> _refrigerateurBox;
  late Box<Vente> _venteBox;
  late Box<IdCounter> _idCounterBox;

  // === CORE ===
  late IdGenerator _idGenerator;

  // === REPOSITORIES ===
  late IBarRepository _barRepository;
  late IBoissonRepository _boissonRepository;
  late ICasierRepository _casierRepository;
  late ICommandeRepository _commandeRepository;
  late IFournisseurRepository _fournisseurRepository;
  late IRefrigerateurRepository _refrigerateurRepository;
  late IVenteRepository _venteRepository;

  // === USE CASES ===
  late TransferDrinksToFridgeUseCase _transferDrinksUseCase;
  late GetInventoryAlertsUseCase _inventoryAlertsUseCase;
  late GetStatisticsUseCase _statisticsUseCase;
  late GeneratePdfUseCase _generatePdfUseCase;
  late BackupRestoreUseCase _backupRestoreUseCase;

  bool _initialized = false;

  /// Initialise tous les repositories et use cases
  Future<void> initialize() async {
    if (_initialized) return;

    // 1. Ouvrir les boxes Hive
    _barBox = await Hive.openBox<BarInstance>('bars');
    _boissonBox = await Hive.openBox<Boisson>('boissons');
    _casierBox = await Hive.openBox<Casier>('casiers');
    _commandeBox = await Hive.openBox<Commande>('commandes');
    _fournisseurBox = await Hive.openBox<Fournisseur>('fournisseurs');
    _refrigerateurBox = await Hive.openBox<Refrigerateur>('refrigerateurs');
    _venteBox = await Hive.openBox<Vente>('ventes');
    _idCounterBox = await Hive.openBox<IdCounter>('id_counters');

    // 2. Créer l'IdGenerator
    _idGenerator = IdGenerator(_idCounterBox);

    // 3. Créer les datasources
    final boissonDatasource = HiveLocalDatasource<Boisson>(
      box: _boissonBox,
      getId: (b) => b.id,
    );
    final casierDatasource = HiveLocalDatasource<Casier>(
      box: _casierBox,
      getId: (c) => c.id,
    );
    final commandeDatasource = HiveLocalDatasource<Commande>(
      box: _commandeBox,
      getId: (c) => c.id,
    );
    final fournisseurDatasource = HiveLocalDatasource<Fournisseur>(
      box: _fournisseurBox,
      getId: (f) => f.id,
    );
    final refrigerateurDatasource = HiveLocalDatasource<Refrigerateur>(
      box: _refrigerateurBox,
      getId: (r) => r.id,
    );
    final venteDatasource = HiveLocalDatasource<Vente>(
      box: _venteBox,
      getId: (v) => v.id,
    );

    // 4. Créer les repositories
    _barRepository = BarRepositoryImpl(
      box: _barBox,
      idGenerator: _idGenerator,
    );
    _boissonRepository = BoissonRepositoryImpl(boissonDatasource);
    _casierRepository = CasierRepositoryImpl(casierDatasource);
    _commandeRepository = CommandeRepositoryImpl(commandeDatasource);
    _fournisseurRepository = FournisseurRepositoryImpl(fournisseurDatasource);
    _refrigerateurRepository = RefrigerateurRepositoryImpl(refrigerateurDatasource);
    _venteRepository = VenteRepositoryImpl(venteDatasource);

    // 5. Créer les use cases
    _transferDrinksUseCase = TransferDrinksToFridgeUseCase(
      commandeRepository: _commandeRepository,
      refrigerateurRepository: _refrigerateurRepository,
      idGenerator: _idGenerator,
    );

    _inventoryAlertsUseCase = GetInventoryAlertsUseCase(
      refrigerateurRepository: _refrigerateurRepository,
      casierRepository: _casierRepository,
    );

    _statisticsUseCase = GetStatisticsUseCase(
      venteRepository: _venteRepository,
      commandeRepository: _commandeRepository,
      refrigerateurRepository: _refrigerateurRepository,
      casierRepository: _casierRepository,
    );

    _generatePdfUseCase = GeneratePdfUseCase(
      barRepository: _barRepository,
      getStatisticsUseCase: _statisticsUseCase,
    );

    _backupRestoreUseCase = BackupRestoreUseCase(boxes: {
      'bars': _barBox,
      'boissons': _boissonBox,
      'casiers': _casierBox,
      'commandes': _commandeBox,
      'fournisseurs': _fournisseurBox,
      'refrigerateurs': _refrigerateurBox,
      'ventes': _venteBox,
      'id_counters': _idCounterBox,
    });

    _initialized = true;
  }

  // === GETTERS POUR LES REPOSITORIES ===
  IBarRepository get barRepository => _barRepository;
  IBoissonRepository get boissonRepository => _boissonRepository;
  ICasierRepository get casierRepository => _casierRepository;
  ICommandeRepository get commandeRepository => _commandeRepository;
  IFournisseurRepository get fournisseurRepository => _fournisseurRepository;
  IRefrigerateurRepository get refrigerateurRepository => _refrigerateurRepository;
  IVenteRepository get venteRepository => _venteRepository;

  // === GETTERS POUR LES USE CASES ===
  TransferDrinksToFridgeUseCase get transferDrinksUseCase => _transferDrinksUseCase;
  GetInventoryAlertsUseCase get inventoryAlertsUseCase => _inventoryAlertsUseCase;
  GetStatisticsUseCase get statisticsUseCase => _statisticsUseCase;
  GeneratePdfUseCase get generatePdfUseCase => _generatePdfUseCase;
  BackupRestoreUseCase get backupRestoreUseCase => _backupRestoreUseCase;

  // === GETTER POUR ID GENERATOR ===
  IdGenerator get idGenerator => _idGenerator;
}
