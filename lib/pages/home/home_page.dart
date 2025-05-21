import 'package:flutter/material.dart';
import 'package:projet7/components/custom_bottom_nav_bar.dart';
import 'package:projet7/pages/a-propos/a_propos_page.dart';
import 'package:projet7/pages/accueil_screen.dart';
import 'package:projet7/pages/commande/commande_screen.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_screen.dart';
import 'package:projet7/pages/settings/settings_page.dart';
import 'package:projet7/pages/vente/vente_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  late PageController _pageController;
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    const AccueilScreen(),
    const CommandeScreen(),
    const VenteScreen(),
    const RefrigerateurScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _pageController.addListener(() {
      final newIndex = _pageController.page?.round() ?? _currentIndex;
      if (newIndex != _currentIndex) {
        setState(() {
          _currentIndex = newIndex;
          _controller.reset();
          _controller.forward();
        });
      }
    });
    _controller.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _changeScreen(int index) {
    _pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              "lib/assets/logo.png",
              height: 32.0,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.local_drink),
            ),
            Text(
              provider.currentBar?.nom ?? 'Bar',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          PopupMenuButton<String>(
            icon: Icon(
              Icons.more_vert,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onSelected: (value) {
              if (value == 'settings') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              } else if (value == 'about') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const AProposPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              PopupMenuItem<String>(
                value: 'about',
                child: Row(
                  children: [
                    Icon(
                      Icons.info,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "À Propos",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(width: 8.0),
                    Text(
                      "Paramètres",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: provider.currentBar == null
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Aucun bar sélectionné',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) => AlertDialog(
                          title: Text(
                            'Créer un bar',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Nom du bar',
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Theme.of(context)
                                      .colorScheme
                                      .surfaceVariant,
                                ),
                                onSubmitted: (value) async {
                                  if (value.isNotEmpty) {
                                    await provider.createBar(value, '');
                                    Navigator.pop(context);
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: const Text('Créer un bar'),
                  ),
                ],
              ),
            )
          : PageView(
              controller: _pageController,
              children: _screens,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _controller.reset();
                  _controller.forward();
                });
              },
            ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _changeScreen,
      ),
    );
  }
}
