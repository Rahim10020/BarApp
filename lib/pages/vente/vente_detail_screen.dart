import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_sans_modif_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

class VenteDetailScreen extends StatelessWidget {
  final Vente vente;

  const VenteDetailScreen({super.key, required this.vente});

  void _showDeleteDialog(BuildContext context, BarProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Supprimer la vente',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text('Voulez-vous vraiment supprimer la vente #${vente.id} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              try {
                await provider.deleteVente(vente);
                Navigator.pop(context);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Vente supprimée avec succès',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                    ),
                    backgroundColor:
                        Theme.of(context).colorScheme.primaryContainer,
                  ),
                );
              } catch (e) {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text(
                      'Erreur',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    content: Text('Erreur lors de la suppression : $e'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              }
            },
            child: const Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _downloadPdf(BuildContext context, BarProvider provider) async {
    try {
      final filePath = await provider.generateVentePdf(vente);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'PDF sauvegardé dans Téléchargements',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erreur lors de la génération du PDF : $e',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onError,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text(
          'Vente #${vente.id}',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _downloadPdf(context, provider),
            tooltip: 'Télécharger PDF',
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, provider),
            tooltip: 'Supprimer la vente',
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                    Icons.local_drink,
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
                      label: "Date",
                      value: Helpers.formatterDate(vente.dateVente),
                    ),
                    BuildInfoCard(
                      label: "Montant total",
                      value: Helpers.formatterEnCFA(vente.montantTotal),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Articles vendus:',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: vente.lignesVente.length,
                      itemBuilder: (context, index) {
                        var ligne = vente.lignesVente[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: Icon(
                              Icons.local_drink,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            title: Text(
                              ligne.boisson.nom ?? 'Sans nom',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Modèle: ${ligne.boisson.modele?.name ?? "Sans modèle"}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  'Quantité: 1',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                Text(
                                  'Montant: ${Helpers.formatterEnCFA(ligne.montant)}',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BoissonDetailSansModifScreen(
                                        boisson: ligne.boisson),
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
    );
  }
}
