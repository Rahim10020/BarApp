import 'package:flutter/material.dart';
import 'package:projet7/pages/refrigerateur/ajouter_boisson_refrigerateur_screen.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/refrigerateur.dart';

class RefrigerateurScreen extends StatefulWidget {
  const RefrigerateurScreen({super.key});

  @override
  State<RefrigerateurScreen> createState() => _RefrigerateurScreenState();
}

class _RefrigerateurScreenState extends State<RefrigerateurScreen> {
  final _nomController = TextEditingController();
  final _tempController = TextEditingController();

  void _ajouterRefrigerateur(BarProvider provider) async {
    if (_nomController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner le nom");
    } else if (_tempController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner la température");
    } else {
      var refrigerateur = Refrigerateur(
        id: await provider.generateUniqueId("Refrigerateur"),
        nom: _nomController.text,
        temperature: double.tryParse(_tempController.text),
      );
      provider.addRefrigerateur(refrigerateur);
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${refrigerateur.nom} ajouté avec succès!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
    }
  }

  void _modifierRefrigerateur(
      BarProvider provider, Refrigerateur refrigerateur) {
    if (_nomController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner le nom");
    } else if (_tempController.text.isEmpty) {
      _showErrorDialog(context, "Veuillez renseigner la température");
    } else {
      refrigerateur.nom = _nomController.text;
      refrigerateur.temperature = double.tryParse(_tempController.text);
      provider.updateRefrigerateur(refrigerateur);
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${refrigerateur.nom} modifié avec succès!',
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
    _tempController.clear();
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
                'Nouveau Réfrigérateur',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: Icon(
                Icons.kitchen,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _nomController,
                        decoration: InputDecoration(
                          labelText: 'Nom',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.tertiary,
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
                          fillColor: Theme.of(context).colorScheme.tertiary,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.kitchen),
                        label: const Text('Ajouter'),
                        onPressed: () => _ajouterRefrigerateur(provider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: provider.refrigerateurs.isEmpty
                ? Center(
                    child: Text(
                      'Aucun réfrigérateur disponible',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.inversePrimary,
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
                    itemCount: provider.refrigerateurs.length,
                    itemBuilder: (context, index) {
                      var refrigerateur = provider.refrigerateurs[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
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
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => RefrigerateurDetailScreen(
                                  refrigerateur: refrigerateur),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.kitchen,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  refrigerateur.nom,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  refrigerateur.temperature != null
                                      ? 'Temp: ${refrigerateur.temperature}°C'
                                      : 'N/A',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                ),
                                Text(
                                  '${refrigerateur.getBoissonTotal()} boissons',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.add_circle,
                                          color: Colors.green),
                                      onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              AjouterBoissonRefrigerateurScreen(
                                                  refrigerateur: refrigerateur),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () {
                                        _nomController.text = refrigerateur.nom;
                                        _tempController.text = refrigerateur
                                                .temperature
                                                ?.toString() ??
                                            '';
                                        showDialog(
                                          context: context,
                                          builder: (_) => AlertDialog(
                                            title: Text(
                                              'Modifier ${refrigerateur.nom}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            content: SingleChildScrollView(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  TextField(
                                                    controller: _nomController,
                                                    decoration: InputDecoration(
                                                      labelText: 'Nom',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiary,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 12),
                                                  TextField(
                                                    controller: _tempController,
                                                    decoration: InputDecoration(
                                                      labelText:
                                                          'Température (°C)',
                                                      border:
                                                          OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(8),
                                                      ),
                                                      filled: true,
                                                      fillColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .tertiary,
                                                    ),
                                                    keyboardType:
                                                        TextInputType.number,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  'Annuler',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  _modifierRefrigerateur(
                                                      provider, refrigerateur);
                                                  Navigator.pop(context);
                                                },
                                                child: Text(
                                                  'Modifier',
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
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              'Voulez-vous supprimer ${refrigerateur.nom} ?',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  'Annuler',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  provider.deleteRefrigerateur(
                                                      refrigerateur);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        '${refrigerateur.nom} supprimé avec succès!',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              color: Theme.of(
                                                                      context)
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
                                                  'Oui',
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
