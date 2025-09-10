import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/pages/vente/components/vente_form.dart';
import 'package:projet7/pages/vente/components/vente_list_item.dart';
import 'package:projet7/provider/bar_provider.dart';
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
      var lignes = boissonsSelectionnees.asMap().entries.map(
        (e) {
          var ligne = LigneVente(
              id: e.key, montant: e.value.prix.last, boisson: e.value);
          ligne.synchroniserMontant(); // Assure la cohérence des données
          return ligne;
        },
      ).toList();
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
      if (mounted) {
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
          VenteForm(
            provider: provider,
            boissonsSelectionnees: boissonsSelectionnees,
            isAdding: _isAdding,
            onAjouterVente: () => _ajouterVente(provider),
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
                return VenteListItem(
                  vente: vente,
                  provider: provider,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
