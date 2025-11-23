import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:projet7/pages/commande/commande_screen.dart';
import 'package:projet7/pages/detail/boisson/boisson_screen.dart';
import 'package:projet7/pages/detail/casier/casier_screen.dart';
import 'package:projet7/pages/home/components/dashboard_widget.dart';
import 'package:projet7/pages/home/components/my_drawer.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_screen.dart';
import 'package:projet7/pages/reports/reports_screen.dart';
import 'package:projet7/pages/search/search_screen.dart';
import 'package:projet7/pages/vente/vente_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:provider/provider.dart';

/// Page d'accueil principale de l'application.
///
/// Gère la navigation entre les différentes sections via une barre
/// de navigation inférieure (GNav):
/// - Tableau de bord
/// - Ventes
/// - Boissons
/// - Casiers
/// - Commandes
/// - Réfrigérateurs
/// - Rapports
///
/// Inclut également un drawer latéral et un bouton de recherche.
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
    const VenteScreen(),
    const BoissonScreen(),
    const CasierScreen(),
    const CommandeScreen(),
    const RefrigerateurScreen(),
    const ReportsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BarAppProvider>(
      builder: (context, bar, child) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          foregroundColor: Theme.of(context).colorScheme.inversePrimary,
          centerTitle: true,
          title: Text(
            bar.currentBar!.nom,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              ),
            ),
          ],
        ),
        drawer: const MyDrawer(),
        backgroundColor: Theme.of(context).colorScheme.surface,
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: GNav(
              backgroundColor: Theme.of(context).colorScheme.secondary,
              activeColor: Theme.of(context).colorScheme.inversePrimary,
              tabBackgroundColor: Theme.of(context).colorScheme.surface,
              padding: const EdgeInsets.all(8),
              gap: 8,
              onTabChange: (index) {
                navigateBottomBar(index);
              },
              tabs: const [
                GButton(icon: Icons.dashboard, text: 'Accueil'),
                GButton(icon: Icons.local_drink, text: 'Ventes'),
                GButton(icon: Icons.wine_bar, text: 'Boissons'),
                GButton(icon: Icons.storage, text: 'Casiers'),
                GButton(icon: Icons.receipt, text: 'Commandes'),
                GButton(icon: Icons.kitchen, text: 'Réfrigérateurs'),
                GButton(icon: Icons.analytics, text: 'Rapports'),
              ],
            ),
          ),
        ),
        body: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: _selectedIndex == 0
              ? DashboardWidget(bar: bar, onNavigate: navigateBottomBar)
              : _pages[_selectedIndex - 1],
        ),
        floatingActionButton: _selectedIndex == 0
            ? FloatingActionButton(
                onPressed: () => setState(() => _selectedIndex = 1),
                backgroundColor: Colors.brown[600],
                child: const Icon(Icons.add_shopping_cart),
              )
            : null,
      ),
    );
  }
}
