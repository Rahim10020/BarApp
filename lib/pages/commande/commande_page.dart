import 'package:flutter/material.dart';
import 'package:projet7/pages/commande/components/boisson_picker.dart';
import 'package:projet7/components/build_text_field.dart';
import 'package:projet7/models/bar.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/pages/ajout/ajouter_boisson_page.dart';
import 'package:provider/provider.dart';

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

  int? selectedBoissonIndex;
  Boisson? selectedBoisson;

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

  void _ajouterCasier() {
    if (_formKey.currentState!.validate()) {
      if (selectedBoisson != null) {
        if (int.parse(_quantiteController.text.padLeft(2, "0")) >
            selectedBoisson!.stock) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                  "Le nombre total de boisson dépasse le stock de boisson"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Ok"),
                ),
              ],
            ),
          );
        } else if (int.parse(_quantiteController.text.padLeft(2, "0")) == 0) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text(
                "Veuillez spécifier un nombre de boisson supérieur à 0",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Ok"),
                ),
              ],
            ),
          );
        } else {
          final monCasier = Casier(
            id: (DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF),
            boisson: selectedBoisson!,
            quantiteBoisson:
                int.parse(_quantiteController.text.padLeft(2, "0")),
            dateCreation: DateTime.now(),
          );

          context.read<Bar>().ajouterCasier(monCasier);

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Casier crée avec succès"),
            ),
          );

          _quantiteController.clear();
        }
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Veuillez choisir une boisson"),
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
      body: SingleChildScrollView(
        child: Form(
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
                          builder: (context) => AjouterBoissonPage(),
                        ),
                      ),
                      icon: const Icon(Icons.add_box_outlined),
                      color: Colors.red,
                    )
                  ],
                ),
              ),
              Provider.of<Bar>(context).boissons.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.inbox,
                            color: Theme.of(context).colorScheme.primary,
                            size: 120.0,
                          ),
                          Text(
                            "Aucune boisson disponible",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 190,
                      child: Expanded(
                        child: ListView.builder(
                          itemCount: Provider.of<Bar>(context).boissons.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final boisson =
                                Provider.of<Bar>(context).boissons[index];
                            return BoissonPicker(
                              boisson: boisson,
                              isSelected: selectedBoissonIndex == index,
                              onTap: () {
                                setState(() {
                                  selectedBoissonIndex = index;
                                  selectedBoisson = boisson;
                                });
                              },
                            );
                          },
                        ),
                      ),
                    ),

              const SizedBox(
                height: 18.0,
              ),

              // Bouton Ajouter
              Center(
                child: ElevatedButton(
                  onPressed: _ajouterCasier,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Theme.of(context).colorScheme.inversePrimary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 40.0, vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    "Ajouter",
                    style: TextStyle(fontSize: 20.0, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
