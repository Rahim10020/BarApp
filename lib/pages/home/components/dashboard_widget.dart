import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';

class DashboardWidget extends StatelessWidget {
  final BarProvider bar;
  final Function(int) onNavigate;

  const DashboardWidget(
      {super.key, required this.bar, required this.onNavigate});

  @override
  Widget build(BuildContext context) {
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
                  context,
                ),
                _buildMetricCard(
                  'Stock Total',
                  '$totalInventory boissons',
                  Icons.inventory,
                  Colors.blue,
                  context,
                ),
                _buildMetricCard(
                  'Commandes en Attente',
                  '$pendingOrders',
                  Icons.pending,
                  Colors.orange,
                  context,
                ),
                _buildMetricCard(
                  'Total Ventes',
                  '${bar.ventes.length}',
                  Icons.trending_up,
                  Colors.purple,
                  context,
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
                  onPressed: () => onNavigate(1),
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
                  onPressed: () => onNavigate(4),
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

  Widget _buildMetricCard(String title, String value, IconData icon,
      Color color, BuildContext context) {
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
