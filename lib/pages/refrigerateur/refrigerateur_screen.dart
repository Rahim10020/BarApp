import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/pages/refrigerateur/ajouter_boisson_refrigerateur_screen.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/refrigerateur.dart';

class RefrigerateurScreen extends StatefulWidget {
  const RefrigerateurScreen({super.key});

  @override
  State<RefrigerateurScreen> createState() => _RefrigerateurScreenState();
}

class _RefrigerateurScreenState extends State<RefrigerateurScreen> {
  final _nomController = TextEditingController();
  final _tempController = TextEditingController();

  void _ajouterRefrigerateur(BarProvider provider) async {
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
    } else if (_tempController.text.isEmpty || _tempController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez renseigner la température",
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
      var refrigerateur = Refrigerateur(
        id: await provider.generateUniqueId("Refrigerateur"),
        nom: _nomController.text,
        temperature: double.tryParse(_tempController.text),
      );
      provider.addRefrigerateur(refrigerateur);
      if (mounted) {
        _resetForm();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${refrigerateur.nom} ajouté avec succès!',
              style: GoogleFonts.montserrat(),
            ),
          ),
        );
      }
    }
  }

  void _modifierRefrigerateur(
      BarProvider provider, Refrigerateur refrigerateur) {
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
    } else if (_tempController.text.isEmpty || _tempController.text == "") {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez renseigner la température",
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
      refrigerateur.nom = _nomController.text;
      refrigerateur.temperature = double.tryParse(_tempController.text);
      provider.updateRefrigerateur(refrigerateur);
      _resetForm();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${refrigerateur.nom} modifié avec succès!',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    }
  }

  void _resetForm() {
    _nomController.clear();
    _tempController.clear();
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
                    'Nouveau Réfrigérateur',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextField(
                    controller: _nomController,
                    decoration: InputDecoration(
                      labelText: 'Nom',
                      labelStyle: GoogleFonts.montserrat(),
                    ),
                  ),
                  TextField(
                    controller: _tempController,
                    decoration: InputDecoration(
                      labelText: 'Température (°C)',
                      labelStyle: GoogleFonts.montserrat(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(
                    height: 16.0,
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.kitchen,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Ajouter',
                      style: GoogleFonts.montserrat(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600],
                    ),
                    onPressed: () => _ajouterRefrigerateur(provider),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.refrigerateurs.length,
              itemBuilder: (context, index) {
                var refrigerateur = provider.refrigerateurs[index];
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
                    leading: Icon(Icons.kitchen, color: Colors.brown[600]),
                    title: Text(refrigerateur.nom),
                    subtitle: refrigerateur.temperature != null
                        ? Text(
                            'Temp : ${refrigerateur.temperature}°C - ${refrigerateur.getBoissonTotal()} boissons',
                            style: GoogleFonts.montserrat(),
                          )
                        : Text(
                            '${refrigerateur.getBoissonTotal()} boissons',
                            style: GoogleFonts.montserrat(),
                          ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.add_circle,
                            color: Colors.green,
                          ),
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  AjouterBoissonRefrigerateurScreen(
                                refrigerateur: refrigerateur,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            _nomController.text = refrigerateur.nom;
                            _tempController.text =
                                refrigerateur.temperature?.toString() ?? '';
                            showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: Text(
                                  'Modifier ${refrigerateur.nom}',
                                  style: GoogleFonts.montserrat(
                                    color: Colors.white,
                                  ),
                                ),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        controller: _nomController,
                                        decoration: InputDecoration(
                                          labelText: 'Nom',
                                          labelStyle: GoogleFonts.montserrat(),
                                        ),
                                      ),
                                      TextField(
                                        controller: _tempController,
                                        decoration: InputDecoration(
                                          labelText: 'Température (°C)',
                                          labelStyle: GoogleFonts.montserrat(),
                                        ),
                                        keyboardType: TextInputType.number,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _resetForm();
                                    },
                                    child: Text(
                                      'Annuler',
                                      style: GoogleFonts.montserrat(),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      _modifierRefrigerateur(
                                          provider, refrigerateur);
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Modifier',
                                      style: GoogleFonts.montserrat(),
                                    ),
                                  ),
                                ],
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
                                  "Voulez-vous supprimer ${refrigerateur.nom} ?",
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
                                      provider
                                          .deleteRefrigerateur(refrigerateur);
                                      Navigator.pop(context);
                                      if (mounted) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              '${refrigerateur.nom} supprimé avec succès!',
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
                                  ),
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
                        builder: (_) => RefrigerateurDetailScreen(
                          refrigerateur: refrigerateur,
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
