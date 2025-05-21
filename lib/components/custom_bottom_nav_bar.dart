import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: GNav(
          selectedIndex: currentIndex,
          onTabChange: onTap,
          backgroundColor: Theme.of(context).colorScheme.surface,
          activeColor: Theme.of(context).colorScheme.primaryContainer,
          tabBackgroundColor:
              Theme.of(context).colorScheme.primaryContainer.withOpacity(0.2),
          gap: 8,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          tabs: const [
            GButton(
              icon: Icons.home,
              text: 'Accueil',
            ),
            GButton(
              icon: Icons.receipt,
              text: 'Commandes',
            ),
            GButton(
              icon: Icons.local_drink,
              text: 'Ventes',
            ),
            GButton(
              icon: Icons.kitchen,
              text: 'Réfrigérateurs',
            ),
          ],
        ),
      ),
    );
  }
}
