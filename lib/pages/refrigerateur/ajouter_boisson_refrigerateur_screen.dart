import 'package:flutter/material.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/pages/commande/components/build_casier_selector.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class AjouterBoissonRefrigerateurScreen extends StatefulWidget {
  final Refrigerateur refrigerateur;

  const AjouterBoissonRefrigerateurScreen(
      {super.key, required this.refrigerateur});

  @override
  State<AjouterBoissonRefrigerateurScreen> createState() =>
      _AjouterBoissonRefrigerateurScreenState();
}

class _AjouterBoissonRefrigerateurScreenState
    extends State<AjouterBoissonRefrigerateurScreen> {
  final _boissonAAjouterController = TextEditingController();
  Casier? casierSelectionne;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BarProvider>(context, listen: false);
    casierSelectionne = provider.casiers[0];
  }

  void _ajouterBoissonsAuRefrigerateur(
      BarProvider provider, Refrigerateur refrigerateur) {
    if (_boissonAAjouterController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title:
              const Text("Veuillez préciser le nombre de boissons à ajouter"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else if (int.tryParse(_boissonAAjouterController.text)! >
        casierSelectionne!.boissonTotal) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Pas assez de boissons dans le casier"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else {
      for (int i = 0; i < int.tryParse(_boissonAAjouterController.text)!; i++) {
        refrigerateur.boissons!.add(casierSelectionne!.boissons[i]);
        casierSelectionne!.boissons.removeAt(i);
      }
      provider.updateRefrigerateur(refrigerateur);
      provider.updateCasier(casierSelectionne!);

      _boissonAAjouterController.clear();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Boisson ajoutée avec succès!"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          " Ajout de boissons à ${widget.refrigerateur.nom}",
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              BuildCasierSelector(
                itemCount: provider.casiers.length,
                itemBuilder: (context, index) {
                  var casier = provider.casiers[index];
                  return GestureDetector(
                    onTap: () => setState(() {
                      selectedIndex = index;
                      casierSelectionne = casier;
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
                      child: Text('Casier #${casier.id}'),
                    ),
                  );
                },
              ),
              if (casierSelectionne != null)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _boissonAAjouterController,
                        decoration: const InputDecoration(
                          labelText: 'Nombre total de boissons',
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(
                        height: 8.0,
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
                        onPressed: () {
                          _ajouterBoissonsAuRefrigerateur(
                              provider, widget.refrigerateur);
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
