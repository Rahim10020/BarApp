import 'package:flutter/material.dart';
import 'package:projet7/components/boisson_box.dart';
import 'package:projet7/components/build_text_field.dart';
import 'package:projet7/pages/boisson_page.dart';

class CommandePage extends StatefulWidget {
  const CommandePage({super.key});

  @override
  State<CommandePage> createState() => _CommandePageState();
}

class _CommandePageState extends State<CommandePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _marqueController;
  late TextEditingController _prixController;
  late TextEditingController _descriptionController;
  late TextEditingController _tailleController;
  late TextEditingController _categorieController;
  late TextEditingController _groupeController;
  late TextEditingController _stockController;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _marqueController = TextEditingController();
    _prixController = TextEditingController();
    _descriptionController = TextEditingController();
    _tailleController = TextEditingController();
    _categorieController = TextEditingController();
    _groupeController = TextEditingController();
    _stockController = TextEditingController();
  }

  @override
  void dispose() {
    _marqueController.dispose();
    _prixController.dispose();
    _descriptionController.dispose();
    _tailleController.dispose();
    _categorieController.dispose();
    _groupeController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  void _ajouterVetement() {
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
              padding: EdgeInsets.only(bottom: 16.0),
              child: Center(
                child: Text(
                  "Passer une commande",
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            // Champ Stock
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: BuildTextField(
                controller: _stockController,
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

            const Padding(
              padding: EdgeInsets.only(left: 16.0, bottom: 16.0, right: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Choisir boisson",
                    style: TextStyle(fontSize: 18.0),
                  ),
                  Icon(
                    Icons.add_box_outlined,
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
                onPressed: _ajouterVetement,
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
