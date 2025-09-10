import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/vente/vente_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';

class VenteListItem extends StatelessWidget {
  final Vente vente;
  final BarProvider provider;

  const VenteListItem({
    super.key,
    required this.vente,
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
        leading: Icon(Icons.receipt_long, color: Colors.brown[600]),
        title: Text(
          'Vente #${vente.id} - ${Helpers.formatterEnCFA(vente.montantTotal)}',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        subtitle: Text(
          'Date : ${Helpers.formatterDate(vente.dateVente)}',
          style: GoogleFonts.montserrat(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => VenteDetailScreen(vente: vente),
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(
                  "Voulez-vous supprimer Vente #${vente.id} ?",
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
                      provider.deleteVente(vente);
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Vente #${vente.id} supprimé avec succès!',
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
      ),
    );
  }
}
