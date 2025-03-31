import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/ligne_commande.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/utils/helpers.dart';

class LigneCommandeDetailScreen extends StatelessWidget {
  final LigneCommande ligneCommande;

  const LigneCommandeDetailScreen({super.key, required this.ligneCommande});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Ligne de commande #${ligneCommande.id}",
          style: GoogleFonts.montserrat(
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildInfoCard(
              label: 'ID',
              value: ligneCommande.id.toString(),
            ),
            BuildInfoCard(
              label: 'Montant',
              value: Helpers.formatterEnCFA(ligneCommande.getMontant()),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                'Casier #${ligneCommande.casier.id}',
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            if (ligneCommande.casier.boissons.isNotEmpty)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.local_bar, color: Colors.brown[600]),
                  title: Text(
                    '${ligneCommande.casier.boissons[0].nom} (${ligneCommande.casier.boissons[0].modele?.name})',
                    style: GoogleFonts.montserrat(),
                  ),
                  subtitle: Text(
                    Helpers.formatterEnCFA(
                        ligneCommande.casier.boissons[0].prix.last),
                    style: GoogleFonts.montserrat(),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoissonDetailScreen(
                        boisson: ligneCommande.casier.boissons[0],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
