import 'package:flutter/material.dart';
import '../../theme/theme_constants.dart';

/// Wrapper pour les écrans avec padding cohérent
class ScreenWrapper extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final bool useSafeArea;

  const ScreenWrapper({
    super.key,
    required this.child,
    this.padding,
    this.useSafeArea = true,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Padding(
      padding: padding ?? ThemeConstants.pagePadding,
      child: child,
    );

    if (useSafeArea) {
      content = SafeArea(child: content);
    }

    return content;
  }
}

/// Section header avec titre
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final EdgeInsets? padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.symmetric(vertical: ThemeConstants.spacingMd),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                if (subtitle != null) ...[
                  SizedBox(height: ThemeConstants.spacingXs),
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

/// Empty state (état vide)
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionText;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: ThemeConstants.paddingAll(ThemeConstants.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: ThemeConstants.iconSize2Xl,
              color: Theme.of(context).colorScheme.outline,
            ),
            SizedBox(height: ThemeConstants.spacingLg),
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: ThemeConstants.spacingSm),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
            if (actionText != null && onAction != null) ...[
              SizedBox(height: ThemeConstants.spacingLg),
              ElevatedButton(
                onPressed: onAction,
                child: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state (état d'erreur)
class ErrorState extends StatelessWidget {
  final String? title;
  final String message;
  final String? actionText;
  final VoidCallback? onRetry;

  const ErrorState({
    super.key,
    this.title,
    required this.message,
    this.actionText,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: ThemeConstants.paddingAll(ThemeConstants.spacingXl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: ThemeConstants.iconSize2Xl,
              color: Theme.of(context).colorScheme.error,
            ),
            SizedBox(height: ThemeConstants.spacingLg),
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              SizedBox(height: ThemeConstants.spacingSm),
            ],
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (actionText != null && onRetry != null) ...[
              SizedBox(height: ThemeConstants.spacingLg),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh),
                label: Text(actionText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading state (chargement)
class LoadingState extends StatelessWidget {
  final String? message;

  const LoadingState({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          if (message != null) ...[
            SizedBox(height: ThemeConstants.spacingMd),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}
