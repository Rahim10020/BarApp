import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Carte d'information réutilisable affichant une paire label-valeur.
///
/// Utilisée dans les écrans de détail pour afficher des informations
/// sous forme de carte avec le label à gauche et la valeur en gras à droite.
///
/// Exemple d'utilisation:
/// ```dart
/// BuildInfoCard(
///   label: 'Prix',
///   value: '1500 FCFA',
/// )
/// ```
class BuildInfoCard extends StatelessWidget {
  final String label;
  final String value;

  const BuildInfoCard({
    super.key,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.montserrat(),
            ),
            Text(
              value,
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
