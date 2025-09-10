import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/pages/detail/boisson/components/boisson_form.dart';
import 'package:projet7/pages/detail/boisson/components/boisson_list_item.dart';
import 'package:projet7/provider/bar_provider.dart';
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
      if (mounted) {
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
          BoissonForm(
            provider: provider,
            nomController: _nomController,
            prixController: _prixController,
            descriptionController: _descriptionController,
            selectedModele: _modele,
            onModeleChanged: (value) => setState(() => _modele = value),
            onAjouterBoisson: () => _ajouterBoisson(provider),
            onResetForm: _resetForm,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.boissons.length,
              itemBuilder: (context, index) {
                var boisson = provider.boissons[index];
                return BoissonListItem(
                  boisson: boisson,
                  provider: provider,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
