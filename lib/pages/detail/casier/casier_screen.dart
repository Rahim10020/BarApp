import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/pages/detail/casier/casier_detail_screen.dart';
import 'package:projet7/components/build_boisson_selector.dart';
import 'package:projet7/pages/detail/casier/modifier_casier_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/casier.dart';

class CasierScreen extends StatefulWidget {
  const CasierScreen({super.key});

  @override
  State<CasierScreen> createState() => _CasierScreenState();
}

class _CasierScreenState extends State<CasierScreen> {
  final List<Boisson> _boissonsSelectionnees = [];
  int selectedIndex = 0;
  Boisson? boissonSelectionnee;
  final _boissonTotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BarProvider>(context, listen: false);
    boissonSelectionnee = provider.boissons[0];
  }

  void _ajouterCasier(BarProvider provider) {
    if (_boissonTotalController.text.isEmpty ||
        _boissonTotalController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Veuillez préciser le nombre total de boissons"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else {
      for (int i = 0; i < num.tryParse(_boissonTotalController.text)!; i++) {
        _boissonsSelectionnees.add(boissonSelectionnee!);
      }

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
                    'Nouveau Casier',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  TextField(
                    controller: _boissonTotalController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre total de boissons',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  BuildBoissonSelector(
                    itemCount: provider.boissons.length,
                    itemBuilder: (context, index) {
                      var boisson = provider.boissons[index];
                      return GestureDetector(
                        onTap: () => setState(() {
                          selectedIndex = index;
                          boissonSelectionnee = boisson;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? Colors.brown[200]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(boisson.nom ?? 'Sans nom'),
                        ),
                      );
                    },
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.add_box,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Créer Casier',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600],
                    ),
                    onPressed: () => _ajouterCasier(
                      provider,
                    ),
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
                    leading: Icon(Icons.storage, color: Colors.brown[600]),
                    title: Text('Casier #${casier.id}'),
                    subtitle: Text(
                        'Total : ${Helpers.formatterEnCFA(casier.getPrixTotal())} - ${casier.boissonTotal} boissons'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ModifierCasierScreen(casier: casier),
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
                                title: const Text(
                                    "Voulez-vous supprimer ce casier ?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Annuler"),
                                  ),
                                  TextButton(
                                      onPressed: () {
                                        provider.deleteCasier(casier);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                                'Casier #${casier.id} supprimé avec succès!'),
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
}
