import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/components/build_boisson_selector.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:provider/provider.dart';

/// Écran de modification d'un casier existant.
///
/// Permet de modifier le contenu d'un casier:
/// - Nombre total de boissons
/// - Type de boisson via un sélecteur horizontal
///
/// Crée de nouvelles instances de boissons basées sur le modèle sélectionné.
class ModifierCasierScreen extends StatefulWidget {
  final Casier casier;

  const ModifierCasierScreen({super.key, required this.casier});

  @override
  State<ModifierCasierScreen> createState() => _ModifierCasierScreenState();
}

class _ModifierCasierScreenState extends State<ModifierCasierScreen> {
  int selectedIndex = 0;
  Boisson? boissonSelectionnee;
  final _boissonTotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _boissonTotalController.text = widget.casier.boissonTotal.toString();
    final provider = Provider.of<BarAppProvider>(context, listen: false);
    for (int i = 0; i < provider.boissons.length; i++) {
      if (widget.casier.boissons.isNotEmpty) {
        if (widget.casier.boissons[0] == provider.boissons[i]) {
          setState(() {
            selectedIndex = i;
          });
          break;
        }
      }
    }
    boissonSelectionnee = provider.boissons[0];
  }

  @override
  void dispose() {
    super.dispose();
    _boissonTotalController.dispose();
  }

  void _modifierCasier(BarAppProvider provider, Casier casier) async {
    if (_boissonTotalController.text.isEmpty ||
        _boissonTotalController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Veuillez préciser le nombre total de boissons",
              style: GoogleFonts.montserrat()),
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
        boissons.add(Boisson(
          id: newId,
          nom: boissonSelectionnee!.nom,
          prix: List.from(boissonSelectionnee!.prix),
          estFroid: boissonSelectionnee!.estFroid,
          modele: boissonSelectionnee!.modele,
          description: boissonSelectionnee!.description,
        ));
      }

      casier.boissonTotal =
          int.tryParse(_boissonTotalController.text) ?? casier.boissons.length;
      casier.boissons = boissons;
      provider.updateCasier(casier);
      if (mounted) {
        setState(() {
          _boissonTotalController.clear();
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Casier #${casier.id} modifié avec succès!",
              style: GoogleFonts.montserrat(),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          " Modification de Casier #${widget.casier.id} ",
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                  controller: _boissonTotalController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre total de boissons',
                  ),
                  keyboardType: TextInputType.number),
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
                      child: Text(
                        boisson.nom ?? 'Sans nom',
                        style: GoogleFonts.montserrat(),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 8.0,
              ),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.update,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  'Modifier',
                  style: GoogleFonts.montserrat(),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8)),
                onPressed: () {
                  _modifierCasier(provider, widget.casier);
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
