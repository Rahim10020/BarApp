import 'package:flutter/material.dart';
import 'package:projet7/components/custom_bottom_nav_bar.dart';
import 'package:projet7/pages/detail/boisson/boisson_screen.dart';
import 'package:projet7/pages/detail/casier/casier_screen.dart';
import 'package:projet7/pages/commande/commande_screen.dart';
import 'package:projet7/pages/fournisseur/fournisseur_screen.dart';
import 'package:projet7/pages/home/components/my_drawer.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_screen.dart';
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
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<Widget> _screens = [
    const Center(child: Text('Accueil')), // Placeholder pour la page d'accueil
    const RefrigerateurScreen(),
    const CommandeScreen(),
    const VenteScreen(),
    const FournisseurScreen(),
    const BoissonScreen(),
    const CasierScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _changeScreen(int index) {
    setState(() {
      _currentIndex = index;
      _controller.reset();
      _controller.forward();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          provider.currentBar?.nom ?? 'Bar',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      drawer: const MyDrawer(),
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
          : FadeTransition(
              opacity: _fadeAnimation,
              child: _screens[_currentIndex],
            ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: _changeScreen,
      ),
    );
  }
}
