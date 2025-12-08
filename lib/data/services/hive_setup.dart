import 'package:hive_flutter/adapters.dart';
import 'package:projet7/domain/entities/bar_instance.dart';
import 'package:projet7/domain/entities/boisson.dart';
import 'package:projet7/domain/entities/casier.dart';
import 'package:projet7/domain/entities/commande.dart';
import 'package:projet7/domain/entities/fournisseur.dart';
import 'package:projet7/domain/entities/id_counter.dart';
import 'package:projet7/domain/entities/ligne_commande.dart';
import 'package:projet7/domain/entities/ligne_vente.dart';
import 'package:projet7/domain/entities/refrigerateur.dart';
import 'package:projet7/domain/entities/vente.dart';
import 'package:projet7/domain/entities/modele.dart';
import 'package:projet7/presentation/providers/theme_provider.dart';

/// Service d'initialisation de la base de données Hive.
///
/// Configure Hive Flutter et enregistre tous les adaptateurs de types
/// nécessaires pour la sérialisation des modèles de données.
///
/// Doit être appelé au démarrage de l'application avant toute opération Hive.
class HiveSetup {
  static Future<void> initialize() async {
    await Hive.initFlutter();

    Hive.registerAdapter(BoissonAdapter());
    Hive.registerAdapter(CasierAdapter());
    Hive.registerAdapter(LigneVenteAdapter());
    Hive.registerAdapter(VenteAdapter());
    Hive.registerAdapter(LigneCommandeAdapter());
    Hive.registerAdapter(CommandeAdapter());
    Hive.registerAdapter(FournisseurAdapter());
    Hive.registerAdapter(BarInstanceAdapter());
    Hive.registerAdapter(RefrigerateurAdapter());
    Hive.registerAdapter(ModeleAdapter());
    Hive.registerAdapter(IdCounterAdapter());
  }

  static Future<ThemeProvider> initializeThemeProvider() async {
    final themeProvider = ThemeProvider();
    await themeProvider.initHive();
    return themeProvider;
  }
}
