import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:projet7/pages/commande/commande_screen.dart';
import 'package:projet7/pages/detail/boisson/boisson_screen.dart';
import 'package:projet7/pages/detail/casier/casier_screen.dart';
import 'package:projet7/pages/home/components/my_drawer.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_screen.dart';
import 'package:projet7/pages/reports/reports_screen.dart';
import 'package:projet7/pages/search/search_screen.dart';
import 'package:projet7/pages/vente/vente_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
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
    const ReportsScreen(),
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
              ? _buildDashboard(bar)
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

  Widget _buildDashboard(BarProvider bar) {
    // Calculate metrics
    final today = DateTime.now();
    final todaySales = bar.ventes
        .where((v) =>
            v.dateVente.year == today.year &&
            v.dateVente.month == today.month &&
            v.dateVente.day == today.day)
        .toList();
    final totalTodaySales =
        todaySales.fold(0.0, (sum, v) => sum + v.montantTotal);

    final totalInventory =
        bar.refrigerateurs.fold(0, (sum, r) => sum + (r.boissons?.length ?? 0));
    final pendingOrders = bar.commandes.length;

    final lowStockAlerts = bar.getLowStockAlerts();
    final expiryAlerts = bar.getExpiryAlerts();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tableau de Bord',
            style: GoogleFonts.montserrat(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          const SizedBox(height: 20),
          if (lowStockAlerts.isNotEmpty) ...[
            Card(
              color: Colors.red[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Alertes Stock',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.red[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...lowStockAlerts.map((alert) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '• $alert',
                            style:
                                GoogleFonts.montserrat(color: Colors.red[600]),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          if (expiryAlerts.isNotEmpty) ...[
            Card(
              color: Colors.orange[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.access_time, color: Colors.orange[600]),
                        const SizedBox(width: 8),
                        Text(
                          'Alertes Expiration',
                          style: GoogleFonts.montserrat(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[600],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ...expiryAlerts.map((alert) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Text(
                            '• $alert',
                            style: GoogleFonts.montserrat(
                                color: Colors.orange[600]),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: [
                _buildMetricCard(
                  'Ventes Aujourd\'hui',
                  Helpers.formatterEnCFA(totalTodaySales),
                  Icons.attach_money,
                  Colors.green,
                ),
                _buildMetricCard(
                  'Stock Total',
                  '$totalInventory boissons',
                  Icons.inventory,
                  Colors.blue,
                ),
                _buildMetricCard(
                  'Commandes en Attente',
                  '$pendingOrders',
                  Icons.pending,
                  Colors.orange,
                ),
                _buildMetricCard(
                  'Total Ventes',
                  '${bar.ventes.length}',
                  Icons.trending_up,
                  Colors.purple,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Actions Rapides',
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () =>
                      setState(() => _selectedIndex = 1), // Navigate to Ventes
                  icon: const Icon(Icons.add_shopping_cart),
                  label:
                      Text('Nouvelle Vente', style: GoogleFonts.montserrat()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => setState(
                      () => _selectedIndex = 4), // Navigate to Commandes
                  icon: const Icon(Icons.add_box),
                  label: Text('Nouvelle Commande',
                      style: GoogleFonts.montserrat()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.montserrat(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
