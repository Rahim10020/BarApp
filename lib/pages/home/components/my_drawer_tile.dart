import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Élément de menu personnalisé pour le drawer de navigation.
///
/// Affiche une icône et un texte stylisé pour représenter
/// une option de navigation dans le menu latéral.
///
/// Exemple d'utilisation:
/// ```dart
/// MyDrawerTile(
///   text: 'Paramètres',
///   icon: Icons.settings,
///   onTap: () => Navigator.pushNamed(context, '/settings'),
/// )
/// ```
class MyDrawerTile extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onTap;

  const MyDrawerTile({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: ListTile(
        title: Text(
          text,
          style: GoogleFonts.montserrat(
            fontSize: 18,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        leading: Icon(
          icon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        onTap: onTap,
      ),
    );
  }
}
