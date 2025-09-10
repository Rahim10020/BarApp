import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
          title: Text(
            "La commande doit concerner au moins un casier",
            style: GoogleFonts.montserrat(),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("ok", style: GoogleFonts.montserrat()),
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
        var ligne = LigneCommande(
            id: e.key, montant: casier.getPrixTotal(), casier: casier);
        ligne.synchroniserMontant(); // Assure la cohérence des données
        return ligne;
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
      if (mounted) {
        setState(() {
          _casiersSelectionnes.clear();
          _nomFournisseurController.clear();
          _adresseFournisseurController.clear();
          _fournisseurSelectionne = null;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Commande créée avec succès!',
              style: GoogleFonts.montserrat(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
        bottom: 16.0,
        top: 8.0,
      ),
      child: Column(
        children: [
          Card(
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 12, right: 12.0, bottom: 12.0),
              child: Column(
                children: [
                  Text(
                    'Nouvelle Commande',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  DropdownButton<Fournisseur>(
                    hint: Text(
                      'Choisir un fournisseur',
                      style: GoogleFonts.montserrat(),
                    ),
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
                    decoration: InputDecoration(
                      labelText: 'Nom du fournisseur (nouveau)',
                      labelStyle: GoogleFonts.montserrat(),
                    ),
                  ),
                  TextField(
                    controller: _adresseFournisseurController,
                    decoration: InputDecoration(
                      labelText: 'Adresse du fournisseur',
                      labelStyle: GoogleFonts.montserrat(),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
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
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Casier #${casier.id}',
                            style: GoogleFonts.montserrat(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.receipt,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Créer Commande',
                      style: GoogleFonts.montserrat(
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
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(blurRadius: 4, color: Colors.black12)
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.receipt_long, color: Colors.brown[600]),
                    title: Text(
                      'Commande #${commande.id}',
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Total : ${Helpers.formatterEnCFA(commande.montantTotal)} - ${Helpers.formatterDate(commande.dateCommande)}',
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "Voulez-vous supprimer Commande #${commande.id} ?",
                              style: GoogleFonts.montserrat(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Annuler",
                                  style: GoogleFonts.montserrat(),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.deleteCommande(commande);
                                  Navigator.pop(context);
                                  if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          'Commande #${commande.id} supprimé avec succès!',
                                          style: GoogleFonts.montserrat(),
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Text(
                                  "Oui",
                                  style: GoogleFonts.montserrat(),
                                ),
                              )
                            ],
                          ),
                        );
                      },
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CommandeDetailScreen(
                          commande: commande,
                        ),
                      ),
                    ),
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
