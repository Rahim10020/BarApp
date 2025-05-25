import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/ligne_vente.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/vente/vente_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';

class VenteScreen extends StatefulWidget {
  const VenteScreen({super.key});

  @override
  State<VenteScreen> createState() => _VenteScreenState();
}

class _VenteScreenState extends State<VenteScreen> {
  Refrigerateur? refrigerateurSelectionne;
  Map<Boisson, bool> boissonsSelectionnees = {};
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<BarProvider>(context, listen: false);
    if (provider.refrigerateurs.isNotEmpty) {
      refrigerateurSelectionne = provider.refrigerateurs.first;
      _updateBoissonsSelectionnees(provider);
    }
    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _updateBoissonsSelectionnees(BarProvider provider) {
    if (refrigerateurSelectionne != null) {
      var boissonsDisponibles =
          provider.getBoissonsDansRefrigerateur(refrigerateurSelectionne!.id);
      boissonsSelectionnees = {
        for (var boisson in boissonsDisponibles.keys)
          boisson: boissonsSelectionnees[boisson] ?? false,
      };
    } else {
      boissonsSelectionnees = {};
    }
    setState(() {});
  }

  void _enregistrerVente(BuildContext context, BarProvider provider) async {
    if (refrigerateurSelectionne == null) {
      _showErrorDialog(context, "Veuillez sélectionner un réfrigérateur");
      return;
    }
    var selectedBoissons = boissonsSelectionnees.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();
    if (selectedBoissons.isEmpty) {
      _showErrorDialog(context, "Veuillez sélectionner au moins une boisson");
      return;
    }

    try {
      var boissonsDisponibles =
          provider.getBoissonsDansRefrigerateur(refrigerateurSelectionne!.id);
      Map<Boisson, int> boissonToRefrigerateur = {};
      List<LigneVente> lignesVente = [];
      double montantTotal = 0;

      for (var boisson in selectedBoissons) {
        int quantiteDisponible = boissonsDisponibles.entries
            .firstWhere(
              (entry) =>
                  entry.key.nom == boisson.nom &&
                  entry.key.modele == boisson.modele,
              orElse: () =>
                  throw Exception('Boisson ${boisson.nom} non disponible'),
            )
            .value;
        if (quantiteDisponible < 1) {
          throw Exception('Boisson ${boisson.nom} épuisée');
        }
        var ligneVente = LigneVente(
          id: await provider.generateUniqueId("LigneVente"),
          montant: boisson.prix.last,
          boisson: boisson,
        );
        lignesVente.add(ligneVente);
        montantTotal += ligneVente.montant;
        boissonToRefrigerateur[boisson] = refrigerateurSelectionne!.id;
      }

      final vente = Vente(
        id: await provider.generateUniqueId("Vente"),
        montantTotal: montantTotal,
        dateVente: DateTime.now(),
        lignesVente: lignesVente,
      );

      await provider.addVente(vente, boissonToRefrigerateur);

      setState(() {
        _updateBoissonsSelectionnees(provider);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vente enregistrée avec succès!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                ),
          ),
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        ),
      );
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          message,
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

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    final totalVentes = provider.ventes.fold<double>(
      0,
      (sum, vente) => sum + vente.montantTotal,
    );

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Card(
            elevation: 6,
            child: ExpansionTile(
              title: Text(
                'Nouvelle Vente',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              leading: Icon(
                Icons.local_drink,
                color: Theme.of(context).colorScheme.primary,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      // Sélection du réfrigérateur
                      DropdownButtonFormField<Refrigerateur>(
                        value: refrigerateurSelectionne,
                        decoration: InputDecoration(
                          labelText: 'Réfrigérateur',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        items: provider.refrigerateurs
                            .map((refrigerateur) =>
                                DropdownMenuItem<Refrigerateur>(
                                  value: refrigerateur,
                                  child: Text('${refrigerateur.nom}'),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            refrigerateurSelectionne = value;
                            _updateBoissonsSelectionnees(provider);
                          });
                        },
                      ),
                      const SizedBox(height: 12),
                      // Champ de recherche
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Rechercher une boisson',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          filled: true,
                          fillColor:
                              Theme.of(context).colorScheme.surfaceVariant,
                          prefixIcon: Icon(Icons.search),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Liste des boissons avec défilement
                      if (refrigerateurSelectionne != null)
                        SizedBox(
                          height: 150, // Hauteur contrainte pour la liste
                          child: ListView.builder(
                            itemCount: provider
                                .getBoissonsDansRefrigerateur(
                                    refrigerateurSelectionne!.id)
                                .keys
                                .where((boisson) =>
                                    boisson.nom!
                                        .toLowerCase()
                                        .contains(_searchQuery) ||
                                    (boisson.modele?.name
                                            ?.toLowerCase()
                                            .contains(_searchQuery) ??
                                        false))
                                .length,
                            itemBuilder: (context, index) {
                              var boissonsFiltrees = provider
                                  .getBoissonsDansRefrigerateur(
                                      refrigerateurSelectionne!.id)
                                  .keys
                                  .where((boisson) =>
                                      boisson.nom!
                                          .toLowerCase()
                                          .contains(_searchQuery) ||
                                      (boisson.modele?.name
                                              ?.toLowerCase()
                                              .contains(_searchQuery) ??
                                          false))
                                  .toList();
                              var boisson = boissonsFiltrees[index];
                              int quantite =
                                  provider.getBoissonsDansRefrigerateur(
                                      refrigerateurSelectionne!.id)[boisson]!;
                              return CheckboxListTile(
                                title: Text(
                                  '${boisson.nom} (${boisson.modele?.name ?? "Sans modèle"})',
                                ),
                                value: boissonsSelectionnees[boisson] ?? false,
                                onChanged: quantite > 0
                                    ? (value) {
                                        setState(() {
                                          boissonsSelectionnees[boisson] =
                                              value!;
                                        });
                                      }
                                    : null,
                              );
                            },
                          ),
                        )
                      else
                        const Text('Aucun réfrigérateur sélectionné'),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        icon: Icon(
                          Icons.local_drink,
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                        label: Text(
                          'Enregistrer',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onPrimaryContainer,
                          ),
                        ),
                        onPressed: provider.refrigerateurs.isEmpty ||
                                boissonsSelectionnees.isEmpty
                            ? null
                            : () => _enregistrerVente(context, provider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total des ventes:',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface,
                        ),
                  ),
                  Text(
                    Helpers.formatterEnCFA(totalVentes),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: provider.ventes.isEmpty
                ? Center(
                    child: Text(
                      'Aucune vente enregistrée',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
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
                    itemCount: provider.ventes.length,
                    itemBuilder: (context, index) {
                      var vente = provider.ventes[index];
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(blurRadius: 6, color: Colors.black26),
                          ],
                        ),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => VenteDetailScreen(vente: vente),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.local_drink,
                                  color: Theme.of(context).colorScheme.primary,
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Vente #${vente.id}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primaryContainer,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Montant: ${Helpers.formatterEnCFA(vente.montantTotal)}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                Text(
                                  '${vente.lignesVente.length} article(s)',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurface,
                                      ),
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
