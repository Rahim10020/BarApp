import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/refrigerateur.dart';
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
    // Sélectionner le premier casier des lignes de commande s’il existe
    var casiersCommandes = provider.commandes
        .expand((commande) => commande.lignesCommande)
        .map((ligne) => ligne.casier)
        .toList();
    if (casiersCommandes.isNotEmpty) {
      casierSelectionne = casiersCommandes[0];
    }
  }

  Future<void> _ajouterBoissonsAuRefrigerateur(
      BarProvider provider, Refrigerateur refrigerateur) async {
    if (_boissonAAjouterController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez préciser le nombre de boissons à ajouter",
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
    } else if (casierSelectionne == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Aucun casier de commande sélectionné",
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
      try {
        int nombre = int.tryParse(_boissonAAjouterController.text) ?? 0;
        await provider.ajouterBoissonsAuRefrigerateur(
            casierSelectionne!.id, refrigerateur.id, nombre);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Boissons ajoutées avec succès !",
              style: GoogleFonts.montserrat(),
            ),
          ),
        );
        _boissonAAjouterController.clear();
        Navigator.pop(context); // Retourner à l’écran précédent après succès
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text("$e"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("ok", style: GoogleFonts.montserrat()),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    // Récupérer les casiers des lignes de commande uniquement
    var casiersCommandes = provider.commandes
        .expand((commande) => commande.lignesCommande)
        .map((ligne) => ligne.casier)
        .toList();

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          "Ajout de boissons à ${widget.refrigerateur.nom}",
          style: GoogleFonts.montserrat(),
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Casiers commandés",
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 16.0,
              ),
              if (casiersCommandes.isEmpty)
                Text(
                  "Aucun casier disponible dans les commandes",
                  style: GoogleFonts.montserrat(),
                )
              else
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: casiersCommandes.length,
                    itemBuilder: (context, index) {
                      var casier = casiersCommandes[index];
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
                          child: Text(
                            'Casier #${casier.id}',
                            style: GoogleFonts.montserrat(),
                          ),
                        ),
                      );
                    },
                  ),
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
                      const SizedBox(height: 8.0),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.kitchen, color: Colors.white),
                        label: Text(
                          'Ajouter',
                          style: GoogleFonts.montserrat(),
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.brown[600]),
                        onPressed: () => _ajouterBoissonsAuRefrigerateur(
                            provider, widget.refrigerateur),
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
