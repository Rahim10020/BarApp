import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/pages/detail/boisson/modifier_boisson_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';

class BoissonListItem extends StatelessWidget {
  final Boisson boisson;
  final BarProvider provider;

  const BoissonListItem({
    super.key,
    required this.boisson,
    required this.provider,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(blurRadius: 4, color: Colors.black12)],
      ),
      child: ListTile(
        leading: Icon(
          boisson.estFroid ? Icons.ac_unit : Icons.local_bar,
          color: Colors.brown[600],
        ),
        title: Row(
          children: [
            Text(
              boisson.nom ?? 'Sans nom',
              style: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            Text(
              ' (${boisson.modele?.name})',
              style: GoogleFonts.montserrat(color: Colors.blue),
            ),
          ],
        ),
        subtitle: Text(Helpers.formatterEnCFA(boisson.prix.last)),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ModifierBoissonScreen(
                      boisson: boisson,
                    ),
                  ),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      "Voulez-vous supprimer ${boisson.nom} ?",
                      style: GoogleFonts.montserrat(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "Annuler",
                          style: GoogleFonts.montserrat(),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          provider.deleteBoisson(boisson);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                '${boisson.nom} supprimé avec succès!',
                                style: GoogleFonts.montserrat(),
                              ),
                            ),
                          );
                        },
                        child: Text(
                          "Oui",
                          style: GoogleFonts.montserrat(),
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ],
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BoissonDetailScreen(boisson: boisson),
          ),
        ),
      ),
    );
  }
}
