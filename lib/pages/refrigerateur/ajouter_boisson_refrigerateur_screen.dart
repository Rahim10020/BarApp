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
  final List<Casier> _casiersSelectionnes = [];

  void _ajouterBoissonsAuRefrigerateur(
      BarProvider provider, Refrigerateur refrigerateur) {
    refrigerateur.boissons ??= [];
    // refrigerateur.boissons!.addAll(_boissonsSelectionnees);
    provider.updateRefrigerateur(refrigerateur);
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
        child: Column(
          children: [
            BuildCasierSelector(
              itemCount: provider.casiers.length,
              itemBuilder: (context, index) {
                var casier = provider.casiers[index];
                bool isSelected = _casiersSelectionnes.contains(casier);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      _casiersSelectionnes.remove(casier);
                    } else {
                      _casiersSelectionnes.add(casier);
                    }
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.brown[200] : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Casier #${casier.id}'),
                  ),
                );
              },
            ),

            // Container(
            //   padding: const EdgeInsets.all(16.0),
            //   child: const Column(children: [
            //     TextField(),
            //     ElevatedButton(onPressed: null, child: const Text("Ajouter"));
            //   ],),
            // ),

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
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.brown[600]),
              onPressed: () {
                _ajouterBoissonsAuRefrigerateur(provider, widget.refrigerateur);
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
