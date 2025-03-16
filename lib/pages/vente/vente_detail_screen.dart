import 'package:flutter/material.dart';
import 'package:projet7/models/vente.dart';

class VenteDetailScreen extends StatelessWidget {
  final Vente vente;

  const VenteDetailScreen({super.key, required this.vente});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Vente #${vente.id}'),
          backgroundColor: Colors.brown[800]),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('Montant Total', '${vente.montantTotal}€'),
            _buildInfoCard('Date', '${vente.dateVente}'),
            SizedBox(height: 16),
            Text('Boissons vendues:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: vente.lignesVente.length,
                itemBuilder: (context, index) {
                  var ligne = vente.lignesVente[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.local_bar, color: Colors.brown[600]),
                      title: Text(ligne.boisson.nom ?? 'Sans nom'),
                      subtitle: Text('Montant: ${ligne.montant}€'),
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
