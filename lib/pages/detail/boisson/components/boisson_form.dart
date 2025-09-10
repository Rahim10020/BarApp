import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/modele.dart';
import 'package:projet7/provider/bar_provider.dart';

class BoissonForm extends StatefulWidget {
  final BarProvider provider;
  final TextEditingController nomController;
  final TextEditingController prixController;
  final TextEditingController descriptionController;
  final Modele? selectedModele;
  final Function(Modele?) onModeleChanged;
  final Function() onAjouterBoisson;
  final Function() onResetForm;

  const BoissonForm({
    super.key,
    required this.provider,
    required this.nomController,
    required this.prixController,
    required this.descriptionController,
    required this.selectedModele,
    required this.onModeleChanged,
    required this.onAjouterBoisson,
    required this.onResetForm,
  });

  @override
  State<BoissonForm> createState() => _BoissonFormState();
}

class _BoissonFormState extends State<BoissonForm> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ajouter une boisson',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: widget.nomController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      labelStyle: GoogleFonts.montserrat(),
                      contentPadding: const EdgeInsets.all(8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                      controller: widget.prixController,
                      decoration: InputDecoration(
                        labelText: 'Prix',
                        labelStyle: GoogleFonts.montserrat(),
                        contentPadding: const EdgeInsets.all(8),
                      ),
                      keyboardType: TextInputType.number),
                ),
              ],
            ),
            TextField(
              controller: widget.descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
                labelStyle: GoogleFonts.montserrat(),
                contentPadding: const EdgeInsets.all(8),
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: DropdownButton<Modele>(
                    hint: Text(
                      'Modèle',
                      style: GoogleFonts.montserrat(),
                    ),
                    value: widget.selectedModele,
                    items: Modele.values
                        .map(
                          (modele) => DropdownMenuItem(
                            value: modele,
                            child: Text(
                              modele == Modele.petit ? 'Petit' : 'Grand',
                              style: GoogleFonts.montserrat(),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: widget.onModeleChanged,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Center(
              child: ElevatedButton.icon(
                icon: const Icon(
                  Icons.add,
                  size: 18,
                  color: Colors.white,
                ),
                label: Text(
                  'Ajouter',
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.brown[600],
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
                onPressed: widget.onAjouterBoisson,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
