import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/pages/detail/casier/casier_detail_screen.dart';
import 'package:projet7/components/build_boisson_selector.dart';
import 'package:projet7/pages/detail/casier/modifier_casier_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/casier.dart';

class CasierScreen extends StatefulWidget {
  const CasierScreen({super.key});

  @override
  State<CasierScreen> createState() => _CasierScreenState();
}

class _CasierScreenState extends State<CasierScreen> {
  int selectedIndex = 0;
  Boisson? boissonSelectionnee;
  final _boissonTotalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BarProvider>(context, listen: false);
    if (provider.boissons.isNotEmpty) {
      boissonSelectionnee = provider.boissons[0];
    }
  }

  void _ajouterCasier(BarProvider provider) async {
    if (_boissonTotalController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez préciser le nombre total de boissons",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "OK",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    } else {
      List<Boisson> boissons = [];
      int quantite = int.tryParse(_boissonTotalController.text) ?? 1;
      for (int i = 0; i < quantite; i++) {
        int newId = await provider.generateUniqueId("Boisson");
        boissons.add(
          Boisson(
            id: newId,
            nom: boissonSelectionnee!.nom,
            prix: List.from(boissonSelectionnee!.prix),
            estFroid: boissonSelectionnee!.estFroid,
            modele: boissonSelectionnee!.modele,
            description: boissonSelectionnee!.description,
          ),
        );
      }

      var casier = Casier(
        id: await provider.generateUniqueId("Casier"),
        boissonTotal:
            int.tryParse(_boissonTotalController.text) ?? boissons.length,
        boissons: boissons,
      );

      provider.addCasier(casier);
      setState(() {
        _boissonTotalController.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Casier ajouté avec succès!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 6,
            child: ExpansionTile(
              title: Text(
                'Nouveau Casier',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: Icon(
                Icons.add_box,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _boissonTotalController,
                        decoration: InputDecoration(
                          labelText: 'Nombre total de boissons',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.tertiary,
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 16),
                      BuildBoissonSelector(
                        itemCount: provider.boissons.length,
                        itemBuilder: (context, index) {
                          var boisson = provider.boissons[index];
                          return GestureDetector(
                            onTap: () => setState(() {
                              selectedIndex = index;
                              boissonSelectionnee = boisson;
                            }),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: selectedIndex == index
                                    ? Theme.of(context).colorScheme.primary
                                    : Theme.of(context).colorScheme.tertiary,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 4,
                                    color: Colors.black26,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    boisson.nom ?? 'Sans nom',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                  ),
                                  Text(
                                    boisson.modele?.name ?? '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.add_box),
                        label: const Text('Créer Casier'),
                        onPressed: () => _ajouterCasier(provider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: provider.casiers.isEmpty
                ? Center(
                    child: Text(
                      'Aucun casier disponible',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                    ),
                  )
                : GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 1.2,
                    ),
                    itemCount: provider.casiers.length,
                    itemBuilder: (context, index) {
                      var casier = provider.casiers[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.secondary,
                              Theme.of(context).colorScheme.tertiary,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(blurRadius: 6, color: Colors.black26),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  CasierDetailScreen(casier: casier),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.storage,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Casier ${casier.id}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                ),
                                Text(
                                  '${casier.boissons.first.nom} (${casier.boissons.first.modele?.name})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Total: ${Helpers.formatterEnCFA(casier.getPrixTotal())}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                                Text(
                                  '${casier.boissonTotal} boissons',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                ),
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ModifierCasierScreen(
                                                    casier: casier),
                                          ),
                                        );
                                      },
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            title: Text(
                                              "Voulez-vous supprimer ce casier ?",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleMedium,
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text(
                                                  "Annuler",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  provider.deleteCasier(casier);
                                                  Navigator.pop(context);
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    SnackBar(
                                                      content: Text(
                                                        'Casier #${casier.id} supprimé avec succès!',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .bodyMedium
                                                            ?.copyWith(
                                                              color: Theme.of(
                                                                      context)
                                                                  .colorScheme
                                                                  .inversePrimary,
                                                            ),
                                                      ),
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primaryContainer,
                                                    ),
                                                  );
                                                },
                                                child: Text(
                                                  "Oui",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              ],
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
