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

  void _ajouterRefrigerateur(BarProvider provider) {
    if (_nomController.text.isEmpty || _nomController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Veuillez renseigner le nom"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else if (_tempController.text.isEmpty || _tempController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Veuillez renseigner la température"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else {
      var refrigerateur = Refrigerateur(
        id: provider.generateUniqueId(),
        nom: _nomController.text,
        temperature: double.tryParse(_tempController.text),
      );
      provider.addRefrigerateur(refrigerateur);
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${refrigerateur.nom} ajouté avec succès!'),
        ),
      );
    }
  }

  void _modifierRefrigerateur(
      BarProvider provider, Refrigerateur refrigerateur) {
    if (_nomController.text.isEmpty || _nomController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Veuillez renseigner le nom"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else if (_tempController.text.isEmpty || _tempController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Veuillez renseigner la température"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else {
      refrigerateur.nom = _nomController.text;
      refrigerateur.temperature = double.tryParse(_tempController.text);
      provider.updateRefrigerateur(refrigerateur);
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${refrigerateur.nom} modifié avec succès!'),
        ),
      );
    }
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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text(
                    'Nouveau Réfrigérateur',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _nomController,
                    decoration: const InputDecoration(
                      labelText: 'Nom',
                    ),
                  ),
                  TextField(
                      controller: _tempController,
                      decoration:
                          const InputDecoration(labelText: 'Température (°C)'),
                      keyboardType: TextInputType.number),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.kitchen,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Ajouter',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[600]),
                    onPressed: () => _ajouterRefrigerateur(provider),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.refrigerateurs.length,
              itemBuilder: (context, index) {
                var refrigerateur = provider.refrigerateurs[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(blurRadius: 4, color: Colors.black12)
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.kitchen, color: Colors.brown[600]),
                    title: Text(refrigerateur.nom),
                    subtitle: refrigerateur.temperature != null
                        ? Text(
                            'Temp : ${refrigerateur.temperature}°C - ${refrigerateur.getBoissonTotal()} boissons')
                        : Text('${refrigerateur.getBoissonTotal()} boissons'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon:
                              const Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AjouterBoissonRefrigerateurScreen(
                                refrigerateur: refrigerateur,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _nomController.text = refrigerateur.nom;
                            _tempController.text =
                                refrigerateur.temperature?.toString() ?? '';
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Modifier ${refrigerateur.nom}'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                          controller: _nomController,
                                          decoration: const InputDecoration(
                                              labelText: 'Nom')),
                                      TextField(
                                          controller: _tempController,
                                          decoration: const InputDecoration(
                                              labelText: 'Température (°C)'),
                                          keyboardType: TextInputType.number),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _resetForm();
                                      },
                                      child: const Text('Annuler')),
                                  TextButton(
                                      onPressed: () {
                                        _modifierRefrigerateur(
                                            provider, refrigerateur);
                                        Navigator.pop(context);
                                      },
                                      child: const Text('Modifier')),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                    "Voulez-vous supprimer ${refrigerateur.nom} ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Annuler"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      provider
                                          .deleteRefrigerateur(refrigerateur);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${refrigerateur.nom} supprimé avec succès!',
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text("Oui"),
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
                            builder: (_) => RefrigerateurDetailScreen(
                                refrigerateur: refrigerateur))),
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
