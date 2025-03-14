import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:projet7/models/bar_instance.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/ligne_commande.dart';
import 'package:projet7/models/ligne_vente.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/home/home_page.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/provider/theme_provider.dart';
import 'package:projet7/models/modele.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  final themeProvider = ThemeProvider();
  await themeProvider.initHive();
  final barProvider = BarProvider();
  await barProvider.initHive();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeProvider),
        ChangeNotifierProvider(create: (context) => barProvider),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "BAR",
      supportedLocales: const [
        Locale("fr", "FR"),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
