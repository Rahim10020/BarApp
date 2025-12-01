import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../theme/theme_constants.dart';

/// Card de base réutilisable avec styles cohérents
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool hasShadow;
  final BorderRadius? borderRadius;
  final Border? border;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.hasShadow = true,
    this.borderRadius,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Widget cardContent = Container(
      padding: padding ?? ThemeConstants.cardPadding,
      decoration: BoxDecoration(
        color: color ?? (isDark ? AppColors.cardDark : AppColors.cardLight),
        borderRadius: borderRadius ?? ThemeConstants.cardBorderRadius,
        border: border,
        boxShadow: hasShadow
            ? (isDark ? AppColors.shadowDark : AppColors.shadowMd)
            : null,
      ),
      child: child,
    );

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: borderRadius ?? ThemeConstants.cardBorderRadius,
        child: cardContent,
      );
    }

    return cardContent;
  }
}

/// Card avec titre et icône
class AppInfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final Widget? trailing;

  const AppInfoCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: backgroundColor,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(ThemeConstants.spacingMd),
            decoration: BoxDecoration(
              color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
            ),
            child: Icon(
              icon,
              color: iconColor ?? AppColors.primary,
              size: ThemeConstants.iconSizeLg,
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
                if (subtitle != null) ...[
                  const SizedBox(height: ThemeConstants.spacingXs),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

/// Card pour afficher des statistiques
class AppStatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;
  final String? trend; // Ex: "+12%"
  final bool isPositiveTrend;

  const AppStatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color,
    this.onTap,
    this.trend,
    this.isPositiveTrend = true,
  });

  @override
  Widget build(BuildContext context) {
    final statColor = color ?? AppColors.primary;

    return AppCard(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(ThemeConstants.spacingSm),
                decoration: BoxDecoration(
                  color: statColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
                ),
                child: Icon(
                  icon,
                  color: statColor,
                  size: ThemeConstants.iconSizeMd,
                ),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: ThemeConstants.spacingSm,
                    vertical: ThemeConstants.spacingXs,
                  ),
                  decoration: BoxDecoration(
                    color:
                        (isPositiveTrend ? AppColors.success : AppColors.error)
                            .withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(ThemeConstants.radiusSm),
                  ),
                  child: Text(
                    trend!,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: isPositiveTrend
                              ? AppColors.success
                              : AppColors.error,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: ThemeConstants.spacingSm),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: statColor,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: ThemeConstants.spacingXs),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

/// Card pour afficher un item de liste (ex: boisson, vente)
class AppListCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? trailing;
  final IconData? leadingIcon;
  final Color? leadingIconColor;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;
  final Widget? customTrailing;
  final List<Widget>? actions;

  const AppListCard({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.leadingIcon,
    this.leadingIconColor,
    this.onTap,
    this.onDelete,
    this.onEdit,
    this.customTrailing,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(ThemeConstants.spacingMd),
      child: Row(
        children: [
          // Leading icon
          if (leadingIcon != null)
            Container(
              padding: const EdgeInsets.all(ThemeConstants.spacingSm),
              decoration: BoxDecoration(
                color: (leadingIconColor ?? AppColors.primary)
                    .withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(ThemeConstants.radiusMd),
              ),
              child: Icon(
                leadingIcon,
                color: leadingIconColor ?? AppColors.primary,
                size: ThemeConstants.iconSizeMd,
              ),
            ),
          if (leadingIcon != null)
            const SizedBox(width: ThemeConstants.spacingMd),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: ThemeConstants.spacingXs),
                  Text(
                    subtitle!,
                    style: Theme.of(context).textTheme.bodySmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),

          // Trailing
          if (trailing != null)
            Padding(
              padding: const EdgeInsets.only(left: ThemeConstants.spacingSm),
              child: Text(
                trailing!,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),

          if (customTrailing != null)
            Padding(
              padding: const EdgeInsets.only(left: ThemeConstants.spacingSm),
              child: customTrailing!,
            ),

          // Actions
          if (actions != null) ...actions!,
          if (onEdit != null)
            IconButton(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_outlined),
              iconSize: ThemeConstants.iconSizeSm,
              color: AppColors.primary,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(ThemeConstants.spacingSm),
            ),
          if (onDelete != null)
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete_outline),
              iconSize: ThemeConstants.iconSizeSm,
              color: AppColors.error,
              constraints: const BoxConstraints(),
              padding: const EdgeInsets.all(ThemeConstants.spacingSm),
            ),
        ],
      ),
    );
  }
}

/// Card vide (placeholder)
class AppEmptyCard extends StatelessWidget {
  final String message;
  final IconData icon;
  final String? actionText;
  final VoidCallback? onAction;

  const AppEmptyCard({
    super.key,
    required this.message,
    this.icon = Icons.inbox_outlined,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(ThemeConstants.spacingXl),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: ThemeConstants.iconSize2Xl,
            color: AppColors.greyLight400,
          ),
          const SizedBox(height: ThemeConstants.spacingMd),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.greyLight600,
                ),
            textAlign: TextAlign.center,
          ),
          if (actionText != null && onAction != null) ...[
            const SizedBox(height: ThemeConstants.spacingLg),
            TextButton(
              onPressed: onAction,
              child: Text(actionText!),
            ),
          ],
        ],
      ),
    );
  }
}
