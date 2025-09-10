import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/fournisseur.dart';
import 'package:projet7/pages/commande/components/build_casier_selector.dart';
import 'package:projet7/provider/bar_provider.dart';

class CommandeForm extends StatefulWidget {
  final BarProvider provider;
  final List<Casier> casiersSelectionnes;
  final TextEditingController nomFournisseurController;
  final TextEditingController adresseFournisseurController;
  final Fournisseur? fournisseurSelectionne;
  final Function(Fournisseur?) onFournisseurChanged;
  final Function() onAjouterCommande;

  const CommandeForm({
    super.key,
    required this.provider,
    required this.casiersSelectionnes,
    required this.nomFournisseurController,
    required this.adresseFournisseurController,
    required this.fournisseurSelectionne,
    required this.onFournisseurChanged,
    required this.onAjouterCommande,
  });

  @override
  State<CommandeForm> createState() => _CommandeFormState();
}

class _CommandeFormState extends State<CommandeForm> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(left: 12, right: 12.0, bottom: 12.0),
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
              value: widget.fournisseurSelectionne,
              items: widget.provider.fournisseurs
                  .map(
                    (fournisseur) => DropdownMenuItem(
                      value: fournisseur,
                      child: Text(
                        fournisseur.nom,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: widget.onFournisseurChanged,
            ),
            TextField(
              controller: widget.nomFournisseurController,
              decoration: InputDecoration(
                labelText: 'Nom du fournisseur (nouveau)',
                labelStyle: GoogleFonts.montserrat(),
              ),
            ),
            TextField(
              controller: widget.adresseFournisseurController,
              decoration: InputDecoration(
                labelText: 'Adresse du fournisseur',
                labelStyle: GoogleFonts.montserrat(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            BuildCasierSelector(
              itemCount: widget.provider.casiers.length,
              itemBuilder: (context, index) {
                var casier = widget.provider.casiers[index];
                bool isSelected = widget.casiersSelectionnes.contains(casier);
                return GestureDetector(
                  onTap: () => setState(() {
                    if (isSelected) {
                      widget.casiersSelectionnes.remove(casier);
                    } else {
                      widget.casiersSelectionnes.add(casier);
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
                        color: Theme.of(context).colorScheme.inversePrimary,
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
              style:
                  ElevatedButton.styleFrom(backgroundColor: Colors.brown[600]),
              onPressed: widget.onAjouterCommande,
            ),
          ],
        ),
      ),
    );
  }
}
