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

/// Point d'entrée principal de l'application BarApp.
///
/// Initialise les services essentiels dans l'ordre suivant :
/// 1. Flutter bindings pour les opérations asynchrones
/// 2. Hive (base de données locale) via [HiveSetup]
/// 3. Provider pour le thème (clair/sombre)
/// 4. Provider principal ([BarAppProvider])
///
/// Configure également la localisation française (fr_FR) pour
/// le formatage des dates et devises.
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

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      child: !provider.isInitialized
          ? const Scaffold(
              key: ValueKey('loading'),
              body: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : (provider.currentBar == null
              ? const BarCreationScreen(key: ValueKey('creation'))
              : const NewHomePage(key: ValueKey('home'))),
    );
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
  bool _isSubmitting = false;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _nomController.addListener(_onFormChanged);
    _adresseController.addListener(_onFormChanged);
  }

  void _onFormChanged() {
    final isValid = _nomController.text.trim().isNotEmpty &&
        _adresseController.text.trim().isNotEmpty;

    if (isValid != _isValid) {
      setState(() {
        _isValid = isValid;
      });
    }
  }

  @override
  void dispose() {
    _nomController
      ..removeListener(_onFormChanged)
      ..dispose();
    _adresseController
      ..removeListener(_onFormChanged)
      ..dispose();
    super.dispose();
  }

  Future<void> _handleCreateBar(BuildContext context) async {
    if (!_isValid || _isSubmitting) return;

    setState(() {
      _isSubmitting = true;
    });

    try {
      await Provider.of<BarAppProvider>(context, listen: false).createBar(
        _nomController.text.trim(),
        _adresseController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bar créé avec succès'),
        ),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NewHomePage()),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuration'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final maxWidth = constraints.maxWidth > 600
                ? ThemeConstants.maxWidthForm
                : constraints.maxWidth - ThemeConstants.pagePadding.horizontal;

            return Center(
              child: SingleChildScrollView(
                padding: ThemeConstants.pagePadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 450),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      final offset = (1 - value) * 24;
                      return Opacity(
                        opacity: value,
                        child: Transform.translate(
                          offset: Offset(0, offset),
                          child: child,
                        ),
                      );
                    },
                    child: _buildCard(context, colorScheme, textTheme),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(
          ThemeConstants.spacingLg,
          ThemeConstants.spacingMd,
          ThemeConstants.spacingLg,
          ThemeConstants.spacingLg,
        ),
        child: AppButton.primary(
          text: _isSubmitting ? 'Création en cours...' : 'Créer le bar',
          icon: Icons.check,
          isFullWidth: true,
          size: AppButtonSize.large,
          onPressed: _isValid && !_isSubmitting
              ? () => _handleCreateBar(context)
              : null,
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Container(
      padding: const EdgeInsets.all(ThemeConstants.spacingLg),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, colorScheme, textTheme),
          const SizedBox(height: ThemeConstants.spacingXl),
          _buildFormFields(context),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    ColorScheme colorScheme,
    TextTheme textTheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Hero(
          tag: 'bar-icon-hero',
          child: Container(
            width: ThemeConstants.iconSize2Xl + 16,
            height: ThemeConstants.iconSize2Xl + 16,
            decoration: BoxDecoration(
              color: colorScheme.primary.withOpacity(0.08),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.local_bar,
              size: ThemeConstants.iconSize2Xl,
              color: colorScheme.primary,
            ),
          ),
        ),
        const SizedBox(height: ThemeConstants.spacingLg),
        Text(
          'Bienvenue !',
          style: textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: ThemeConstants.spacingSm),
        Text(
          'Configurez votre bar pour commencer.\n'
          'Ces informations apparaîtront sur vos reçus et communications.',
          style: textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurface.withOpacity(0.7),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFormFields(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppTextField(
          controller: _nomController,
          label: 'Nom du bar',
          hint: 'Ex : Le Comptoir',
          prefixIcon: Icons.store,
        ),
        const SizedBox(height: ThemeConstants.spacingMd),
        AppTextField(
          controller: _adresseController,
          label: 'Contact',
          hint: 'Email ou téléphone',
          prefixIcon: Icons.contact_mail,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
}
