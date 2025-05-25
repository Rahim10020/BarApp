import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

class CasierDetailScreen extends StatefulWidget {
  final Casier casier;

  const CasierDetailScreen({super.key, required this.casier});

  @override
  State<CasierDetailScreen> createState() => _CasierDetailScreenState();
}

class _CasierDetailScreenState extends State<CasierDetailScreen> {
  final _quantiteController = TextEditingController();
  Boisson? _boissonSelectionnee;

  @override
  void initState() {
    super.initState();
    _quantiteController.text = widget.casier.boissonTotal.toString();
    final provider = Provider.of<BarProvider>(context, listen: false);
    if (widget.casier.boissons.isNotEmpty) {
      final casierBoisson = widget.casier.boissons.first;
      _boissonSelectionnee = provider.boissons.firstWhereOrNull(
        (boisson) =>
            boisson.nom == casierBoisson.nom &&
            boisson.modele == casierBoisson.modele &&
            boisson.prix.last == casierBoisson.prix.last,
      );
      if (_boissonSelectionnee == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _showWarningDialog(context,
              "La boisson '${casierBoisson.nom}' n'est plus disponible. Veuillez sélectionner une autre boisson.");
        });
      }
    } else {
      _boissonSelectionnee = null;
    }
  }

  void _modifierCasier(BarProvider provider) async {
    if (_boissonSelectionnee == null) {
      _showErrorDialog(context, "Veuillez sélectionner une boisson");
    } else if (_quantiteController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez préciser la quantité");
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
            nom: _boissonSelectionnee!.nom,
            prix: List.from(_boissonSelectionnee!.prix),
            estFroid: _boissonSelectionnee!.estFroid,
            modele: _boissonSelectionnee!.modele,
            description: _boissonSelectionnee!.description,
          ));
        }
        final casierModifie = Casier(
          id: widget.casier.id,
          boissonTotal: quantite,
          boissons: boissons,
        );
        // final casierIndex =
        //     provider.casiers.indexWhere((c) => c.id == widget.casier.id);
        // if (casierIndex != -1) {
        //   await provider.updateCasier(casierModifie, casierIndex);
        // } else {
        //   await provider.addCasier(casierModifie);
        // }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Casier modifié avec succès !',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        _showErrorDialog(context, "Erreur : $e");
      }
    }
  }

  void _supprimerCasier(BarProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Supprimer le casier',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer le casier #${widget.casier.id} ?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Annuler',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          TextButton(
            onPressed: () async {
              // await provider.deleteCasier(widget.casier);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Casier supprimé avec succès !',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
              );
            },
            child: Text(
              'Supprimer',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                  ),
            ),
          ),
        ],
      ),
    );
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
              'OK',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }

  void _showWarningDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Avertissement',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          message,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'OK',
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
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimaryContainer,
        title: Text(
          'Casier #${widget.casier.id}',
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
                      BuildInfoCard(
                        label: 'Numéro',
                        value: '${widget.casier.id}',
                      ),
                      BuildInfoCard(
                        label: 'Total Boissons',
                        value: '${widget.casier.boissonTotal}',
                      ),
                      BuildInfoCard(
                        label: 'Prix Total',
                        value: Helpers.formatterEnCFA(
                            widget.casier.getPrixTotal()),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Boisson dans le casier :',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      if (widget.casier.boissons.isNotEmpty)
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
                              '${widget.casier.boissons[0].nom} (${widget.casier.boissons[0].modele?.name})',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            subtitle: Text(
                              Helpers.formatterEnCFA(
                                  widget.casier.boissons[0].prix.last),
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BoissonDetailScreen(
                                    boisson: widget.casier.boissons[0]),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 16),
                      Text(
                        'Modifier le casier',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      DropdownButtonFormField<Boisson>(
                        value: _boissonSelectionnee,
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
                                      '${boisson.nom} (${boisson.modele?.name ?? "N/A"})'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _boissonSelectionnee = value;
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            icon: Icon(
                              Icons.edit,
                              color: Theme.of(context)
                                  .colorScheme
                                  .onPrimaryContainer,
                            ),
                            label: Text(
                              'Modifier',
                              style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onPrimaryContainer,
                              ),
                            ),
                            onPressed: () => _modifierCasier(provider),
                          ),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.delete),
                            label: const Text('Supprimer'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  Theme.of(context).colorScheme.errorContainer,
                              foregroundColor: Theme.of(context)
                                  .colorScheme
                                  .onErrorContainer,
                            ),
                            onPressed: () => _supprimerCasier(provider),
                          ),
                        ],
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

  @override
  void dispose() {
    _quantiteController.dispose();
    super.dispose();
  }
}
