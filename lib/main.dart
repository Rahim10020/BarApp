import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projet7/pages/home/new_home_page.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/provider/theme_provider.dart';
import 'package:projet7/services/hive_setup.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/inputs/app_text_field.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await HiveSetup.initialize();

  final themeProvider = await HiveSetup.initializeThemeProvider();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => themeProvider),
        ChangeNotifierProvider(create: (context) => BarAppProvider()),
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
      title: "BarApp",
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
    final provider = Provider.of<BarAppProvider>(context);
    if (provider.currentBar == null) {
      return const BarCreationScreen();
    }
    return const NewHomePage();
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
        title: const Text('Configuration'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: ThemeConstants.pagePadding,
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: ThemeConstants.maxWidthForm),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Icône
                Icon(
                  Icons.local_bar,
                  size: ThemeConstants.iconSize2Xl,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: ThemeConstants.spacingLg),

                // Titre
                Text(
                  'Bienvenue !',
                  style: Theme.of(context).textTheme.headlineMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ThemeConstants.spacingSm),

                // Sous-titre
                Text(
                  'Configurez votre bar pour commencer.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: ThemeConstants.spacingXl),

                // Champ nom
                AppTextField(
                  controller: _nomController,
                  label: 'Nom du bar',
                  hint: 'Ex: Le Comptoir',
                  prefixIcon: Icons.store,
                ),
                const SizedBox(height: ThemeConstants.spacingMd),

                // Champ adresse
                AppTextField(
                  controller: _adresseController,
                  label: 'Contact',
                  hint: 'Email ou téléphone',
                  prefixIcon: Icons.contact_mail,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: ThemeConstants.spacingXl),

                // Bouton créer
                AppButton.primary(
                  text: 'Créer le bar',
                  icon: Icons.check,
                  isFullWidth: true,
                  size: AppButtonSize.large,
                  onPressed: () async {
                    if (_nomController.text.isNotEmpty &&
                        _adresseController.text.isNotEmpty) {
                      await Provider.of<BarAppProvider>(context, listen: false)
                          .createBar(
                              _nomController.text, _adresseController.text);
                      // Use a post-frame callback to ensure context is valid
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        if (mounted) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const NewHomePage()));
                        }
                      });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
