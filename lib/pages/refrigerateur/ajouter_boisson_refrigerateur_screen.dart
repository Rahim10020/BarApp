import 'package:flutter/material.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';

class AjouterBoissonRefrigerateurScreen extends StatefulWidget {
  final Refrigerateur refrigerateur;

  const AjouterBoissonRefrigerateurScreen(
      {super.key, required this.refrigerateur});

  @override
  State<AjouterBoissonRefrigerateurScreen> createState() =>
      _AjouterBoissonRefrigerateurScreenState();
}

class _AjouterBoissonRefrigerateurScreenState
    extends State<AjouterBoissonRefrigerateurScreen>
    with SingleTickerProviderStateMixin {
  final _boissonAAjouterController = TextEditingController();
  Casier? casierSelectionne;
  int selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BarProvider>(context, listen: false);
    var casiersCommandes = provider.commandes
        .expand((commande) => commande.lignesCommande)
        .map((ligne) => ligne.casier)
        .toList();
    if (casiersCommandes.isNotEmpty) {
      casierSelectionne = casiersCommandes[0];
    }

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
    _boissonAAjouterController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _ajouterBoissonsAuRefrigerateur(
      BarProvider provider, Refrigerateur refrigerateur) async {
    if (_boissonAAjouterController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Veuillez préciser le nombre de boissons à ajouter",
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
    } else if (casierSelectionne == null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Aucun casier de commande sélectionné",
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
      try {
        int nombre = int.tryParse(_boissonAAjouterController.text) ?? 0;
        await provider.ajouterBoissonsAuRefrigerateur(
            casierSelectionne!.id, refrigerateur.id, nombre);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Boissons ajoutées avec succès !",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
            ),
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          ),
        );
        _boissonAAjouterController.clear();
        Navigator.pop(context);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "$e",
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
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    var casiersCommandes = provider.commandes
        .expand((commande) => commande.lignesCommande)
        .map((ligne) => ligne.casier)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Ajout de boissons à ${widget.refrigerateur.nom}",
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Casiers commandés",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 16),
                casiersCommandes.isEmpty
                    ? Center(
                        child: Text(
                          "Aucun casier disponible dans les commandes",
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .inversePrimary,
                                  ),
                        ),
                      )
                    : Container(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: casiersCommandes.length,
                          itemBuilder: (context, index) {
                            var casier = casiersCommandes[index];
                            return GestureDetector(
                              onTap: () => setState(() {
                                selectedIndex = index;
                                casierSelectionne = casier;
                              }),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                padding: const EdgeInsets.all(12),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Casier #${casier.id}',
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
                                      '${casier.boissons.first.nom}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .inversePrimary,
                                          ),
                                    ),
                                    Text(
                                      '${casier.boissons.first.modele?.name}',
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
                      ),
                if (casierSelectionne != null) ...[
                  const SizedBox(height: 16),
                  Card(
                    elevation: 6,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: _boissonAAjouterController,
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
                          ElevatedButton.icon(
                            icon: const Icon(Icons.kitchen),
                            label: const Text('Ajouter'),
                            onPressed: () => _ajouterBoissonsAuRefrigerateur(
                                provider, widget.refrigerateur),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
