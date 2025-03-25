import 'package:flutter/material.dart';
import 'package:projet7/models/casier.dart';

class CasierDetailScreen extends StatelessWidget {
  final Casier casier;

  const CasierDetailScreen({super.key, required this.casier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Casier #${casier.id}'),
          backgroundColor: Colors.brown[800]),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('ID', '${casier.id}'),
            _buildInfoCard('Total Boissons', '${casier.boissonTotal}'),
            _buildInfoCard('Prix Total', '${casier.getPrixTotal()}€'),
            SizedBox(height: 16),
            Text('Boissons dans le casier:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: casier.boissons.length,
                itemBuilder: (context, index) {
                  var boisson = casier.boissons[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      leading: Icon(Icons.local_bar, color: Colors.brown[600]),
                      title: Text(boisson.nom ?? 'Sans nom'),
                      subtitle: Text('${boisson.prix.last}€'),
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
