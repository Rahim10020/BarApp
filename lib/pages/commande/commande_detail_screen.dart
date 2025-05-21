import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/pages/detail/casier/casier_detail_screen.dart';
import 'package:projet7/utils/helpers.dart';

class CommandeDetailScreen extends StatelessWidget {
  final Commande commande;

  const CommandeDetailScreen({super.key, required this.commande});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Commande #${commande.id}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
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
                    color: Theme.of(context).colorScheme.surfaceVariant,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.receipt,
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
                      BuildInfoCard(
                        label: 'Numéro',
                        value: '${commande.id}',
                      ),
                      BuildInfoCard(
                        label: 'Bar',
                        value: commande.barInstance.nom,
                      ),
                      BuildInfoCard(
                        label: 'Prix Total',
                        value: Helpers.formatterEnCFA(commande.montantTotal),
                      ),
                      BuildInfoCard(
                        label: 'Date',
                        value: Helpers.formatterDate(commande.dateCommande),
                      ),
                      BuildInfoCard(
                        label: 'Fournisseur',
                        value: commande.fournisseur?.nom ?? 'Inconnu',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Casiers commandés:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      commande.lignesCommande.isEmpty
                          ? Center(
                              child: Text(
                                'Aucun casier dans cette commande',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurface,
                                    ),
                              ),
                            )
                          : ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: commande.lignesCommande.length,
                              itemBuilder: (context, index) {
                                var ligne = commande.lignesCommande[index];
                                return Card(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 4),
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.storage,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                    title: Text(
                                      'Casier #${ligne.casier.id}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                    subtitle: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          ligne.casier.boissons.isNotEmpty
                                              ? '${ligne.casier.boissons.first.nom} (${ligne.casier.boissons.first.modele?.name})'
                                              : 'Aucune boisson',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          'Quantité: ${ligne.casier.boissonTotal}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        Text(
                                          'Montant: ${Helpers.formatterEnCFA(ligne.montant)}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CasierDetailScreen(
                                                casier: ligne.casier),
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
