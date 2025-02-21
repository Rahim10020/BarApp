import 'package:flutter/material.dart';
import 'package:projet7/components/boisson_box.dart';
import 'package:projet7/components/build_text_field.dart';
import 'package:projet7/pages/ajouter_boisson_page.dart';
import 'package:projet7/pages/boisson_page.dart';

class CommandePage extends StatefulWidget {
  const CommandePage({super.key});

  @override
  State<CommandePage> createState() => _CommandePageState();
}

class _CommandePageState extends State<CommandePage> {
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
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16.0),
              child: Text(
                "Passer une commande",
                style: TextStyle(
                  fontSize: 18.0,
                ),
              ),
            ),

            // Champ Stock
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BuildTextField(
                controller: _quantiteController,
                label: "Total boisson",
                hint: "Entrez le nombre de boisson",
                icon: Icons.inventory,
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

            Padding(
              padding:
                  const EdgeInsets.only(left: 16.0, bottom: 8.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Choisir boisson",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AjouterBoissonPage(),
                      ),
                    ),
                    icon: const Icon(Icons.add_box_outlined),
                    color: Colors.red,
                  )
                ],
              ),
            ),

            SizedBox(
              height: 150,
              child: Expanded(
                child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return BoissonBox(
                      text: "Fanta",
                      icon: Icons.water_drop_outlined,
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BoissonPage(),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(
              height: 16.0,
            ),

            // Bouton Ajouter
            Center(
              child: ElevatedButton(
                onPressed: _ajouterBoisson,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.inversePrimary,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 40.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: 1 == 1
                    ? const Text(
                        "Ajouter",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      )
                    : const Text(
                        "Modifier",
                        style: TextStyle(fontSize: 20.0, color: Colors.white),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
