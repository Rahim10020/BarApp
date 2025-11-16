import 'package:flutter/material.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/utils/helpers.dart';

/// Dashboard moderne avec design system
class DashboardWidget extends StatelessWidget {
  final BarAppProvider bar;
  final Function(int) onNavigate;

  const DashboardWidget({
    super.key,
    required this.bar,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    // Calcul des métriques
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

    return SingleChildScrollView(
      padding: ThemeConstants.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Titre
          Text(
            'Tableau de Bord',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: ThemeConstants.spacingLg),

          // === ALERTES ===
          if (lowStockAlerts.isNotEmpty) ...[
            _buildAlertCard(
              context: context,
              title: 'Alertes Stock',
              icon: Icons.warning_rounded,
              color: AppColors.error,
              alerts: lowStockAlerts,
            ),
            const SizedBox(height: ThemeConstants.spacingMd),
          ],

          if (expiryAlerts.isNotEmpty) ...[
            _buildAlertCard(
              context: context,
              title: 'Alertes Expiration',
              icon: Icons.access_time_rounded,
              color: AppColors.warning,
              alerts: expiryAlerts,
            ),
            const SizedBox(height: ThemeConstants.spacingMd),
          ],

          // === MÉTRIQUES (GRID) ===
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: ThemeConstants.spacingMd,
            mainAxisSpacing: ThemeConstants.spacingMd,
            childAspectRatio: 1.1,
            children: [
              AppStatCard(
                label: 'Ventes Aujourd\'hui',
                value: Helpers.formatterEnCFA(totalTodaySales),
                icon: Icons.payments_rounded,
                color: AppColors.revenue,
                onTap: () => onNavigate(1),
              ),
              AppStatCard(
                label: 'Stock Total',
                value: '$totalInventory',
                icon: Icons.inventory_2_rounded,
                color: AppColors.coldDrink,
                onTap: () => onNavigate(2),
              ),
              AppStatCard(
                label: 'Commandes',
                icon: Icons.shopping_cart_rounded,
                value: '$pendingOrders',
                color: AppColors.warning,
                onTap: () => onNavigate(3),
              ),
              AppStatCard(
                label: 'Total Ventes',
                value: '${bar.ventes.length}',
                icon: Icons.trending_up_rounded,
                color: AppColors.secondary,
                onTap: () => onNavigate(3),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacingXl),

          // === ACTIONS RAPIDES ===
          Text(
            'Actions Rapides',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          Row(
            children: [
              Expanded(
                child: AppButton.primary(
                  text: 'Nouvelle Vente',
                  icon: Icons.add_shopping_cart_rounded,
                  onPressed: () => onNavigate(1),
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingMd),
              Expanded(
                child: AppButton.secondary(
                  text: 'Nouvelle Commande',
                  icon: Icons.add_box_rounded,
                  onPressed: () => onNavigate(3),
                ),
              ),
            ],
          ),

          const SizedBox(height: ThemeConstants.spacingMd),

          // Bouton Voir Rapports
          AppButton(
            text: 'Voir les Rapports',
            icon: Icons.analytics_rounded,
            type: AppButtonType.text,
            isFullWidth: true,
            onPressed: () => onNavigate(3),
          ),
        ],
      ),
    );
  }

  /// Card d'alerte moderne
  Widget _buildAlertCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required List<String> alerts,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppCard(
      color: color.withOpacity(isDark ? 0.15 : 0.1),
      border: Border.all(
        color: color.withOpacity(0.3),
        width: ThemeConstants.borderWidthThin,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: ThemeConstants.iconSizeMd,
                ),
              ),
              const SizedBox(width: ThemeConstants.spacingMd),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: ThemeConstants.spacingSm,
                  vertical: ThemeConstants.spacingXs,
                ),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius:
                      BorderRadius.circular(ThemeConstants.radiusFull),
                ),
                child: Text(
                  '${alerts.length}',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: ThemeConstants.spacingMd),

          // Liste des alertes (max 3 affichées)
          ...alerts.take(3).map((alert) => Padding(
                padding:
                    const EdgeInsets.only(bottom: ThemeConstants.spacingXs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 6),
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: ThemeConstants.spacingSm),
                    Expanded(
                      child: Text(
                        alert,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: color,
                            ),
                      ),
                    ),
                  ],
                ),
              )),

          // Indicateur "plus d'alertes"
          if (alerts.length > 3) ...[
            const SizedBox(height: ThemeConstants.spacingXs),
            Text(
              '+ ${alerts.length - 3} autres alertes',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: color,
                    fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ],
      ),
    );
  }
}
