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
      estFroid: _estFroid,
      modele: _modele,
      description: _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null,
    );
    provider.addBoisson(boisson);
    _resetForm();
  }

  void _modifierBoisson(BarProvider provider, Boisson boisson) {
    boisson.nom = _nomController.text;
    boisson.prix = [double.parse(_prixController.text)];
    boisson.estFroid = _estFroid;
    boisson.modele = _modele;
    boisson.description = _descriptionController.text.isNotEmpty
        ? _descriptionController.text
        : null;
    provider.updateBoisson(boisson);
    _resetForm();
  }

  void _resetForm() {
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
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ajouter une boisson',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Expanded(
                          child: TextField(
                              controller: _nomController,
                              decoration: InputDecoration(
                                  labelText: 'Nom',
                                  contentPadding: EdgeInsets.all(8)))),
                      SizedBox(width: 8),
                      Expanded(
                          child: TextField(
                              controller: _prixController,
                              decoration: InputDecoration(
                                  labelText: 'Prix',
                                  contentPadding: EdgeInsets.all(8)),
                              keyboardType: TextInputType.number)),
                    ],
                  ),
                  TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                          labelText: 'Description',
                          contentPadding: EdgeInsets.all(8))),
                  Row(
                    children: [
                      Text('Froide ?', style: TextStyle(fontSize: 14)),
                      Switch(
                          value: _estFroid,
                          onChanged: (value) =>
                              setState(() => _estFroid = value)),
                      SizedBox(width: 8),
                      Expanded(
                        child: DropdownButton<Modele>(
                          hint: Text('Modèle'),
                          value: _modele,
                          items: Modele.values
                              .map((modele) => DropdownMenuItem(
                                  value: modele,
                                  child: Text(modele == Modele.petit
                                      ? 'Petit'
                                      : 'Grand')))
                              .toList(),
                          onChanged: (value) => setState(() => _modele = value),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.add, size: 18),
                      label: Text('Ajouter'),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.brown[600],
                          padding: EdgeInsets.symmetric(
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
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _nomController.text = boisson.nom ?? '';
                            _prixController.text = boisson.prix.last.toString();
                            _descriptionController.text =
                                boisson.description ?? '';
                            setState(() {
                              _estFroid = boisson.estFroid;
                              _modele = boisson.modele;
                            });
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Modifier la boisson'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                          controller: _nomController,
                                          decoration: InputDecoration(
                                              labelText: 'Nom')),
                                      TextField(
                                          controller: _prixController,
                                          decoration: InputDecoration(
                                              labelText: 'Prix'),
                                          keyboardType: TextInputType.number),
                                      TextField(
                                          controller: _descriptionController,
                                          decoration: InputDecoration(
                                              labelText: 'Description')),
                                      SwitchListTile(
                                          title: Text('Froide ?'),
                                          value: _estFroid,
                                          onChanged: (value) => setState(
                                              () => _estFroid = value)),
                                      DropdownButton<Modele>(
                                        hint: Text('Modèle'),
                                        value: _modele,
                                        items: Modele.values
                                            .map((modele) => DropdownMenuItem(
                                                value: modele,
                                                child: Text(
                                                    modele == Modele.petit
                                                        ? 'Petit'
                                                        : 'Grand')))
                                            .toList(),
                                        onChanged: (value) =>
                                            setState(() => _modele = value),
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Annuler')),
                                  TextButton(
                                      onPressed: () {
                                        _modifierBoisson(provider, boisson);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Modifier')),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => provider.deleteBoisson(boisson),
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
