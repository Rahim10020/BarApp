import 'package:flutter/material.dart';
import 'package:projet7/pages/home/components/dashboard_widget.dart';
import 'package:projet7/pages/home/components/my_drawer.dart';
import 'package:projet7/pages/home/screens/gestion_screen.dart';
import 'package:projet7/pages/home/screens/stock_screen.dart';
import 'package:projet7/pages/search/search_screen.dart';
import 'package:projet7/pages/vente/vente_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/app_typography.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:provider/provider.dart';

/// Nouvelle page d'accueil avec navigation simplifiée (4 items max)
class NewHomePage extends StatefulWidget {
  const NewHomePage({super.key});

  @override
  State<NewHomePage> createState() => _NewHomePageState();
}

class _NewHomePageState extends State<NewHomePage> {
  int _selectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    // Liste des pages
    final List<Widget> pages = [
      DashboardWidget(bar: provider, onNavigate: navigateBottomBar),
      const VenteScreen(),
      const StockScreen(),
      const GestionScreen(),
    ];

    // Titres des pages
    final List<String> pageTitles = [
      provider.currentBar?.nom ?? 'BarApp',
      'Ventes',
      'Stock',
      'Gestion',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          pageTitles[_selectedIndex],
          style: AppTypography.pageTitle(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
            tooltip: 'Rechercher',
          ),
        ],
      ),
      drawer: const MyDrawer(),
      body: AnimatedSwitcher(
        duration: ThemeConstants.durationMedium,
        switchInCurve: ThemeConstants.curveEaseOut,
        switchOutCurve: ThemeConstants.curveEaseIn,
        child: KeyedSubtree(
          key: ValueKey(_selectedIndex),
          child: pages[_selectedIndex],
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  /// Bottom Navigation Bar moderne
  Widget _buildBottomNavigationBar(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: ThemeConstants.spacingMd,
            vertical: ThemeConstants.spacingSm,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(
                context: context,
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                label: 'Accueil',
                index: 0,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.point_of_sale_outlined,
                activeIcon: Icons.point_of_sale,
                label: 'Ventes',
                index: 1,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.inventory_2_outlined,
                activeIcon: Icons.inventory_2,
                label: 'Stock',
                index: 2,
              ),
              _buildNavItem(
                context: context,
                icon: Icons.analytics_outlined,
                activeIcon: Icons.analytics,
                label: 'Gestion',
                index: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Item de navigation
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData activeIcon,
    required String label,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: InkWell(
        onTap: () => navigateBottomBar(index),
        borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        child: AnimatedContainer(
          duration: ThemeConstants.durationNormal,
          padding: const EdgeInsets.symmetric(
            vertical: ThemeConstants.spacingSm,
            horizontal: ThemeConstants.spacingXs,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.primaryLight : AppColors.primary)
                    .withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isSelected ? activeIcon : icon,
                color: isSelected
                    ? (isDark ? AppColors.primaryLight : AppColors.primary)
                    : (isDark ? AppColors.greyDark400 : AppColors.greyLight600),
                size: isSelected
                    ? ThemeConstants.iconSizeLg
                    : ThemeConstants.iconSizeMd,
              ),
              const SizedBox(height: ThemeConstants.spacingXs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isSelected
                          ? (isDark
                              ? AppColors.primaryLight
                              : AppColors.primary)
                          : (isDark
                              ? AppColors.greyDark400
                              : AppColors.greyLight600),
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Floating Action Button (vente rapide)
  Widget? _buildFloatingActionButton() {
    if (_selectedIndex == 0) {
      // Sur le dashboard, bouton pour aller à ventes
      return FloatingActionButton.small(
        onPressed: () => navigateBottomBar(1),
        tooltip: 'Vente rapide',
        child: const Icon(Icons.add_shopping_cart, size: 20),
      );
    }
    return null;
  }
}
