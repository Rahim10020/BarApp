import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:projet7/ui/widgets/buttons/app_button.dart';
import 'package:projet7/ui/widgets/cards/app_card.dart';
import 'package:projet7/ui/widgets/dialogs/app_dialogs.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

/// Écran des rapports et statistiques
class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  String _selectedPeriod = 'daily';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    // Filtrer les ventes
    final filteredSales = provider.ventes
        .where((v) =>
            v.dateVente.isAfter(_startDate.subtract(const Duration(days: 1))) &&
            v.dateVente.isBefore(_endDate.add(const Duration(days: 1))))
        .toList();

    final totalRevenue = filteredSales.fold(0.0, (sum, v) => sum + v.montantTotal);
    final totalOrders = filteredSales.length;
    final averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0.0;

    // Filtrer les commandes
    final filteredOrders = provider.commandes
        .where((c) =>
            c.dateCommande.isAfter(_startDate.subtract(const Duration(days: 1))) &&
            c.dateCommande.isBefore(_endDate.add(const Duration(days: 1))))
        .toList();

    final totalOrderCost = filteredOrders.fold(0.0, (sum, c) => sum + c.montantTotal);

    // Statistiques avancées
    final revenueByDrink = provider.getRevenueByDrink(_startDate, _endDate);
    final topSellingDrinks = provider.getTopSellingDrinks(_startDate, _endDate);
    final revenueTrends = provider.getRevenueTrends(_startDate, _endDate, _selectedPeriod);
    final inventoryLevels = provider.getInventoryLevels();

    return SingleChildScrollView(
      padding: ThemeConstants.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carte de sélection de période
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(ThemeConstants.spacingSm),
                      decoration: BoxDecoration(
                        color: AppColors.info.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                      ),
                      child: Icon(
                        Icons.date_range_rounded,
                        color: AppColors.info,
                        size: ThemeConstants.iconSizeMd,
                      ),
                    ),
                    SizedBox(width: ThemeConstants.spacingMd),
                    Text(
                      'Période d\'analyse',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),

                SizedBox(height: ThemeConstants.spacingMd),

                // Sélection de dates
                Row(
                  children: [
                    Expanded(
                      child: AppButton.secondary(
                        text: 'Du: ${Helpers.formatterDate(_startDate)}',
                        icon: Icons.calendar_today_rounded,
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _startDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _startDate = picked);
                          }
                        },
                      ),
                    ),
                    SizedBox(width: ThemeConstants.spacingMd),
                    Expanded(
                      child: AppButton.secondary(
                        text: 'Au: ${Helpers.formatterDate(_endDate)}',
                        icon: Icons.event_rounded,
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: _endDate,
                            firstDate: DateTime(2020),
                            lastDate: DateTime.now(),
                          );
                          if (picked != null) {
                            setState(() => _endDate = picked);
                          }
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: ThemeConstants.spacingMd),

                // Période pour les tendances
                AppDropdown<String>(
                  value: _selectedPeriod,
                  label: 'Période pour les tendances',
                  prefixIcon: Icons.trending_up_rounded,
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Quotidien')),
                    DropdownMenuItem(value: 'weekly', child: Text('Hebdomadaire')),
                    DropdownMenuItem(value: 'monthly', child: Text('Mensuel')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => _selectedPeriod = value);
                    }
                  },
                ),

                SizedBox(height: ThemeConstants.spacingMd),

                // Bouton Export PDF
                AppButton.primary(
                  text: 'Exporter en PDF',
                  icon: Icons.download_rounded,
                  isFullWidth: true,
                  onPressed: () async {
                    try {
                      final filePath = await provider.generateStatisticsPdf(
                        _startDate,
                        _endDate,
                        _selectedPeriod,
                      );
                      if (mounted) {
                        context.showSuccessSnackBar('PDF exporté: $filePath');
                      }
                    } catch (e) {
                      if (mounted) {
                        context.showErrorSnackBar('Erreur lors de l\'export PDF');
                      }
                    }
                  },
                ),
              ],
            ),
          ),

          SizedBox(height: ThemeConstants.spacingLg),

          // Section Ventes
          _buildSectionTitle(context, 'Ventes', Icons.point_of_sale_rounded),
          SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            child: Column(
              children: [
                _buildReportRow(
                  context,
                  'Revenus totaux',
                  Helpers.formatterEnCFA(totalRevenue),
                  AppColors.revenue,
                ),
                Divider(height: ThemeConstants.spacingMd),
                _buildReportRow(
                  context,
                  'Nombre de ventes',
                  '$totalOrders',
                  AppColors.info,
                ),
                Divider(height: ThemeConstants.spacingMd),
                _buildReportRow(
                  context,
                  'Panier moyen',
                  Helpers.formatterEnCFA(averageOrderValue),
                  AppColors.primary,
                ),
              ],
            ),
          ),

          SizedBox(height: ThemeConstants.spacingLg),

          // Section Commandes
          _buildSectionTitle(context, 'Commandes', Icons.shopping_cart_rounded),
          SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            child: Column(
              children: [
                _buildReportRow(
                  context,
                  'Coût total',
                  Helpers.formatterEnCFA(totalOrderCost),
                  AppColors.expense,
                ),
                Divider(height: ThemeConstants.spacingMd),
                _buildReportRow(
                  context,
                  'Nombre de commandes',
                  '${filteredOrders.length}',
                  AppColors.info,
                ),
              ],
            ),
          ),

          SizedBox(height: ThemeConstants.spacingLg),

          // Section Bénéfice
          _buildSectionTitle(context, 'Bénéfice estimé', Icons.account_balance_wallet_rounded),
          SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            color: (totalRevenue - totalOrderCost) >= 0
                ? AppColors.success.withOpacity(0.05)
                : AppColors.error.withOpacity(0.05),
            child: _buildReportRow(
              context,
              'Bénéfice (Revenus - Coûts)',
              Helpers.formatterEnCFA(totalRevenue - totalOrderCost),
              (totalRevenue - totalOrderCost) >= 0 ? AppColors.success : AppColors.error,
              isBold: true,
            ),
          ),

          SizedBox(height: ThemeConstants.spacingLg),

          // Section Top Ventes
          _buildSectionTitle(context, 'Boissons les plus vendues', Icons.star_rounded),
          SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            child: topSellingDrinks.isNotEmpty
                ? Column(
                    children: topSellingDrinks.map((entry) {
                      final index = topSellingDrinks.indexOf(entry);
                      return Column(
                        children: [
                          if (index > 0) Divider(height: ThemeConstants.spacingMd),
                          _buildReportRow(
                            context,
                            entry.key,
                            '${entry.value} ventes',
                            AppColors.primary,
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : _buildEmptyState(context, 'Aucune vente dans cette période'),
          ),

          SizedBox(height: ThemeConstants.spacingLg),

          // Section Revenus par boisson
          _buildSectionTitle(context, 'Revenus par boisson', Icons.monetization_on_rounded),
          SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            child: revenueByDrink.isNotEmpty
                ? Column(
                    children: revenueByDrink.entries.map((entry) {
                      final index = revenueByDrink.entries.toList().indexOf(entry);
                      return Column(
                        children: [
                          if (index > 0) Divider(height: ThemeConstants.spacingMd),
                          _buildReportRow(
                            context,
                            entry.key,
                            Helpers.formatterEnCFA(entry.value),
                            AppColors.revenue,
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : _buildEmptyState(context, 'Aucun revenu dans cette période'),
          ),

          SizedBox(height: ThemeConstants.spacingLg),

          // Section Tendances
          _buildSectionTitle(context, 'Tendances des revenus', Icons.trending_up_rounded),
          SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            child: SizedBox(
              height: 250,
              child: _buildRevenueChart(revenueTrends),
            ),
          ),

          SizedBox(height: ThemeConstants.spacingLg),

          // Section Inventaire
          _buildSectionTitle(context, 'Niveaux d\'inventaire', Icons.inventory_rounded),
          SizedBox(height: ThemeConstants.spacingMd),

          AppCard(
            child: inventoryLevels.isNotEmpty
                ? Column(
                    children: inventoryLevels.entries.map((entry) {
                      final index = inventoryLevels.entries.toList().indexOf(entry);
                      return Column(
                        children: [
                          if (index > 0) Divider(height: ThemeConstants.spacingMd),
                          _buildReportRow(
                            context,
                            entry.key,
                            '${entry.value} unités',
                            AppColors.info,
                          ),
                        ],
                      );
                    }).toList(),
                  )
                : _buildEmptyState(context, 'Aucun inventaire disponible'),
          ),

          SizedBox(height: ThemeConstants.spacingXl),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: ThemeConstants.iconSizeMd),
        SizedBox(width: ThemeConstants.spacingSm),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Widget _buildReportRow(
    BuildContext context,
    String label,
    String value,
    Color valueColor, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        SizedBox(width: ThemeConstants.spacingMd),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: valueColor,
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
              ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(BuildContext context, String message) {
    return Padding(
      padding: EdgeInsets.all(ThemeConstants.spacingMd),
      child: Center(
        child: Text(
          message,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ),
    );
  }

  Widget _buildRevenueChart(Map<DateTime, double> trends) {
    if (trends.isEmpty) {
      return _buildEmptyState(context, 'Aucune donnée disponible');
    }

    final sortedTrends = trends.entries.toList()..sort((a, b) => a.key.compareTo(b.key));

    final spots = sortedTrends.asMap().entries.map((entry) {
      return FlSpot(entry.key.toDouble(), entry.value.value);
    }).toList();

    return Padding(
      padding: EdgeInsets.all(ThemeConstants.spacingMd),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: true,
            horizontalInterval: 1,
            verticalInterval: 1,
            getDrawingHorizontalLine: (value) {
              return FlLine(
                color: Theme.of(context).dividerColor,
                strokeWidth: 1,
              );
            },
            getDrawingVerticalLine: (value) {
              return FlLine(
                color: Theme.of(context).dividerColor,
                strokeWidth: 1,
              );
            },
          ),
          titlesData: const FlTitlesData(show: true),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Theme.of(context).dividerColor,
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
