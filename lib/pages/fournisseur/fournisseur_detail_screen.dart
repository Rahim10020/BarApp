import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class FournisseurDetailScreen extends StatefulWidget {
  final Fournisseur fournisseur;

  const FournisseurDetailScreen({super.key, required this.fournisseur});

  @override
  State<FournisseurDetailScreen> createState() =>
      _FournisseurDetailScreenState();
}

class _FournisseurDetailScreenState extends State<FournisseurDetailScreen> {
  final _nomController = TextEditingController();
  final _adresseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nomController.text = widget.fournisseur.nom;
    _adresseController.text = widget.fournisseur.adresse ?? '';
  }

  void _modifierFournisseur(BarProvider provider) async {
    if (_nomController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner le nom du fournisseur");
    } else {
      try {
        var fournisseurModifie = Fournisseur(
          id: widget.fournisseur.id,
          nom: _nomController.text,
          adresse:
              _adresseController.text.isEmpty ? null : _adresseController.text,
        );
        await provider.addFournisseur(
            fournisseurModifie); // Hive remplace l'entrée existante
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Fournisseur modifié avec succès!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
        Navigator.pop(context);
      } catch (e) {
        _showErrorDialog(context, e.toString());
      }
    }
  }

  void _supprimerFournisseur(BarProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Supprimer le fournisseur',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
          'Êtes-vous sûr de vouloir supprimer ${widget.fournisseur.nom} ?',
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
              await provider.deleteFournisseur(widget.fournisseur);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Fournisseur supprimé avec succès!',
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.fournisseur.nom,
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
                      Icons.store,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BuildInfoCard(
                        label: 'ID',
                        value: '${widget.fournisseur.id}',
                      ),
                      BuildInfoCard(
                        label: 'Nom',
                        value: widget.fournisseur.nom,
                      ),
                      BuildInfoCard(
                        label: 'Adresse',
                        value: widget.fournisseur.adresse ?? 'Non spécifiée',
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Modifier le fournisseur',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          labelText: 'Nom',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _adresseController,
                        decoration: InputDecoration(
                          labelText: 'Adresse (facultatif)',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('Modifier'),
                            onPressed: () => _modifierFournisseur(provider),
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
                            onPressed: () => _supprimerFournisseur(provider),
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
}
