import 'package:hive_flutter/adapters.dart';
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
import 'package:projet7/models/modele.dart';
import 'package:projet7/provider/theme_provider.dart';

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
