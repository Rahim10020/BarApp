import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/pages/detail/boisson/boisson_detail_screen.dart';
import 'package:projet7/pages/detail/boisson/modifier_boisson_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';

class BoissonScreen extends StatefulWidget {
  const BoissonScreen({super.key});

  @override
  State<BoissonScreen> createState() => _BoissonScreenState();
}

class _BoissonScreenState extends State<BoissonScreen> {
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();
  final _descriptionController = TextEditingController();
  Modele? _modele;

  void _ajouterBoisson(BarProvider provider) async {
    if (_nomController.text.isEmpty || _nomController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez renseigner le nom",
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
    } else if (_prixController.text.isEmpty || _prixController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez renseigner le prix",
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
    } else if (_modele == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez choisir le modèle",
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
      var boisson = Boisson(
        id: await provider.generateUniqueId("Boisson"),
        nom: _nomController.text,
        prix: [double.parse(_prixController.text)],
        estFroid: false,
        modele: _modele,
        description: _descriptionController.text.isNotEmpty
            ? _descriptionController.text
            : null,
      );
      provider.addBoisson(boisson);
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${boisson.nom} ajouté avec succès!',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    }
  }

  void _resetForm() {
    _nomController.clear();
    _prixController.clear();
    _descriptionController.clear();
    setState(() {
      _modele = null;
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
                          controller: _nomController,
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
                            controller: _prixController,
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
                    controller: _descriptionController,
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
                          value: _modele,
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
                          onChanged: (value) => setState(() => _modele = value),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                      onPressed: () => _ajouterBoisson(provider),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.boissons.length,
              itemBuilder: (context, index) {
                var boisson = provider.boissons[index];
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
                    leading: Icon(
                      boisson.estFroid ? Icons.ac_unit : Icons.local_bar,
                      color: Colors.brown[600],
                    ),
                    title: Row(
                      children: [
                        Text(
                          boisson.nom ?? 'Sans nom',
                          style: GoogleFonts.montserrat(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                        Text(
                          ' (${boisson.modele?.name})',
                          style: GoogleFonts.montserrat(color: Colors.blue),
                        ),
                      ],
                    ),
                    subtitle: Text(Helpers.formatterEnCFA(boisson.prix.last)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ModifierBoissonScreen(
                                  boisson: boisson,
                                ),
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
                                  "Voulez-vous supprimer ${boisson.nom} ?",
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
                                      provider.deleteBoisson(boisson);
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${boisson.nom} supprimé avec succès!',
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
                        builder: (_) => BoissonDetailScreen(boisson: boisson),
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
