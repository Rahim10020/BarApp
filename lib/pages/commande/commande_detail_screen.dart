import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/utils/helpers.dart';

class CommandeDetailScreen extends StatelessWidget {
  final Commande commande;

  const CommandeDetailScreen({super.key, required this.commande});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Commande #${commande.id}'),
          backgroundColor: Colors.brown[800]),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildInfoCard(label: 'ID', value: '${commande.id}'),
            BuildInfoCard(
                label: 'Montant Total',
                value: Helpers.formatterEnCFA(commande.montantTotal)),
            BuildInfoCard(label: 'Date', value: '${commande.dateCommande}'),
            BuildInfoCard(label: 'Bar', value: commande.barInstance.nom),
            BuildInfoCard(
                label: 'Fournisseur', value: commande.fournisseur.nom),
            const SizedBox(height: 16),
            const Text(
              'Lignes de commande:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: commande.lignesCommande.length,
                itemBuilder: (context, index) {
                  var ligne = commande.lignesCommande[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.storage, color: Colors.brown[600]),
                      title: Text(
                        'Casier #${ligne.casier.id}',
                      ),
                      subtitle: Text(
                        'Montant: ${Helpers.formatterEnCFA(ligne.montant)} - Boissons: ${ligne.casier.boissonTotal}',
                      ),
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
