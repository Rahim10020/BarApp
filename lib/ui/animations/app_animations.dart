import 'package:flutter/material.dart';
import '../theme/theme_constants.dart';

/// Utilities pour animations cohérentes
class AppAnimations {
  /// Fade in animation
  static Widget fadeIn({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: duration ?? ThemeConstants.durationMedium,
      curve: curve ?? ThemeConstants.curveDefault,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Slide in from bottom
  static Widget slideInFromBottom({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 50.0, end: 0.0),
      duration: duration ?? ThemeConstants.durationMedium,
      curve: curve ?? ThemeConstants.curveEaseOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: child,
        );
      },
      child: child,
    );
  }

  /// Scale animation
  static Widget scale({
    required Widget child,
    Duration? duration,
    Curve? curve,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.8, end: 1.0),
      duration: duration ?? ThemeConstants.durationMedium,
      curve: curve ?? ThemeConstants.curveElastic,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
          child: child,
        );
      },
      child: child,
    );
  }

  /// Staggered list animation
  static Widget staggeredList({
    required int index,
    required Widget child,
  }) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: ThemeConstants.durationMedium,
      curve: ThemeConstants.curveEaseOut,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - value)),
          child: Opacity(
            opacity: value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Animated container avec transitions cohérentes
class AnimatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final VoidCallback? onTap;
  final bool hasShadow;

  const AnimatedCard({
    super.key,
    required this.child,
    this.padding,
    this.color,
    this.onTap,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: ThemeConstants.durationNormal,
      curve: ThemeConstants.curveDefault,
      padding: padding ?? ThemeConstants.cardPadding,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).cardColor,
        borderRadius: ThemeConstants.cardBorderRadius,
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ]
            : null,
      ),
      child: onTap != null
          ? InkWell(
              onTap: onTap,
              borderRadius: ThemeConstants.cardBorderRadius,
              child: child,
            )
          : child,
    );
  }
}

/// Page route avec transition personnalisée
class AppPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final AppPageTransition transition;

  AppPageRoute({
    required this.page,
    this.transition = AppPageTransition.slideFromRight,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return _buildTransition(
              transition,
              animation,
              secondaryAnimation,
              child,
            );
          },
          transitionDuration: ThemeConstants.durationMedium,
        );

  static Widget _buildTransition(
    AppPageTransition transition,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (transition) {
      case AppPageTransition.slideFromRight:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: ThemeConstants.curveDefault,
          )),
          child: child,
        );

      case AppPageTransition.slideFromBottom:
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: ThemeConstants.curveDefault,
          )),
          child: child,
        );

      case AppPageTransition.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case AppPageTransition.scale:
        return ScaleTransition(
          scale: Tween<double>(
            begin: 0.8,
            end: 1.0,
          ).animate(CurvedAnimation(
            parent: animation,
            curve: ThemeConstants.curveDefault,
          )),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }
}

enum AppPageTransition {
  slideFromRight,
  slideFromBottom,
  fade,
  scale,
}

/// Extension pour naviguer avec transitions
extension NavigationExtension on BuildContext {
  /// Push avec transition personnalisée
  Future<T?> pushWithTransition<T>(
    Widget page, {
    AppPageTransition transition = AppPageTransition.slideFromRight,
  }) {
    return Navigator.of(this).push<T>(
      AppPageRoute(page: page, transition: transition),
    );
  }

  /// Replace avec transition personnalisée
  Future<T?> replaceWithTransition<T>(
    Widget page, {
    AppPageTransition transition = AppPageTransition.slideFromRight,
  }) {
    return Navigator.of(this).pushReplacement<T, void>(
      AppPageRoute(page: page, transition: transition),
    );
  }
}
