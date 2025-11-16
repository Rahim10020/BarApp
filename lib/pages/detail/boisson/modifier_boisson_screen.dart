import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/modele.dart';
import 'package:projet7/presentation/providers/bar_app_provider.dart';
import 'package:provider/provider.dart';

class ModifierBoissonScreen extends StatefulWidget {
  final Boisson boisson;

  const ModifierBoissonScreen({super.key, required this.boisson});

  @override
  State<ModifierBoissonScreen> createState() => _ModifierBoissonScreenState();
}

class _ModifierBoissonScreenState extends State<ModifierBoissonScreen> {
  final _nomController = TextEditingController();
  final _prixController = TextEditingController();
  final _descriptionController = TextEditingController();
  Modele? _modele;

  @override
  void initState() {
    super.initState();
    _nomController.text = widget.boisson.nom ?? '';
    _prixController.text = widget.boisson.prix.last.toString();
    _descriptionController.text = widget.boisson.description ?? '';
    setState(() {
      _modele = widget.boisson.modele;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _nomController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
  }

  void _modifierBoisson(BarAppProvider provider, Boisson boisson) {
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
              child: Text(
                "ok",
                style: GoogleFonts.montserrat(),
              ),
            ),
          ],
        ),
      );
    } else {
      boisson.nom = _nomController.text;
      boisson.prix = [double.parse(_prixController.text)];
      boisson.modele = _modele;
      boisson.description = _descriptionController.text.isNotEmpty
          ? _descriptionController.text
          : null;
      provider.updateBoisson(boisson);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "${boisson.nom} modifié avec succès!",
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarAppProvider>(context);
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          " Modification de ${widget.boisson.nom ?? "Boisson"} ",
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
                  controller: _nomController,
                  decoration: const InputDecoration(labelText: 'Nom')),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  controller: _prixController,
                  decoration: const InputDecoration(labelText: 'Prix'),
                  keyboardType: TextInputType.number),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description')),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                children: [
                  DropdownButton<Modele>(
                    hint: Text('Modèle', style: GoogleFonts.montserrat()),
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
                ],
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
                  style: GoogleFonts.montserrat(color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown[600],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8)),
                onPressed: () {
                  _modifierBoisson(provider, widget.boisson);
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
