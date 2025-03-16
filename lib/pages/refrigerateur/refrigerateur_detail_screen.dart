import 'package:flutter/material.dart';
import 'package:projet7/models/refrigerateur.dart';

class RefrigerateurDetailScreen extends StatelessWidget {
  final Refrigerateur refrigerateur;

  const RefrigerateurDetailScreen({super.key, required this.refrigerateur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(refrigerateur.nom), backgroundColor: Colors.brown[800]),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('ID', '${refrigerateur.id}'),
            _buildInfoCard('Nom', refrigerateur.nom),
            _buildInfoCard('Température', '${refrigerateur.temperature}°C'),
            _buildInfoCard(
                'Total Boissons', '${refrigerateur.getBoissonTotal()}'),
            _buildInfoCard('Prix Total', '${refrigerateur.getPrixTotal()}€'),
            SizedBox(height: 16),
            Text('Boissons:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Expanded(
              child: ListView.builder(
                itemCount: refrigerateur.boissons?.length ?? 0,
                itemBuilder: (context, index) {
                  var boisson = refrigerateur.boissons![index];
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
