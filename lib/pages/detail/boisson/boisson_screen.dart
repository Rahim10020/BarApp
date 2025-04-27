import 'package:flutter/material.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/pages/detail/boisson/modifier_boisson_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';

class BoissonScreen extends StatefulWidget {
  const BoissonScreen({super.key});

  @override
  State<BoissonScreen> createState() => _BoissonScreenState();
}

class _BoissonScreenState extends State<BoissonScreen> {
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();
  final _descriptionController = TextEditingController();
  Modele? _modele;

  void _ajouterBoisson(BarProvider provider) async {
    if (_nomController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner le nom");
    } else if (_prixController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner le prix");
    } else if (_modele == null) {
      _showErrorDialog(context, "Veuillez choisir le modèle");
    } else {
      var boisson = Boisson(
        id: await provider.generateUniqueId("Boisson"),
        nom: _nomController.text,
        prix: [double.parse(_prixController.text)],
        estFroid: false,
        modele: _modele,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
      );
      provider.addBoisson(boisson);
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${boisson.nom} ajouté avec succès!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
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

  void _resetForm() {
    _nomController.clear();
    _prixController.clear();
    _descriptionController.clear();
    setState(() {
      _modele = null;
    });
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
                'Ajouter une boisson',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: Icon(
                Icons.add_circle,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _nomController,
                              decoration: InputDecoration(
                                labelText: 'Nom',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _prixController,
                              decoration: InputDecoration(
                                labelText: 'Prix',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                filled: true,
                                fillColor:
                                    Theme.of(context).colorScheme.tertiary,
                              ),
                              keyboardType: TextInputType.number,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          labelText: 'Description',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.tertiary,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButton<Modele>(
                        hint: Text(
                          'Modèle',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        value: _modele,
                        items: Modele.values
                            .map(
                              (modele) => DropdownMenuItem(
                                value: modele,
                                child: Text(
                                  modele == Modele.petit ? 'Petit' : 'Grand',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => setState(() => _modele = value),
                        isExpanded: true,
                      ),
                      const SizedBox(height: 12),
                      Center(
                        child: ElevatedButton.icon(
                          icon: const Icon(Icons.add, size: 18),
                          label: const Text('Ajouter'),
                          onPressed: () => _ajouterBoisson(provider),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: provider.boissons.isEmpty
                ? Center(
                    child: Text(
                      'Aucune boisson disponible',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                    ),
                  )
                : ListView.builder(
                    itemCount: provider.boissons.length,
                    itemBuilder: (context, index) {
                      var boisson = provider.boissons[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.tertiary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(blurRadius: 6, color: Colors.black26),
                          ],
                        ),
                        child: ListTile(
                          leading: Icon(
                            boisson.estFroid ? Icons.ac_unit : Icons.local_bar,
                            color:
                                Theme.of(context).colorScheme.primaryContainer,
                          ),
                          title: Row(
                            children: [
                              Text(
                                boisson.nom ?? 'Sans nom',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                              ),
                              Text(
                                ' (${boisson.modele?.name})',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                              ),
                            ],
                          ),
                          subtitle: Text(
                            Helpers.formatterEnCFA(boisson.prix.last),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ModifierBoissonScreen(
                                        boisson: boisson,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text(
                                        "Voulez-vous supprimer ${boisson.nom} ?",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleMedium,
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            "Annuler",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            provider.deleteBoisson(boisson);
                                            Navigator.pop(context);
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  '${boisson.nom} supprimé avec succès!',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Theme.of(context)
                                                            .colorScheme
                                                            .inversePrimary,
                                                      ),
                                                ),
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer,
                                              ),
                                            );
                                          },
                                          child: Text(
                                            "Oui",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  BoissonDetailScreen(boisson: boisson),
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
