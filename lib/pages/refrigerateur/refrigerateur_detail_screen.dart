import 'package:flutter/material.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_sans_modif_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

class RefrigerateurDetailScreen extends StatefulWidget {
  final Refrigerateur refrigerateur;

  const RefrigerateurDetailScreen({super.key, required this.refrigerateur});

  @override
  State<RefrigerateurDetailScreen> createState() =>
      _RefrigerateurDetailScreenState();
}

class _RefrigerateurDetailScreenState extends State<RefrigerateurDetailScreen> {
  final _nomController = TextEditingController();
  final _tempController = TextEditingController();
  final _quantiteController = TextEditingController();
  Commande? _selectedCommande;
  Boisson? _selectedBoisson;

  @override
  void initState() {
    super.initState();
    _nomController.text = widget.refrigerateur.nom;
    _tempController.text = widget.refrigerateur.temperature?.toString() ?? '';
  }

  void _showModifyDialog(BuildContext context, BarProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Modifier le réfrigérateur',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nomController,
              decoration: InputDecoration(
                labelText: 'Nom',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _tempController,
              decoration: InputDecoration(
                labelText: 'Température (°C)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                filled: true,
                fillColor: Theme.of(context).colorScheme.surfaceVariant,
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              if (_nomController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Veuillez renseigner le nom',
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
                return;
              }
              if (_tempController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Veuillez renseigner la température',
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
                return;
              }
              widget.refrigerateur.nom = _nomController.text;
              widget.refrigerateur.temperature =
                  double.tryParse(_tempController.text);
              await provider.updateRefrigerateur(widget.refrigerateur);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Réfrigérateur modifié avec succès',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                ),
              );
              setState(() {});
            },
            child: Text('Modifier'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, BarProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Supprimer le réfrigérateur',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: Text(
            'Voulez-vous vraiment supprimer ${widget.refrigerateur.nom} ?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () async {
              await provider.deleteRefrigerateur(widget.refrigerateur);
              Navigator.pop(context);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Réfrigérateur supprimé avec succès',
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
            child: Text('Supprimer'),
          ),
        ],
      ),
    );
  }

  void _ajouterBoissons(BuildContext context, BarProvider provider) async {
    if (_selectedCommande == null || _quantiteController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Veuillez sélectionner une commande et une quantité',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
      return;
    }
    int quantite = int.tryParse(_quantiteController.text) ?? 0;
    if (quantite <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Veuillez entrer une quantité valide',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
      return;
    }
    try {
      await provider.ajouterBoissonsAuRefrigerateur(
        _selectedCommande!.id,
        widget.refrigerateur.id,
        quantite,
      );
      _quantiteController.clear();
      _selectedCommande = null;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Boissons ajoutées avec succès',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
    }
  }

  void _retirerBoisson(
      BuildContext context, BarProvider provider, Boisson boisson) async {
    Commande? selectedCommande;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sélectionner une commande',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        content: DropdownButtonFormField<Commande>(
          value: selectedCommande,
          decoration: InputDecoration(
            labelText: 'Commande',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceVariant,
          ),
          items: provider.commandes
              .map((commande) => DropdownMenuItem<Commande>(
                    value: commande,
                    child: Text('Commande #${commande.id}'),
                  ))
              .toList(),
          onChanged: (value) {
            selectedCommande = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              if (selectedCommande == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Veuillez sélectionner une commande',
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
                return;
              }
              Navigator.pop(context);
            },
            child: Text('Confirmer'),
          ),
        ],
      ),
    );

    if (selectedCommande == null) return;

    try {
      await provider.retirerBoissonsDuRefrigerateur(
        selectedCommande!.id,
        widget.refrigerateur.id,
        boisson,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Boisson retirée avec succès',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
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
          widget.refrigerateur.nom,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () => _showModifyDialog(context, provider),
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () => _showDeleteDialog(context, provider),
          ),
        ],
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
                      BuildInfoCard(
                          label: 'Nom', value: widget.refrigerateur.nom),
                      if (widget.refrigerateur.temperature != null)
                        BuildInfoCard(
                          label: 'Température',
                          value: '${widget.refrigerateur.temperature}°C',
                        ),
                      BuildInfoCard(
                        label: 'Total Boissons',
                        value: '${widget.refrigerateur.getBoissonTotal()}',
                      ),
                      BuildInfoCard(
                        label: 'Prix Total',
                        value: Helpers.formatterEnCFA(
                            widget.refrigerateur.getPrixTotal()),
                      ),
                      const SizedBox(height: 16),
                      ExpansionTile(
                        title: Text(
                          'Ajouter des boissons',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        leading: Icon(
                          Icons.add,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Column(
                              children: [
                                DropdownButtonFormField<Commande>(
                                  value: _selectedCommande,
                                  decoration: InputDecoration(
                                    labelText: 'Commande',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                  ),
                                  items: provider.commandes
                                      .where((commande) =>
                                          commande.lignesCommande.any((ligne) =>
                                              ligne.casier.boissons.isNotEmpty))
                                      .map((commande) =>
                                          DropdownMenuItem<Commande>(
                                            value: commande,
                                            child: Text(
                                                'Commande #${commande.id} (${commande.lignesCommande.first.casier.boissons.first.nom ?? 'Sans nom'})'),
                                          ))
                                      .toList(),
                                  onChanged: (value) {
                                    setState(() {
                                      _selectedCommande = value;
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
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                  ),
                                  keyboardType: TextInputType.number,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  icon: Icon(
                                    Icons.add,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onPrimaryContainer,
                                  ),
                                  label: Text(
                                    'Ajouter',
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onPrimaryContainer,
                                    ),
                                  ),
                                  onPressed: () =>
                                      _ajouterBoissons(context, provider),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Boissons:',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 10),
                      widget.refrigerateur.boissons?.isEmpty ?? true
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
                              itemCount:
                                  widget.refrigerateur.boissons?.length ?? 0,
                              itemBuilder: (context, index) {
                                var boisson =
                                    widget.refrigerateur.boissons![index];
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
                                              .bodyMedium!
                                              .copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                        Text(
                                          ' (${boisson.getModele() ?? 'Inconnu'})',
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
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.remove_circle,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                      onPressed: () => _retirerBoisson(
                                          context, provider, boisson),
                                    ),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            BoissonDetailSansModifScreen(
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

  @override
  void dispose() {
    _nomController.dispose();
    _tempController.dispose();
    _quantiteController.dispose();
    super.dispose();
  }
}
