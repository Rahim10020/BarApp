import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
    const VenteScreen(),
    const BoissonScreen(),
    const CasierScreen(),
    const CommandeScreen(),
    const RefrigerateurScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BarProvider>(
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
                GButton(icon: Icons.local_drink, text: 'Ventes'),
                GButton(icon: Icons.wine_bar, text: 'Boissons'),
                GButton(icon: Icons.storage, text: 'Casiers'),
                GButton(icon: Icons.receipt, text: 'Commandes'),
                GButton(icon: Icons.kitchen, text: 'Réfrigérateurs'),
              ],
            ),
          ),
        ),
        body: _pages[_selectedIndex],
      ),
    );
  }
}
