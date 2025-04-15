import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
  int selectedIndex = 0;
  Boisson? boissonSelectionnee;
  final _boissonTotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BarProvider>(context, listen: false);
    if (provider.boissons.isNotEmpty) {
      boissonSelectionnee = provider.boissons[0];
    }
  }

  void _ajouterCasier(BarProvider provider) async {
    if (_boissonTotalController.text.isEmpty ||
        _boissonTotalController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez préciser le nombre total de boissons",
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
      List<Boisson> boissons = [];
      int quantite = int.tryParse(_boissonTotalController.text) ?? 1;
      for (int i = 0; i < quantite; i++) {
        int newId = await provider.generateUniqueId("Boisson");
        boissons.add(
          Boisson(
            id: newId,
            nom: boissonSelectionnee!.nom,
            prix: List.from(boissonSelectionnee!.prix),
            estFroid: boissonSelectionnee!.estFroid,
            modele: boissonSelectionnee!.modele,
            description: boissonSelectionnee!.description,
          ),
        );
      }

      var casier = Casier(
        id: await provider.generateUniqueId("Casier"),
        boissonTotal:
            int.tryParse(_boissonTotalController.text) ?? boissons.length,
        boissons: boissons,
      );

      provider.addCasier(casier);
      setState(() {
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
                  Text(
                    'Nouveau Casier',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _boissonTotalController,
                    decoration: InputDecoration(
                      labelText: 'Nombre total de boissons',
                      labelStyle: GoogleFonts.montserrat(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 15.0,
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: selectedIndex == index
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Text(
                                boisson.nom ?? 'Sans nom',
                                style: GoogleFonts.montserrat(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .inversePrimary,
                                ),
                              ),
                              Text(
                                boisson.modele?.name ?? '',
                                style: GoogleFonts.montserrat(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.add_box,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Créer Casier',
                      style: GoogleFonts.montserrat(color: Colors.white),
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
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(blurRadius: 4, color: Colors.black12)
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.storage, color: Colors.brown[600]),
                    title: Text(
                      'Casier ${casier.id} - ${casier.boissons.first.nom} (${casier.boissons.first.modele?.name})',
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Total : ${Helpers.formatterEnCFA(casier.getPrixTotal())} - ${casier.boissonTotal} boissons',
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
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
                                title: Text(
                                  "Voulez-vous supprimer ce casier ?",
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
                                      provider.deleteCasier(casier);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Casier #${casier.id} supprimé avec succès!',
                                            style: GoogleFonts.montserrat(),
                                          ),
                                        ),
                                      );
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
                      ],
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => CasierDetailScreen(casier: casier),
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
