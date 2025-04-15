import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/ligne_vente.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/utils/helpers.dart';

class LigneVenteDetailScreen extends StatelessWidget {
  final LigneVente ligneVente;

  const LigneVenteDetailScreen({super.key, required this.ligneVente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Ligne de vente #${ligneVente.id}",
          style: GoogleFonts.montserrat(),
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
              value: ligneVente.id.toString(),
            ),
            BuildInfoCard(
              label: 'Montant',
              value: Helpers.formatterEnCFA(ligneVente.getMontant()),
            ),
            const SizedBox(height: 16),
            Text(
              'Boisson',
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Icon(Icons.local_bar, color: Colors.brown[600]),
                title: Text(
                  ligneVente.boisson.nom ?? 'Sans nom',
                  style: GoogleFonts.montserrat(),
                ),
                subtitle: Text(
                  Helpers.formatterEnCFA(ligneVente.boisson.prix.last),
                ),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BoissonDetailScreen(boisson: ligneVente.boisson),
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
