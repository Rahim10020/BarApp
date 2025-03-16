import 'package:flutter/material.dart';
import 'package:projet7/models/commande.dart';

class CommandeDetailScreen extends StatelessWidget {
  final Commande commande;

  const CommandeDetailScreen({super.key, required this.commande});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Commande #${commande.id}'),
          backgroundColor: Colors.brown[800]),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('ID', '${commande.id}'),
            _buildInfoCard('Montant Total', '${commande.montantTotal}€'),
            _buildInfoCard('Date', '${commande.dateCommande}'),
            _buildInfoCard('Bar', commande.barInstance.nom),
            SizedBox(height: 16),
            Text('Lignes de commande:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: commande.lignesCommande.length,
                itemBuilder: (context, index) {
                  var ligne = commande.lignesCommande[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.storage, color: Colors.brown[600]),
                      title: Text('Casier #${ligne.casier.id}'),
                      subtitle: Text(
                          'Montant: ${ligne.montant}€ - Boissons: ${ligne.casier.boissonTotal}'),
                      trailing:
                          Text('Fournisseur: ${ligne.casier.fournisseur.nom}'),
                    ),
                  );
                },
              ),
            ),
            ElevatedButton.icon(
              icon: Icon(Icons.download),
              label: Text('Télécharger (bientôt)'),
              onPressed: () {}, // Placeholder pour future implémentation
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label),
              Text(value, style: TextStyle(fontWeight: FontWeight.bold))
            ]),
      ),
    );
  }
}
