import 'package:flutter/material.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/models/boisson.dart';

class RefrigerateurScreen extends StatefulWidget {
  const RefrigerateurScreen({super.key});

  @override
  _RefrigerateurScreenState createState() => _RefrigerateurScreenState();
}

class _RefrigerateurScreenState extends State<RefrigerateurScreen> {
  final _nomController = TextEditingController();
  final _tempController = TextEditingController();
  List<Boisson> _boissonsSelectionnees = [];

  void _ajouterRefrigerateur(BarProvider provider) {
    var refrigerateur = Refrigerateur(
      id: provider.generateUniqueId(),
      nom: _nomController.text,
      temperature: double.tryParse(_tempController.text),
      boissons: _boissonsSelectionnees,
    );
    provider.addRefrigerateur(refrigerateur);
    _resetForm();
  }

  void _modifierRefrigerateur(
      BarProvider provider, Refrigerateur refrigerateur) {
    refrigerateur.nom = _nomController.text;
    refrigerateur.temperature = double.tryParse(_tempController.text);
    refrigerateur.boissons = _boissonsSelectionnees;
    provider.updateRefrigerateur(refrigerateur);
    _resetForm();
  }

  void _ajouterBoissonsAuRefrigerateur(
      BarProvider provider, Refrigerateur refrigerateur) {
    refrigerateur.boissons ??= [];
    refrigerateur.boissons!.addAll(_boissonsSelectionnees);
    provider.updateRefrigerateur(refrigerateur);
  }

  void _resetForm() {
    _nomController.clear();
    _tempController.clear();
    setState(() => _boissonsSelectionnees.clear());
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
                children: [
                  Text('Nouveau Réfrigérateur',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _nomController,
                      decoration: InputDecoration(labelText: 'Nom')),
                  TextField(
                      controller: _tempController,
                      decoration:
                          InputDecoration(labelText: 'Température (°C)'),
                      keyboardType: TextInputType.number),
                  _buildBoissonSelector(provider),
                  ElevatedButton.icon(
                    icon: Icon(Icons.kitchen),
                    label: Text('Ajouter'),
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
                    leading: Icon(Icons.kitchen, color: Colors.brown[600]),
                    title: Text(refrigerateur.nom),
                    subtitle: Text(
                        'Temp : ${refrigerateur.temperature}°C - ${refrigerateur.getBoissonTotal()} boissons'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.add_circle, color: Colors.green),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => StatefulBuilder(
                              builder: (context, setDialogState) {
                                List<Boisson> tempSelection =
                                    List.from(_boissonsSelectionnees);
                                return AlertDialog(
                                  title: Text(
                                      'Ajouter des boissons à ${refrigerateur.nom}'),
                                  content: Container(
                                    height: 50,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: provider.boissons.length,
                                      itemBuilder: (context, index) {
                                        var boisson = provider.boissons[index];
                                        bool isSelected =
                                            tempSelection.contains(boisson);
                                        return GestureDetector(
                                          onTap: () => setDialogState(() {
                                            if (isSelected)
                                              tempSelection.remove(boisson);
                                            else
                                              tempSelection.add(boisson);
                                          }),
                                          child: AnimatedContainer(
                                            duration:
                                                Duration(milliseconds: 200),
                                            margin: EdgeInsets.symmetric(
                                                horizontal: 4),
                                            padding: EdgeInsets.all(8),
                                            decoration: BoxDecoration(
                                              color: isSelected
                                                  ? Colors.brown[200]
                                                  : Colors.grey[200],
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            child:
                                                Text(boisson.nom ?? 'Sans nom'),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        child: Text('Annuler')),
                                    TextButton(
                                      onPressed: () {
                                        setState(() => _boissonsSelectionnees =
                                            tempSelection);
                                        _ajouterBoissonsAuRefrigerateur(
                                            provider, refrigerateur);
                                        Navigator.pop(context);
                                      },
                                      child: Text('Ajouter'),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _nomController.text = refrigerateur.nom;
                            _tempController.text =
                                refrigerateur.temperature?.toString() ?? '';
                            setState(() => _boissonsSelectionnees =
                                List.from(refrigerateur.boissons ?? []));
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(
                                    'Modifier le réfrigérateur ${refrigerateur.nom}'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                          controller: _nomController,
                                          decoration: InputDecoration(
                                              labelText: 'Nom')),
                                      TextField(
                                          controller: _tempController,
                                          decoration: InputDecoration(
                                              labelText: 'Température (°C)'),
                                          keyboardType: TextInputType.number),
                                      _buildBoissonSelector(provider),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('Annuler')),
                                  TextButton(
                                      onPressed: () {
                                        _modifierRefrigerateur(
                                            provider, refrigerateur);
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
                          onPressed: () =>
                              provider.deleteRefrigerateur(refrigerateur),
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

  Widget _buildBoissonSelector(BarProvider provider) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.boissons.length,
        itemBuilder: (context, index) {
          var boisson = provider.boissons[index];
          bool isSelected = _boissonsSelectionnees.contains(boisson);
          return GestureDetector(
            onTap: () => setState(() {
              if (isSelected)
                _boissonsSelectionnees.remove(boisson);
              else
                _boissonsSelectionnees.add(boisson);
            }),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.brown[200] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(boisson.nom ?? 'Sans nom'),
            ),
          );
        },
      ),
    );
  }
}
