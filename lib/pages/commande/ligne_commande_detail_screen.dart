import 'package:flutter/material.dart';
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
        title: Text("Ligne de commande #${ligneCommande.id}"),
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
            Text(
              'Casier #${ligneCommande.casier.id}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (ligneCommande.casier.boissons.isNotEmpty)
              Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                child: ListTile(
                  leading: Icon(Icons.local_bar, color: Colors.brown[600]),
                  title:
                      Text(ligneCommande.casier.boissons[0].nom ?? 'Sans nom'),
                  subtitle: Text(
                    Helpers.formatterEnCFA(
                        ligneCommande.casier.boissons[0].prix.last),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BoissonDetailScreen(
                          boisson: ligneCommande.casier.boissons[0]),
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
