import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';

class BoissonDetailScreen extends StatelessWidget {
  final Boisson boisson;

  const BoissonDetailScreen({super.key, required this.boisson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(boisson.nom ?? 'Boisson'),
          backgroundColor: Colors.brown[800]),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoCard('ID', '${boisson.id}'),
            _buildInfoCard('Nom', boisson.nom ?? 'N/A'),
            _buildInfoCard('Prix', '${boisson.prix.last}€'),
            _buildInfoCard('Froide', boisson.estFroid ? 'Oui' : 'Non'),
            _buildInfoCard('Modèle', boisson.getModele() ?? 'N/A'),
            _buildInfoCard('Description', boisson.description ?? 'Aucune'),
            _buildInfoCard('Image', boisson.imagePath),
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
