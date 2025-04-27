import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/utils/helpers.dart';

class CasierDetailScreen extends StatelessWidget {
  final Casier casier;

  const CasierDetailScreen({super.key, required this.casier});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Casier #${casier.id}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            elevation: 6,
            child: Column(
              children: [
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.tertiary,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.storage,
                      size: 80,
                      color: Theme.of(context).colorScheme.primaryContainer,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildInfoCard(label: 'ID', value: '${casier.id}'),
                      BuildInfoCard(
                          label: 'Total Boissons',
                          value: '${casier.boissonTotal}'),
                      BuildInfoCard(
                          label: 'Prix Total',
                          value: Helpers.formatterEnCFA(casier.getPrixTotal())),
                      const SizedBox(height: 16),
                      Text(
                        'Boisson dans le casier:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      if (casier.boissons.isNotEmpty)
                        Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              Icons.local_bar,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                            ),
                            title: Text(
                              '${casier.boissons[0].nom} (${casier.boissons[0].modele?.name})',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              Helpers.formatterEnCFA(
                                  casier.boissons[0].prix.last),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BoissonDetailScreen(
                                    boisson: casier.boissons[0]),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
