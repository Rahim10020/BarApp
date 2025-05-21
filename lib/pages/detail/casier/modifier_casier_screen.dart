import 'package:flutter/material.dart';
import 'package:projet7/components/build_boisson_selector.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class ModifierCasierScreen extends StatefulWidget {
  final Casier casier;

  const ModifierCasierScreen({super.key, required this.casier});

  @override
  State<ModifierCasierScreen> createState() => _ModifierCasierScreenState();
}

class _ModifierCasierScreenState extends State<ModifierCasierScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  Boisson? boissonSelectionnee;
  final _boissonTotalController = TextEditingController();
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _boissonTotalController.text = widget.casier.boissonTotal.toString();
    final provider = Provider.of<BarProvider>(context, listen: false);
    for (int i = 0; i < provider.boissons.length; i++) {
      if (widget.casier.boissons.isNotEmpty) {
        if (widget.casier.boissons[0] == provider.boissons[i]) {
          setState(() {
            selectedIndex = i;
          });
          break;
        }
      }
    }
    boissonSelectionnee = provider.boissons[0];

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _boissonTotalController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _modifierCasier(BarProvider provider, Casier casier) async {
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
        boissons.add(Boisson(
          id: newId,
          nom: boissonSelectionnee!.nom,
          prix: List.from(boissonSelectionnee!.prix),
          estFroid: boissonSelectionnee!.estFroid,
          modele: boissonSelectionnee!.modele,
          description: boissonSelectionnee!.description,
        ));
      }

      casier.boissonTotal =
          int.tryParse(_boissonTotalController.text) ?? casier.boissons.length;
      casier.boissons = boissons;
      // provider.updateCasier(casier);
      setState(() {
        _boissonTotalController.clear();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Casier #${casier.id} modifié avec succès!",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Modification de Casier #${widget.casier.id}",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Card(
              elevation: 6,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
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
                            padding: const EdgeInsets.all(8),
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
                            child: Text(
                              boisson.nom ?? 'Sans nom',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.update, size: 18),
                      label: const Text('Modifier'),
                      onPressed: () => _modifierCasier(provider, widget.casier),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
