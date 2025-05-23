import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/pages/vente/vente_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/models/ligne_vente.dart';
import 'package:projet7/models/boisson.dart';

class VenteScreen extends StatefulWidget {
  const VenteScreen({super.key});

  @override
  State<VenteScreen> createState() => _VenteScreenState();
}

class _VenteScreenState extends State<VenteScreen> {
  List<Boisson> boissonsSelectionnees = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isAdding = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  void _ajouterVente(BarProvider provider) async {
    if (boissonsSelectionnees.isNotEmpty) {
      setState(() => _isAdding = true);
      var lignes = boissonsSelectionnees
          .asMap()
          .entries
          .map(
            (e) => LigneVente(
                id: e.key, montant: e.value.prix.last, boisson: e.value),
          )
          .toList();
      var vente = Vente(
        id: await provider.generateUniqueId("Vente"),
        montantTotal: lignes.fold(0.0, (sum, ligne) => sum + ligne.montant),
        dateVente: DateTime.now(),
        lignesVente: lignes,
      );
      await provider.addVente(vente);
      // Retirer les boissons vendues des réfrigérateurs
      for (var refrigerateur in provider.refrigerateurs) {
        refrigerateur.boissons
            ?.removeWhere((b) => boissonsSelectionnees.contains(b));
        await provider.updateRefrigerateur(refrigerateur);
      }
      await Future.delayed(const Duration(milliseconds: 500));
      setState(() {
        boissonsSelectionnees.clear();
        _isAdding = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Vente enregistrée !',
            style: GoogleFonts.montserrat(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    // Limiter les boissons disponibles à celles des réfrigérateurs
    var boissonsDisponibles =
        provider.refrigerateurs.expand((r) => r.boissons ?? []).toList();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: EdgeInsets.all(_isAdding ? 20 : 16),
            decoration: BoxDecoration(
              color: _isAdding
                  ? Colors.green[200]
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  blurRadius: 4,
                  color: Colors.black26,
                )
              ],
            ),
            child: Column(
              children: [
                Text(
                  'Ajouter une vente',
                  style: GoogleFonts.montserrat(),
                ),
                const SizedBox(
                  height: 24.0,
                ),
                Container(
                  height: 65,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: boissonsDisponibles.length,
                    itemBuilder: (context, index) {
                      var boisson = boissonsDisponibles[index];
                      bool isSelected = boissonsSelectionnees.contains(boisson);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (isSelected) {
                            boissonsSelectionnees.remove(boisson);
                          } else {
                            boissonsSelectionnees.add(boisson);
                          }
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.only(
                            left: 9,
                            right: 9,
                            top: 6,
                            bottom: 3,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.tertiary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.local_bar,
                                    size: 20,
                                    color: Colors.brown[600],
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    boisson.nom ?? 'Sans nom',
                                    style: GoogleFonts.montserrat(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .inversePrimary,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                ' (${boisson.getModele()})',
                                style: GoogleFonts.montserrat(
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 14.0,
                ),
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.local_drink,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Enregistrer',
                    style: GoogleFonts.montserrat(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600]),
                  onPressed: boissonsSelectionnees.isNotEmpty
                      ? () => _ajouterVente(provider)
                      : null,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher (ID, date, boisson)',
              hintStyle: GoogleFonts.montserrat(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: provider.ventes
                  .where((v) =>
                      v.id.toString().contains(_searchController.text) ||
                      v.dateVente.toString().contains(_searchController.text) ||
                      v.lignesVente.any((l) =>
                          l.boisson.nom?.contains(_searchController.text) ??
                          false))
                  .length,
              itemBuilder: (context, index) {
                var vente = provider.ventes
                    .where((v) =>
                        v.id.toString().contains(_searchController.text) ||
                        v.dateVente
                            .toString()
                            .contains(_searchController.text) ||
                        v.lignesVente.any((l) =>
                            l.boisson.nom?.contains(_searchController.text) ??
                            false))
                    .toList()[index];
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(blurRadius: 4, color: Colors.black12)
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.receipt_long, color: Colors.brown[600]),
                    title: Text(
                      'Vente #${vente.id} - ${Helpers.formatterEnCFA(vente.montantTotal)}',
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    subtitle: Text(
                      'Date : ${Helpers.formatterDate(vente.dateVente)}',
                      style: GoogleFonts.montserrat(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => VenteDetailScreen(vente: vente),
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(
                              "Voulez-vous supprimer Vente #${vente.id} ?",
                              style: GoogleFonts.montserrat(),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text(
                                  "Annuler",
                                  style: GoogleFonts.montserrat(),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  provider.deleteVente(vente);
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Vente #${vente.id} supprimé avec succès!',
                                        style: GoogleFonts.montserrat(),
                                      ),
                                    ),
                                  );
                                },
                                child: Text(
                                  "Oui",
                                  style: GoogleFonts.montserrat(),
                                ),
                              )
                            ],
                          ),
                        );
                      },
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
