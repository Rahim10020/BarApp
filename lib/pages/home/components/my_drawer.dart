import 'package:flutter/material.dart';
import 'package:projet7/pages/a-propos/a_propos_page.dart';
import 'package:projet7/pages/settings/settings_page.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:projet7/ui/theme/app_colors.dart';
import 'package:projet7/ui/theme/theme_constants.dart';
import 'package:provider/provider.dart';

/// Drawer moderne avec design system
class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);
    final barName = provider.currentBar?.nom ?? 'BarApp';
    final barContact = provider.currentBar?.adresse ?? '';

    return Drawer(
      child: Column(
        children: [
          // Header avec gradient
          _buildHeader(context, barName, barContact),

          // Menu items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildMenuItem(
                  context: context,
                  icon: Icons.settings_rounded,
                  title: 'Paramètres',
                  subtitle: 'Configuration de l\'app',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SettingsPage(),
                      ),
                    );
                  },
                ),
                _buildMenuItem(
                  context: context,
                  icon: Icons.info_rounded,
                  title: 'À propos',
                  subtitle: 'Version et informations',
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AProposPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Footer
          _buildFooter(context),
        ],
      ),
    );
  }

  /// Header du drawer avec gradient
  Widget _buildHeader(BuildContext context, String barName, String barContact) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 200,
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
      ),
      child: SafeArea(
        child: Padding(
          padding: ThemeConstants.paddingAll(ThemeConstants.spacingLg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              // Icône
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spacingMd),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                ),
                child: const Icon(
                  Icons.local_bar_rounded,
                  size: ThemeConstants.iconSize2Xl,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: ThemeConstants.spacingMd),

              // Nom du bar
              Text(
                barName,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),

              // Contact
              if (barContact.isNotEmpty) ...[
                const SizedBox(height: ThemeConstants.spacingXs),
                Text(
                  barContact,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Menu item moderne
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(ThemeConstants.spacingSm),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
        ),
        child: Icon(
          icon,
          color: AppColors.primary,
          size: ThemeConstants.iconSizeMd,
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.bodySmall,
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: ThemeConstants.spacingMd,
        vertical: ThemeConstants.spacingXs,
      ),
    );
  }

  /// Footer du drawer
  Widget _buildFooter(BuildContext context) {
    return Container(
      padding: ThemeConstants.paddingAll(ThemeConstants.spacingMd),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).dividerColor,
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.local_bar_rounded,
            size: ThemeConstants.iconSizeSm,
            color: AppColors.primary,
          ),
          const SizedBox(width: ThemeConstants.spacingSm),
          Text(
            'BarApp v1.0',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
