import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/utils/helpers.dart';

class VenteDetailScreen extends StatelessWidget {
  final Vente vente;

  const VenteDetailScreen({super.key, required this.vente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text('Vente #${vente.id}'),
        backgroundColor: Colors.brown[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildInfoCard(
                label: 'Montant Total',
                value: Helpers.formatterEnCFA(vente.montantTotal)),
            BuildInfoCard(
                label: 'Date', value: Helpers.formatterDate(vente.dateVente)),
            const SizedBox(height: 16),
            const Text('Boissons vendues:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: vente.lignesVente.length,
                itemBuilder: (context, index) {
                  var ligne = vente.lignesVente[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.local_bar, color: Colors.brown[600]),
                      title: Text(ligne.boisson.nom ?? 'Sans nom'),
                      subtitle: Text(
                          'Montant: ${Helpers.formatterEnCFA(ligne.montant)}'),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              icon: const Icon(Icons.download),
              label: const Text('Télécharger'),
              onPressed: () {}, // Placeholder pour future implémentation
            ),
          ],
        ),
      ),
    );
  }
}
