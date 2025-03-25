import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/utils/helpers.dart';

class CasierDetailScreen extends StatelessWidget {
  final Casier casier;

  const CasierDetailScreen({super.key, required this.casier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          foregroundColor: Colors.white,
          title: Text('Casier #${casier.id}'),
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
            const Text(
              'Boisson dans le casier:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: ListTile(
                leading: Icon(Icons.local_bar, color: Colors.brown[600]),
                title: Text(casier.boissons[0].nom ?? 'Sans nom'),
                subtitle: Text(
                  Helpers.formatterEnCFA(casier.boissons[0].prix.last),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
