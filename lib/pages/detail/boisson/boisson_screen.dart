import 'package:flutter/material.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';

class BoissonScreen extends StatefulWidget {
  const BoissonScreen({super.key});

  @override
  _BoissonScreenState createState() => _BoissonScreenState();
}

class _BoissonScreenState extends State<BoissonScreen> {
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();
  final _descriptionController = TextEditingController();
  bool _estFroid = false;
  Modele? _modele;

  void _ajouterBoisson(BarProvider provider) {
    var boisson = Boisson(
      id: provider.generateUniqueId(),
      nom: _nomController.text,
      prix: [double.parse(_prixController.text)],
      imagePath: 'assets/boisson.png',
      estFroid: _estFroid,
      modele: _modele,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
    );
    provider.addBoisson(boisson);
    _nomController.clear();
    _prixController.clear();
    _descriptionController.clear();
    setState(() {
      _estFroid = false;
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
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  Text('Ajouter une boisson',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _nomController,
                      decoration: InputDecoration(labelText: 'Nom')),
                  TextField(
                      controller: _prixController,
                      decoration: InputDecoration(labelText: 'Prix'),
                      keyboardType: TextInputType.number),
                  TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description')),
                  SwitchListTile(
                      title: Text('Froide ?'),
                      value: _estFroid,
                      onChanged: (value) => setState(() => _estFroid = value)),
                  DropdownButton<Modele>(
                    hint: Text('Choisir un modèle'),
                    value: _modele,
                    items: Modele.values
                        .map((modele) => DropdownMenuItem(
                            value: modele,
                            child: Text(
                                modele == Modele.petit ? 'Petit' : 'Grand')))
                        .toList(),
                    onChanged: (value) => setState(() => _modele = value),
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add),
                    label: Text('Ajouter'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[600]),
                    onPressed: () => _ajouterBoisson(provider),
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
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Colors.black12)
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(
                        boisson.estFroid ? Icons.ac_unit : Icons.local_bar,
                        color: Colors.brown[600]),
                    title: Text(boisson.nom ?? 'Sans nom'),
                    subtitle: Text('${boisson.prix.last}€'),
                    trailing: IconButton(
                      icon: Icon(Icons.delete, color: Colors.red),
                      onPressed: () => provider.deleteBoisson(boisson),
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
