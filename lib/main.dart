import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
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
  Hive.registerAdapter(IdCounterAdapter());

  final themeProvider = ThemeProvider();
  await themeProvider.initHive();

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
      title: "Baristo",
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
    final provider = Provider.of<BarProvider>(context, listen: false);

    return FutureBuilder<void>(
      future: provider.initProvider(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          );
        }
        if (provider.currentBar == null) {
          return const BarCreationScreen();
        }
        return const HomePage();
      },
    );
  }
}

class BarCreationScreen extends StatefulWidget {
  const BarCreationScreen({super.key});

  @override
  State<BarCreationScreen> createState() => _BarCreationScreenState();
}

class _BarCreationScreenState extends State<BarCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomController = TextEditingController();
  final _adresseController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _nomController.dispose();
    _adresseController.dispose();
    super.dispose();
  }

  void _createBar() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<BarProvider>(context, listen: false).createBar(
          _nomController.text.trim(),
          _adresseController.text.trim(),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Erreur lors de la création du bar : $e',
              style: GoogleFonts.montserrat(),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).colorScheme.primary.withOpacity(0.1),
              Theme.of(context).colorScheme.background,
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Image.asset(
                      "lib/assets/logo.png",
                      height: 80.0,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Bienvenue dans Baristo',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Configurez votre bar pour commencer',
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.7),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),
                    Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nomController,
                              decoration: InputDecoration(
                                labelText: 'Nom du bar',
                                prefixIcon: Icon(Icons.store,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer le nom du bar';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 16),
                            TextFormField(
                              controller: _adresseController,
                              decoration: InputDecoration(
                                labelText: 'Adresse (email/téléphone)',
                                prefixIcon: Icon(Icons.email,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor: Theme.of(context)
                                    .colorScheme
                                    .surfaceVariant,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Veuillez entrer une adresse';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: _isLoading ? null : _createBar,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        curve: Curves.easeInOut,
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: _isLoading
                              ? Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withOpacity(0.5)
                              : Theme.of(context).colorScheme.primaryContainer,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Center(
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                )
                              : Text(
                                  'Créer le bar',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
