import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/pages/home/home_page.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/provider/theme_provider.dart';
import 'package:projet7/services/hive_setup.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveSetup.initialize();

  final themeProvider = await HiveSetup.initializeThemeProvider();

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
      return const BarCreationScreen();
    }
    return const HomePage();
  }
}

class BarCreationScreen extends StatefulWidget {
  const BarCreationScreen({super.key});

  @override
  State<BarCreationScreen> createState() => _BarCreationScreenState();
}

class _BarCreationScreenState extends State<BarCreationScreen> {
  final _nomController = TextEditingController();
  final _adresseController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Configurer votre bar',
          style: GoogleFonts.montserrat(),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Bienvenue ! Configurez votre bar pour commencer.',
                style: GoogleFonts.montserrat(fontSize: 18),
              ),
              const SizedBox(height: 20),
              TextField(
                  controller: _nomController,
                  decoration: const InputDecoration(labelText: 'Nom du bar')),
              TextField(
                controller: _adresseController,
                decoration: const InputDecoration(
                    labelText: 'Adresse (email/téléphone)'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_nomController.text.isNotEmpty &&
                      _adresseController.text.isNotEmpty) {
                    await Provider.of<BarProvider>(context, listen: false)
                        .createBar(
                            _nomController.text, _adresseController.text);
                    // Use a post-frame callback to ensure context is valid
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const HomePage()));
                      }
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600]),
                child: Text(
                  'Créer le bar',
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
