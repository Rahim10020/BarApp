import 'package:flutter/material.dart';
import 'package:projet7/pages/detail/boisson/boisson_screen.dart';
import 'package:projet7/pages/detail/casier/casier_screen.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_screen.dart';
import 'package:projet7/ui/theme/app_colors.dart';

/// Écran Stock - Regroupe Boissons, Casiers et Réfrigérateurs
class StockScreen extends StatefulWidget {
  const StockScreen({super.key});

  @override
  State<StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
                icon: Icon(Icons.local_drink),
                text: 'Boissons',
              ),
              Tab(
                icon: Icon(Icons.inventory),
                text: 'Casiers',
              ),
              Tab(
                icon: Icon(Icons.kitchen),
                text: 'Frigos',
              ),
            ],
          ),
        ),
        // Tab Views
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: const [
              BoissonScreen(),
              CasierScreen(),
              RefrigerateurScreen(),
            ],
          ),
        ),
      ],
    );
  }
}
