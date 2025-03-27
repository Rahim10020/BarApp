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

  void _ajouterBoisson(BarProvider provider) {
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
    } else if (_prixController.text.isEmpty || _prixController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Veuillez renseigner le prix"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else if (_modele == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Veuillez choisir le modèle"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else {
      var boisson = Boisson(
        id: provider.generateUniqueId(),
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
          content: Text('${boisson.nom} ajouté avec succès!'),
        ),
      );
    }
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
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ajouter une boisson',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                              controller: _nomController,
                              decoration: const InputDecoration(
                                  labelText: 'Nom',
                                  contentPadding: EdgeInsets.all(8)))),
                      const SizedBox(width: 8),
                      Expanded(
                          child: TextField(
                              controller: _prixController,
                              decoration: const InputDecoration(
                                  labelText: 'Prix',
                                  contentPadding: EdgeInsets.all(8)),
                              keyboardType: TextInputType.number)),
                    ],
                  ),
                  TextField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                          labelText: 'Description',
                          contentPadding: EdgeInsets.all(8))),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButton<Modele>(
                          hint: const Text('Modèle'),
                          value: _modele,
                          items: Modele.values
                              .map(
                                (modele) => DropdownMenuItem(
                                  value: modele,
                                  child: Text(
                                    modele == Modele.petit ? 'Petit' : 'Grand',
                                  ),
                                ),
                              )
                              .toList(),
                          onChanged: (value) => setState(() => _modele = value),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Center(
                    child: ElevatedButton.icon(
                      icon: const Icon(
                        Icons.add,
                        size: 18,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Ajouter',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[600],
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8)),
                      onPressed: () => _ajouterBoisson(provider),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.boissons.length,
              itemBuilder: (context, index) {
                var boisson = provider.boissons[index];
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
                    leading: Icon(
                        boisson.estFroid ? Icons.ac_unit : Icons.local_bar,
                        color: Colors.brown[600]),
                    title: Text(boisson.nom ?? 'Sans nom'),
                    subtitle: Text(Helpers.formatterEnCFA(boisson.prix.last)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModifierBoissonScreen(
                                  boisson: boisson,
                                ),
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
                                    "Voulez-vous supprimer ${boisson.nom} ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Annuler"),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        provider.deleteBoisson(boisson);
                                        Navigator.pop(context);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                '${boisson.nom} supprimé avec succès!'),
                                          ),
                                        );
                                      },
                                      child: const Text("Oui"))
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
                                BoissonDetailScreen(boisson: boisson))),
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
