import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/pages/detail/casier/casier_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/casier.dart';

class CasierScreen extends StatefulWidget {
  const CasierScreen({super.key});

  @override
  _CasierScreenState createState() => _CasierScreenState();
}

class _CasierScreenState extends State<CasierScreen> {
  List<Boisson> _boissonsSelectionnees = [];
  final _boissonTotalController = TextEditingController();

  void _ajouterCasier(BarProvider provider) {
    var casier = Casier(
      id: provider.generateUniqueId(),
      boissonTotal: int.tryParse(_boissonTotalController.text) ??
          _boissonsSelectionnees.length,
      boissons: _boissonsSelectionnees,
    );
    provider.addCasier(casier);
    setState(() {
      _boissonsSelectionnees.clear();
      _boissonTotalController.clear();
    });
  }

  void _modifierCasier(BarProvider provider, Casier casier) {
    casier.boissonTotal =
        int.tryParse(_boissonTotalController.text) ?? casier.boissons.length;
    casier.boissons = _boissonsSelectionnees;
    provider.updateCasier(casier);
    setState(() {
      _boissonsSelectionnees.clear();
      _boissonTotalController.clear();
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
                children: [
                  Text('Nouveau Casier',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _boissonTotalController,
                      decoration: InputDecoration(
                          labelText: 'Nombre total de boissons'),
                      keyboardType: TextInputType.number),
                  _buildBoissonSelector(provider),
                  ElevatedButton.icon(
                    icon: Icon(Icons.add_box),
                    label: Text('Créer Casier'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[600]),
                    onPressed: () => _ajouterCasier(provider),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.casiers.length,
              itemBuilder: (context, index) {
                var casier = provider.casiers[index];
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
                    leading: Icon(Icons.storage, color: Colors.brown[600]),
                    title: Text('Casier #${casier.id}'),
                    subtitle: Text(
                        'Total : ${casier.getPrixTotal()}€ - ${casier.boissonTotal} boissons'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _boissonTotalController.text =
                                casier.boissonTotal.toString();
                            setState(() => _boissonsSelectionnees =
                                List.from(casier.boissons));
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text('Modifier le casier #${casier.id}'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                          controller: _boissonTotalController,
                                          decoration: InputDecoration(
                                              labelText:
                                                  'Nombre total de boissons'),
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
                                        _modifierCasier(provider, casier);
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
                          onPressed: () => provider.deleteCasier(casier),
                        ),
                      ],
                    ),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                CasierDetailScreen(casier: casier))),
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
