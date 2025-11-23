import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/utils/helpers.dart';

/// Écran de détail d'un réfrigérateur.
///
/// Affiche les informations complètes d'un réfrigérateur:
/// - Nom et température
/// - Nombre total de boissons
/// - Prix total des boissons
/// - Liste des boissons avec navigation vers les détails
class RefrigerateurDetailScreen extends StatelessWidget {
  final Refrigerateur refrigerateur;

  const RefrigerateurDetailScreen({super.key, required this.refrigerateur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          refrigerateur.nom,
          style: GoogleFonts.montserrat(
            color: Colors.white,
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
            BuildInfoCard(label: 'Nom', value: refrigerateur.nom),
            if (refrigerateur.temperature != null)
              BuildInfoCard(
                label: 'Température',
                value: '${refrigerateur.temperature}°C',
              ),
            BuildInfoCard(
              label: 'Total Boissons',
              value: '${refrigerateur.getBoissonTotal()}',
            ),
            BuildInfoCard(
              label: 'Prix Total',
              value: Helpers.formatterEnCFA(refrigerateur.getPrixTotal()),
            ),
            const SizedBox(height: 16),
            Text(
              'Boissons:',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: refrigerateur.boissons?.length ?? 0,
                itemBuilder: (context, index) {
                  var boisson = refrigerateur.boissons![index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.local_bar, color: Colors.brown[600]),
                      title: Row(
                        children: [
                          Text(
                            boisson.nom ?? 'Sans nom',
                            style: GoogleFonts.montserrat(),
                          ),
                          Text(
                            '  (${boisson.modele?.name})',
                            style: GoogleFonts.montserrat(color: Colors.blue),
                          ),
                        ],
                      ),
                      subtitle: Text(
                        Helpers.formatterEnCFA(boisson.prix.last),
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              BoissonDetailScreen(boisson: boisson),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
