import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:projet7/pages/commande/commande_screen.dart';
import 'package:projet7/pages/detail/boisson/boisson_screen.dart';
import 'package:projet7/pages/detail/casier/casier_screen.dart';
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

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final List _pages = [
    const BoissonScreen(),
    const CasierScreen(),
    const CommandeScreen(),
    const RefrigerateurScreen(),
    const VenteScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BarProvider>(
      builder: (context, bar, child) => Scaffold(
        drawer: const MyDrawer(),
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              expandedHeight: 150,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  bar.currentBar?.nom ?? 'Bar',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primaryContainer,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              pinned: true,
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.inversePrimary,
            ),
            SliverFillRemaining(
              child: _pages[_selectedIndex],
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            boxShadow: const [
              BoxShadow(blurRadius: 4, color: Colors.black26),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: GNav(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              activeColor: Theme.of(context).colorScheme.inversePrimary,
              tabBackgroundColor:
                  Theme.of(context).colorScheme.primaryContainer,
              padding: const EdgeInsets.all(12),
              gap: 8,
              onTabChange: navigateBottomBar,
              tabs: const [
                GButton(icon: Icons.wine_bar, text: 'Boissons'),
                GButton(icon: Icons.storage, text: 'Casiers'),
                GButton(icon: Icons.receipt, text: 'Commandes'),
                GButton(icon: Icons.kitchen, text: 'Réfrigérateurs'),
                GButton(icon: Icons.local_drink, text: 'Ventes'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
