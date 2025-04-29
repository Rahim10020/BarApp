import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/pages/detail/casier/casier_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class CasierScreen extends StatefulWidget {
  const CasierScreen({super.key});

  @override
  State<CasierScreen> createState() => _CasierScreenState();
}

class _CasierScreenState extends State<CasierScreen> {
  final _nomController = TextEditingController();
  Boisson? _boissonSelectionnee;

  void _ajouterCasier(BarProvider provider) async {
    if (_boissonSelectionnee == null) {
      _showErrorDialog(context, "Veuillez sélectionner une boisson");
    } else {
      try {
        var casier = Casier(
          id: await provider.generateUniqueId("Casier"),
          boissonTotal: 1,
          boissons: [_boissonSelectionnee!],
        );
        await provider.addCasier(casier);
        _nomController.clear();
        setState(() {
          _boissonSelectionnee = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Casier ajouté avec succès!',
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
                'Nouveau Casier',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: Icon(
                Icons.storage,
                color: Theme.of(context).colorScheme.primary,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
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
                                  child: Text(boisson.nom ?? 'Sans nom'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _boissonSelectionnee = value;
                          });
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.storage),
                        label: const Text('Ajouter'),
                        onPressed: () => _ajouterCasier(provider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: provider.casiers.isEmpty
                ? Center(
                    child: Text(
                      'Aucun casier disponible',
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
                    itemCount: provider.casiers.length,
                    itemBuilder: (context, index) {
                      var casier = provider.casiers[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primaryContainer,
                              Theme.of(context).colorScheme.surfaceVariant,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(blurRadius: 6, color: Colors.black26),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CasierDetailScreen(casier: casier),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.storage,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Casier #${casier.id}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
                                ),
                                Text(
                                  casier.boissons.isNotEmpty
                                      ? casier.boissons.first.nom ?? 'Sans nom'
                                      : 'Vide',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                  textAlign: TextAlign.center,
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
