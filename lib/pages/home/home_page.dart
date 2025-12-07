import 'package:flutter/material.dart';
import 'package:projet7/pages/home/components/dashboard_widget.dart';
import 'package:projet7/pages/home/components/my_drawer.dart';
import 'package:projet7/pages/home/screens/gestion_screen.dart';
import 'package:projet7/pages/home/screens/stock_screen.dart';
import 'package:projet7/pages/search/search_screen.dart';
import 'package:projet7/pages/vente/vente_screen.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_typography.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:provider/provider.dart';

/// Nouvelle page d'accueil avec navigation simplifiée (4 items max)
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);

    final List<Widget> pages = [
      DashboardWidget(bar: provider, onNavigate: navigateBottomBar),
      const VenteScreen(),
      const StockScreen(),
      const GestionScreen(),
    ];

    final List<String> pageTitles = [
      provider.currentBar?.nom ?? 'BarApp',
      'Ventes',
      'Stock',
      'Gestion',
    ];

    final List<String> pageSubtitles = [
      'Vue d’ensemble et actions rapides',
      'Suivi des ventes et encaissements',
      'Inventaire et réassort',
      'Indicateurs de pilotage',
    ];

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: _buildHomeAppBar(
        context: context,
        title: pageTitles[_selectedIndex],
        subtitle: pageSubtitles[_selectedIndex],
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

  PreferredSizeWidget _buildHomeAppBar({
    required BuildContext context,
    required String title,
    required String subtitle,
  }) {
    final theme = Theme.of(context);
    final subtitleStyle = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontWeight: FontWeight.w500,
    );

    return AppBar(
      toolbarHeight: 84,
      centerTitle: false,
      titleSpacing: ThemeConstants.spacingMd,
      scrolledUnderElevation: 0,
      backgroundColor: theme.colorScheme.surface,
      surfaceTintColor: theme.colorScheme.surface,
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: ThemeConstants.spacingXs),
          Text(title, style: AppTypography.pageTitle(context)),
          Text(subtitle, style: subtitleStyle),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: ThemeConstants.spacingMd),
          child: FilledButton.tonalIcon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
            icon: const Icon(Icons.search),
            label: const Text('. .'),
          ),
        ),
      ],
    );
  }

  /// Bottom Navigation Bar style WhatsApp
  Widget _buildBottomNavigationBar(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(
        ThemeConstants.spacingMd,
        0,
        ThemeConstants.spacingMd,
        ThemeConstants.spacingMd,
      ),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        elevation: 0,
        color: colorScheme.surfaceContainerHighest
            .withValues(alpha: theme.brightness == Brightness.dark ? 0.7 : 0.9),
        child: NavigationBar(
          backgroundColor: Colors.transparent,
          indicatorColor: colorScheme.primaryContainer,
          indicatorShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          height: 72,
          labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
          selectedIndex: _selectedIndex,
          onDestinationSelected: navigateBottomBar,
          destinations: _navDestinations
              .map(
                (destination) => NavigationDestination(
                  icon: Icon(destination.icon),
                  selectedIcon: Icon(destination.selectedIcon),
                  label: destination.label,
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  /// Floating Action Button (vente rapide)
  Widget? _buildFloatingActionButton() {
    if (_selectedIndex == 0) {
      // Sur le dashboard, bouton pour aller à ventes
      return FloatingActionButton.extended(
        onPressed: () => navigateBottomBar(1),
        icon: const Icon(Icons.point_of_sale),
        label: const Text('Vente rapide'),
        heroTag: 'quick-sale-action',
      );
    }
    return null;
  }
}

class _NavigationDestinationData {
  final IconData icon;
  final IconData selectedIcon;
  final String label;

  const _NavigationDestinationData({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });
}

const List<_NavigationDestinationData> _navDestinations = [
  _NavigationDestinationData(
    icon: Icons.home_outlined,
    selectedIcon: Icons.home,
    label: 'Accueil',
  ),
  _NavigationDestinationData(
    icon: Icons.point_of_sale_outlined,
    selectedIcon: Icons.point_of_sale,
    label: 'Ventes',
  ),
  _NavigationDestinationData(
    icon: Icons.inventory_2_outlined,
    selectedIcon: Icons.inventory_2,
    label: 'Stock',
  ),
  _NavigationDestinationData(
    icon: Icons.analytics_outlined,
    selectedIcon: Icons.analytics,
    label: 'Gestion',
  ),
];
