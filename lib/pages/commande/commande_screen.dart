import 'package:flutter/material.dart';
import 'package:projet7/pages/commande/commande_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/ligne_commande.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/fournisseur.dart';

class CommandeScreen extends StatefulWidget {
  const CommandeScreen({super.key});

  @override
  _CommandeScreenState createState() => _CommandeScreenState();
}

class _CommandeScreenState extends State<CommandeScreen> {
  List<Casier> _casiersSelectionnes = [];
  final _nomFournisseurController = TextEditingController();
  final _adresseFournisseurController = TextEditingController();

  void _ajouterCommande(BarProvider provider) {
    var fournisseur = Fournisseur(
      id: provider.fournisseurs.length,
      nom: _nomFournisseurController.text.isNotEmpty
          ? _nomFournisseurController.text
          : 'Inconnu',
      adresse: _adresseFournisseurController.text.isNotEmpty
          ? _adresseFournisseurController.text
          : 'N/A',
    );
    provider.addFournisseur(fournisseur);
    var lignes = _casiersSelectionnes
        .asMap()
        .entries
        .map((e) => LigneCommande(
            id: e.key, montant: e.value.getPrixTotal(), casier: e.value))
        .toList();
    var commande = Commande(
      id: provider.commandes.length,
      montantTotal: lignes.fold(0.0, (sum, ligne) => sum + ligne.montant),
      dateCommande: DateTime.now(),
      lignesCommande: lignes,
      barInstance: provider.currentBar!,
    );
    provider.addCommande(commande);
    setState(() {
      _casiersSelectionnes.clear();
      _nomFournisseurController.clear();
      _adresseFournisseurController.clear();
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
                  Text('Nouvelle Commande',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  TextField(
                      controller: _nomFournisseurController,
                      decoration:
                          InputDecoration(labelText: 'Nom du fournisseur')),
                  TextField(
                      controller: _adresseFournisseurController,
                      decoration:
                          InputDecoration(labelText: 'Adresse du fournisseur')),
                  _buildCasierSelector(provider),
                  ElevatedButton.icon(
                    icon: Icon(Icons.receipt),
                    label: Text('Passer Commande'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.brown[600]),
                    onPressed: () => _ajouterCommande(provider),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.commandes.length,
              itemBuilder: (context, index) {
                var commande = provider.commandes[index];
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
                    leading: Icon(Icons.receipt_long, color: Colors.brown[600]),
                    title: Text('Commande #${commande.id}'),
                    subtitle: Text(
                        'Total : ${commande.montantTotal}€ - ${commande.dateCommande.day}/${commande.dateCommande.month}'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                CommandeDetailScreen(commande: commande))),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCasierSelector(BarProvider provider) {
    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: provider.casiers.length,
        itemBuilder: (context, index) {
          var casier = provider.casiers[index];
          bool isSelected = _casiersSelectionnes.contains(casier);
          return GestureDetector(
            onTap: () => setState(() {
              if (isSelected)
                _casiersSelectionnes.remove(casier);
              else
                _casiersSelectionnes.add(casier);
            }),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 200),
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? Colors.brown[200] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text('Casier #${casier.id}'),
            ),
          );
        },
      ),
    );
  }
}
