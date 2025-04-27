import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/utils/helpers.dart';

class RefrigerateurDetailScreen extends StatelessWidget {
  final Refrigerateur refrigerateur;

  const RefrigerateurDetailScreen({super.key, required this.refrigerateur});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          refrigerateur.nom,
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
                      Icons.kitchen,
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
                      BuildInfoCard(label: 'Nom', value: refrigerateur.nom),
                      if (refrigerateur.temperature != null)
                        BuildInfoCard(
                          label: 'Température',
                          value: '${refrigerateur.temperature}°C',
                        ),
                      BuildInfoCard(
                        label: 'Total Boissons',
                        value: '${refrigerateur.getBoissonTotal()}',
                      ),
                      BuildInfoCard(
                        label: 'Prix Total',
                        value: Helpers.formatterEnCFA(
                            refrigerateur.getPrixTotal()),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Boissons:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      refrigerateur.boissons?.isEmpty ?? true
                          ? Center(
                              child: Text(
                                'Aucune boisson dans ce réfrigérateur',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: refrigerateur.boissons?.length ?? 0,
                              itemBuilder: (context, index) {
                                var boisson = refrigerateur.boissons![index];
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.local_bar,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primaryContainer,
                                    ),
                                    title: Row(
                                      children: [
                                        Text(
                                          boisson.nom ?? 'Sans nom',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                        Text(
                                          ' (${boisson.modele?.name})',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                              ),
                                        ),
                                      ],
                                    ),
                                    subtitle: Text(
                                      Helpers.formatterEnCFA(boisson.prix.last),
                                      style:
                                          Theme.of(context).textTheme.bodySmall,
                                    ),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BoissonDetailScreen(
                                                boisson: boisson),
                                      ),
                                    ),
                                  ),
                                );
                              },
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
