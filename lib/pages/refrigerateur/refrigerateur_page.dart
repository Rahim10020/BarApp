import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/pages/refrigerateur/components/refrigerateur_box.dart';
import 'package:projet7/pages/refrigerateur/refrigerateur_detail_page.dart';
import 'package:projet7/provider/refrigerateur_provider.dart';
import 'package:projet7/theme/my_colors.dart';
import 'package:provider/provider.dart';

class RefrigerateurPage extends StatefulWidget {
  const RefrigerateurPage({super.key});

  @override
  State<RefrigerateurPage> createState() => _RefrigerateurPageState();
}

class _RefrigerateurPageState extends State<RefrigerateurPage> {
  void _ajouterRefrigerateur() {
    final refrigerateurProvider =
        Provider.of<RefrigerateurProvider>(context, listen: false);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Voulez-vous ajouter un réfrigérateur ?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Annuler"),
          ),
          TextButton(
            onPressed: () {
              refrigerateurProvider.ajouter(
                Refrigerateur(
                  id: (DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF),
                  nom: "Réfri",
                  temperature: 16.0,
                  boissons: [
                    Boisson(
                      id: (DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF),
                      prix: [500.0],
                      imagePath: "",
                    ),
                    Boisson(
                      id: (DateTime.now().millisecondsSinceEpoch % 0xFFFFFFFF),
                      prix: [550.0],
                      imagePath: "",
                    ),
                  ],
                ),
              );
              Navigator.pop(context);
            },
            child: const Text("Oui"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final refrigerateurProvider = context.watch<RefrigerateurProvider>();
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(
          "Réfrigérateur",
          style: GoogleFonts.poppins(
            fontSize: 17,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              onChanged: (value) {
                print(value);
              },
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    width: 2.0,
                  ),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                hintText: "Rechercher...",
                hintStyle: GoogleFonts.poppins(
                  color: Theme.of(context).colorScheme.primary,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                ),
                fillColor: Theme.of(context).colorScheme.primary,
                focusColor: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          refrigerateurProvider.refrigerateurs.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inbox,
                          color: Theme.of(context).colorScheme.primary,
                          size: 120.0,
                        ),
                        Text(
                          "Aucun réfrigérateur disponible",
                          style: GoogleFonts.lato(
                            fontSize: 15.0,
                            color: MyColors.vert,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    itemCount: refrigerateurProvider.refrigerateurs.length,
                    itemBuilder: (context, index) {
                      final refrigerateur =
                          refrigerateurProvider.refrigerateurs[index];
                      return RefrigerateurBox(
                        refrigerateur: refrigerateur,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RefrigerateurDetailPage(
                                refrigerateur: refrigerateur),
                          ),
                        ),
                        onDelete: () => showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                                "Voulez-vous supprimer ce réfrigérateur ?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annuler"),
                              ),
                              TextButton(
                                onPressed: () {
                                  refrigerateurProvider
                                      .supprimer(refrigerateur.id);
                                  Navigator.pop(context);
                                },
                                child: const Text("Oui"),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _ajouterRefrigerateur,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Icon(
          Icons.add,
          color: Theme.of(context).colorScheme.tertiary,
        ),
      ),
    );
  }
}
