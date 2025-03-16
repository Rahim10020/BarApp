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
  // final barProvider = BarProvider();
  // await barProvider.initHive();

  //await Hive.openBox<Boisson>("boissons");
  //await Hive.openBox<Boisson>("casiers");
  //await Hive.openBox<Boisson>("commandes");
  //await Hive.openBox<Boisson>("refrigerateurs");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeProvider),
        ChangeNotifierProvider(create: (context) => BarProvider()),
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
      home: const BarSetupScreen(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}

class BarSetupScreen extends StatelessWidget {
  const BarSetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    if (provider.currentBar == null) {
      return BarCreationScreen();
    }
    return const HomePage();
  }
}

class BarCreationScreen extends StatefulWidget {
  const BarCreationScreen({super.key});

  @override
  _BarCreationScreenState createState() => _BarCreationScreenState();
}

class _BarCreationScreenState extends State<BarCreationScreen> {
  final _nomController = TextEditingController();
  final _adresseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Configurer votre bar')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Bienvenue ! Configurez votre bar pour commencer.',
                style: TextStyle(fontSize: 18)),
            SizedBox(height: 20),
            TextField(
                controller: _nomController,
                decoration: InputDecoration(labelText: 'Nom du bar')),
            TextField(
                controller: _adresseController,
                decoration:
                    InputDecoration(labelText: 'Adresse (email/téléphone)')),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_nomController.text.isNotEmpty &&
                    _adresseController.text.isNotEmpty) {
                  Provider.of<BarProvider>(context, listen: false)
                      .createBar(_nomController.text, _adresseController.text);
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (_) => const HomePage()));
                }
              },
              child: Text('Créer le bar'),
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.brown[600]),
            ),
          ],
        ),
      ),
    );
  }
}
