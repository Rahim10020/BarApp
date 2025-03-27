import 'package:flutter/material.dart';
import 'package:projet7/pages/commande/commande_detail_screen.dart';
import 'package:projet7/pages/commande/components/build_casier_selector.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/commande.dart';
import 'package:projet7/models/ligne_commande.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/fournisseur.dart';

class CommandeScreen extends StatefulWidget {
  const CommandeScreen({super.key});

  @override
  State<CommandeScreen> createState() => _CommandeScreenState();
}

class _CommandeScreenState extends State<CommandeScreen> {
  final List<Casier> _casiersSelectionnes = [];
  final _nomFournisseurController = TextEditingController();
  final _adresseFournisseurController = TextEditingController();
  Fournisseur? _fournisseurSelectionne;

  void _ajouterCommande(BarProvider provider) async {
    if (_casiersSelectionnes.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("La commande doit concerner au moins un casier"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("ok"),
            ),
          ],
        ),
      );
    } else {
      Fournisseur? fournisseur;
      if (_nomFournisseurController.text.isNotEmpty) {
        fournisseur = Fournisseur(
            id: await provider.generateUniqueId("Fournisseur"),
            nom: _nomFournisseurController.text,
            adresse: _adresseFournisseurController.text);
        provider.addFournisseur(fournisseur);
      } else {
        fournisseur = _fournisseurSelectionne;
      }
      var lignes = _casiersSelectionnes.asMap().entries.map((e) {
        var casier = e.value;

        return LigneCommande(
            id: e.key, montant: casier.getPrixTotal(), casier: casier);
      }).toList();
      var commande = Commande(
        id: await provider.generateUniqueId("Commande"),
        montantTotal: lignes.fold(0.0, (sum, ligne) => sum + ligne.montant),
        dateCommande: DateTime.now(),
        lignesCommande: lignes,
        barInstance: provider.currentBar!,
        fournisseur: fournisseur,
      );
      provider.addCommande(commande);
      setState(() {
        _casiersSelectionnes.clear();
        _nomFournisseurController.clear();
        _adresseFournisseurController.clear();
        _fournisseurSelectionne = null;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Commande créée avec succès!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(
          left: 16.0, right: 16.0, bottom: 16.0, top: 8.0),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12.0, bottom: 12.0),
              child: Column(
                children: [
                  const Text(
                    'Nouvelle Commande',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<Fournisseur>(
                    hint: const Text('Choisir un fournisseur'),
                    value: _fournisseurSelectionne,
                    items: provider.fournisseurs
                        .map(
                          (fournisseur) => DropdownMenuItem(
                            value: fournisseur,
                            child: Text(
                              fournisseur.nom,
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        setState(() => _fournisseurSelectionne = value),
                  ),
                  TextField(
                      controller: _nomFournisseurController,
                      decoration: const InputDecoration(
                          labelText: 'Nom du fournisseur (nouveau)')),
                  TextField(
                    controller: _adresseFournisseurController,
                    decoration: const InputDecoration(
                      labelText: 'Adresse du fournisseur',
                    ),
                  ),
                  const SizedBox(
                    height: 4.0,
                  ),
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
                            color: isSelected
                                ? Colors.brown[200]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('Casier #${casier.id}'),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 2.0,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.receipt,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Créer Commande',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
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
                    leading: Icon(Icons.receipt_long, color: Colors.brown[600]),
                    title: Text('Commande #${commande.id}'),
                    subtitle: Text(
                        'Total : ${Helpers.formatterEnCFA(commande.montantTotal)} - ${Helpers.formatterDate(commande.dateCommande)}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                                "Voulez-vous supprimer Commande #${commande.id} ?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annuler"),
                              ),
                              TextButton(
                                  onPressed: () {
                                    provider.deleteCommande(commande);
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                            'Commande #${commande.id} supprimé avec succès!'),
                                      ),
                                    );
                                  },
                                  child: const Text("Oui"))
                            ],
                          ),
                        );
                      },
                    ),
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
}
