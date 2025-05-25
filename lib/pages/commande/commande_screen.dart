import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/models/ligne_commande.dart';
import 'package:projet7/pages/commande/commande_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

class CommandeScreen extends StatefulWidget {
  const CommandeScreen({super.key});

  @override
  State<CommandeScreen> createState() => _CommandeScreenState();
}

class _CommandeScreenState extends State<CommandeScreen> {
  Boisson? boissonSelectionnee;
  Fournisseur? fournisseurSelectionne;
  final _quantiteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BarProvider>(context, listen: false);
    if (provider.boissons.isNotEmpty) {
      boissonSelectionnee = provider.boissons[0];
    }
    if (provider.fournisseurs.isNotEmpty) {
      fournisseurSelectionne = provider.fournisseurs[0];
    }
  }

  void _ajouterCommande(BarProvider provider) async {
    if (_quantiteController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez préciser la quantité commandée");
    } else if (boissonSelectionnee == null) {
      _showErrorDialog(context, "Veuillez sélectionner une boisson");
    } else if (provider.currentBar == null) {
      _showErrorDialog(context, "Aucun bar sélectionné");
    } else {
      try {
        final quantite = int.parse(_quantiteController.text);
        if (quantite <= 0) {
          throw Exception("La quantité doit être positive");
        }
        final boissons = <Boisson>[];
        for (int i = 0; i < quantite; i++) {
          final id = await provider.generateUniqueId("Boisson");
          boissons.add(Boisson(
            id: id,
            nom: boissonSelectionnee!.nom,
            prix: List.from(boissonSelectionnee!.prix),
            estFroid: boissonSelectionnee!.estFroid,
            modele: boissonSelectionnee!.modele,
            description: boissonSelectionnee!.description,
          ));
        }
        final casier = Casier(
          id: await provider.generateUniqueId("Casier"),
          boissonTotal: quantite,
          boissons: boissons,
        );
        final ligneCommande = LigneCommande(
          id: await provider.generateUniqueId("LigneCommande"),
          montant: casier.getPrixTotal(),
          casier: casier,
        );
        final commande = Commande(
          id: await provider.generateUniqueId("Commande"),
          montantTotal: ligneCommande.montant,
          dateCommande: DateTime.now(),
          lignesCommande: [ligneCommande],
          barInstance: provider.currentBar!,
          fournisseur: fournisseurSelectionne,
        );
        await provider.addCommande(commande);
        _quantiteController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Commande ajoutée avec succès!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
      } catch (e) {
        _showErrorDialog(context, e.toString());
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          message,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              "OK",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 6,
            child: ExpansionTile(
              title: Text(
                'Nouvelle Commande',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: Icon(
                Icons.receipt,
                color: Theme.of(context).colorScheme.primary,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Sélection de la boisson
                      DropdownButtonFormField<Boisson>(
                        value: boissonSelectionnee,
                        decoration: InputDecoration(
                          labelText: 'Boisson',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        items: provider.boissons
                            .map((boisson) => DropdownMenuItem<Boisson>(
                                  value: boisson,
                                  child: Text(
                                      '${boisson.nom} (${boisson.modele?.name ?? "Sans modèle"})'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            boissonSelectionnee = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      // Sélection du fournisseur
                      DropdownButtonFormField<Fournisseur>(
                        value: fournisseurSelectionne,
                        decoration: InputDecoration(
                          labelText: 'Fournisseur',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        items: provider.fournisseurs
                            .map((fournisseur) => DropdownMenuItem<Fournisseur>(
                                  value: fournisseur,
                                  child: Text(fournisseur.nom),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            fournisseurSelectionne = value;
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _quantiteController,
                        decoration: InputDecoration(
                          labelText: 'Quantité',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: Icon(
                          Icons.receipt,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        label: Text(
                          'Ajouter',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                        onPressed: () => _ajouterCommande(provider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: provider.commandes.isEmpty
                ? Center(
                    child: Text(
                      'Aucune commande disponible',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: provider.commandes.length,
                    itemBuilder: (context, index) {
                      var commande = provider.commandes[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              color: Colors.black26,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CommandeDetailScreen(commande: commande),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.receipt,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Commande #${commande.id}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                      ),
                                ),
                                Text(
                                  'Total: ${Helpers.formatterEnCFA(commande.montantTotal)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
