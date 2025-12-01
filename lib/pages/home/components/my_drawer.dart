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
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(8),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Header avec gradient et légère animation d'apparition
            _buildHeader(context, barName, barContact),

            // Menu items
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 35),
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
                        PageRouteBuilder(
                          pageBuilder: (_, animation, secondaryAnimation) =>
                              FadeTransition(
                            opacity: animation,
                            child: const SettingsPage(),
                          ),
                          transitionDuration: const Duration(milliseconds: 250),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: ThemeConstants.spacingMd),
                  _buildMenuItem(
                    context: context,
                    icon: Icons.info_rounded,
                    title: 'À propos',
                    subtitle: 'Version et informations',
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (_, animation, secondaryAnimation) =>
                              FadeTransition(
                            opacity: animation,
                            child: const AProposPage(),
                          ),
                          transitionDuration: const Duration(milliseconds: 250),
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
      ),
    );
  }

  /// Header du drawer avec gradient
  Widget _buildHeader(BuildContext context, String barName, String barContact) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(-16 * (1 - value), 0),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkGradient : AppColors.primaryGradient,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icône
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
                ),
                child: const Icon(
                  Icons.local_bar_rounded,
                  size: ThemeConstants.iconSizeLg,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: ThemeConstants.spacingSm),

              // Nom du bar
              Text(
                barName,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Contact
              if (barContact.isNotEmpty) ...[
                const SizedBox(height: ThemeConstants.spacingXs),
                Text(
                  barContact,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(ThemeConstants.radiusLg),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: ThemeConstants.spacingMd,
          vertical: ThemeConstants.spacingXs,
        ),
        child: Row(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              padding: const EdgeInsets.all(ThemeConstants.spacingSm),
              decoration: BoxDecoration(
                color: isDark
                    ? AppColors.primary.withValues(alpha: 0.18)
                    : AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusXl),
              ),
              child: Icon(
                icon,
                color: isDark ? AppColors.accent : AppColors.primary,
                size: ThemeConstants.iconSizeMd,
              ),
            ),
            const SizedBox(width: ThemeConstants.spacingMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: ThemeConstants.spacingXs / 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Footer du drawer
  Widget _buildFooter(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 250),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.local_bar_rounded,
              size: ThemeConstants.iconSizeSm,
              color: isDark ? AppColors.backgroundLight : AppColors.primary,
            ),
            const SizedBox(width: ThemeConstants.spacingSm),
            Text(
              'BarApp v1.0',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color:
                        isDark ? AppColors.backgroundLight : AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
