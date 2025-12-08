import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/presentation/widgets/build_info_card.dart';
import 'package:projet7/domain/entities/casier.dart';
import 'package:projet7/presentation/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/core/utils/helpers.dart';

/// Écran de détail d'un casier.
///
/// Affiche les informations complètes d'un casier:
/// - Identifiant
/// - Nombre total de boissons
/// - Prix total du casier
/// - Type de boisson contenue avec navigation vers les détails
class CasierDetailScreen extends StatelessWidget {
  final Casier casier;

  const CasierDetailScreen({super.key, required this.casier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text(
            'Casier #${casier.id}',
            style: GoogleFonts.montserrat(fontSize: 16),
          ),
          backgroundColor: Colors.brown[800]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildInfoCard(label: 'ID', value: '${casier.id}'),
            BuildInfoCard(
                label: 'Total Boissons', value: '${casier.boissonTotal}'),
            BuildInfoCard(
                label: 'Prix Total',
                value: Helpers.formatterEnCFA(casier.getPrixTotal())),
            const SizedBox(height: 16),
            Text(
              'Boisson dans le casier:',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            if (casier.boissons.isNotEmpty)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.local_bar, color: Colors.brown[600]),
                  title: Text(
                    '${casier.boissons[0].nom} (${casier.boissons[0].modele?.name})',
                    style: GoogleFonts.montserrat(),
                  ),
                  subtitle: Text(
                    Helpers.formatterEnCFA(casier.boissons[0].prix.last),
                    style: GoogleFonts.montserrat(),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BoissonDetailScreen(boisson: casier.boissons[0]),
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
