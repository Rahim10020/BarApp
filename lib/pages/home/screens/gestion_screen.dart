import 'package:flutter/material.dart';
import 'package:projet7/pages/commande/commande_screen.dart';
import 'package:projet7/pages/reports/reports_screen.dart';
import 'package:projet7/ui/theme/app_colors.dart';

/// Écran Gestion - Regroupe Commandes et Reports
class GestionScreen extends StatefulWidget {
  const GestionScreen({super.key});

  @override
  State<GestionScreen> createState() => _GestionScreenState();
}

class _GestionScreenState extends State<GestionScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
          ),
          child: TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.accent
                : AppColors.primary,
            unselectedLabelColor:
                Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
            indicatorColor: Theme.of(context).brightness == Brightness.dark
                ? AppColors.accent
                : AppColors.primary,
            indicatorWeight: 3,
            labelStyle: Theme.of(context).textTheme.titleSmall,
            unselectedLabelStyle: Theme.of(context).textTheme.titleSmall,
            tabs: const [
              Tab(
                icon: Icon(Icons.shopping_cart),
                text: 'Commandes',
              ),
              Tab(
                icon: Icon(Icons.analytics),
                text: 'Rapports',
              ),
            ],
          ),
        ),
        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              CommandeScreen(),
              ReportsScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
