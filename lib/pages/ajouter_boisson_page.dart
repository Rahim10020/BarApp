import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projet7/components/build_drop_down.dart';
import 'package:projet7/components/build_text_field.dart';
import 'package:projet7/components/image_picker_widget.dart';

class AjouterBoissonPage extends StatefulWidget {
  const AjouterBoissonPage({super.key});

  @override
  State<AjouterBoissonPage> createState() => _AjouterBoissonPageState();
}

class _AjouterBoissonPageState extends State<AjouterBoissonPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomController;
  late TextEditingController _prixController;
  late TextEditingController _descriptionController;
  late TextEditingController _modeleController;
  late TextEditingController _quantiteController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _nomController = TextEditingController();
    _prixController = TextEditingController();
    _descriptionController = TextEditingController();
    _modeleController = TextEditingController();
    _quantiteController = TextEditingController();
  }

  @override
  void dispose() {
    _nomController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    _modeleController.dispose();
    _quantiteController.dispose();
    super.dispose();
  }

  void _ajouterBoisson() {
    if (_formKey.currentState!.validate()) {
      if (_imagePath != null) {
        Navigator.pop(context);
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Veuillez choisir une image pour le casier"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Ok"),
              ),
            ],
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: const Text("Ajouter une boisson"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 16.0),
            // Champ Nom
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BuildTextField(
                controller: _nomController,
                label: "Nom",
                hint: "Entrez le nom de la boisson",
                icon: Icons.branding_watermark,
              ),
            ),
            const SizedBox(height: 16.0),

            // Champ Modèle (Dropdown)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BuildDropDown(
                label: "Modèle",
                value: _modeleController.text.isEmpty
                    ? null
                    : _modeleController.text,
                items: const ["petit", "grand"],
                icon: Icons.shape_line,
                onChanged: (value) {
                  setState(() {
                    _modeleController.text = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 16.0),

            // Champ Prix
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BuildTextField(
                controller: _prixController,
                label: "Prix",
                hint: "Entrez le prix de la boisson",
                icon: Icons.money,
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Ce champ est obligatoire";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 16.0),
            // Champ Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: BuildTextField(
                controller: _descriptionController,
                label: "Description",
                hint: "Entrez une description pour la boisson",
                icon: Icons.description,
                maxLines: 3,
              ),
            ),
            const SizedBox(height: 16.0),

            ImagePickerWidget(
              imageFile: _imagePath == null ? null : File(_imagePath!),
              onImageSelected: (String path) {
                setState(() {
                  _imagePath = path;
                });
              },
            ),
            const SizedBox(height: 16.0),
            // Bouton Ajouter
            Center(
              child: ElevatedButton(
                onPressed: _ajouterBoisson,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40.0,
                    vertical: 16.0,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: 1 == 1
                    ? const Text(
                        "Ajouter",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      )
                    : const Text(
                        "Modifier",
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
