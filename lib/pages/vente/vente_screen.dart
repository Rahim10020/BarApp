import 'package:flutter/material.dart';
import 'package:projet7/pages/vente/vente_detail_screen.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:provider/provider.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/models/ligne_vente.dart';
import 'package:projet7/models/boisson.dart';

class VenteScreen extends StatefulWidget {
  const VenteScreen({super.key});

  @override
  _VenteScreenState createState() => _VenteScreenState();
}

class _VenteScreenState extends State<VenteScreen> {
  List<Boisson> boissonsSelectionnees = [];
  TextEditingController _searchController = TextEditingController();
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
          .map((e) => LigneVente(
              id: e.key, montant: e.value.prix.last, boisson: e.value))
          .toList();
      var vente = Vente(
        id: provider.generateUniqueId(),
        montantTotal: lignes.fold(0.0, (sum, ligne) => sum + ligne.montant),
        dateVente: DateTime.now(),
        lignesVente: lignes,
      );
      await provider.addVente(vente);
      var refrigerateur = provider.refrigerateurs.isNotEmpty
          ? provider.refrigerateurs[0]
          : null;
      if (refrigerateur != null && refrigerateur.boissons != null) {
        refrigerateur.boissons!
            .removeWhere((b) => boissonsSelectionnees.contains(b));
        await provider.updateRefrigerateur(refrigerateur);
      }
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        boissonsSelectionnees.clear();
        _isAdding = false;
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Vente enregistrée !')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BarProvider>(context);
    var boissonsDisponibles = provider.refrigerateurs.isNotEmpty &&
            provider.refrigerateurs[0].boissons != null
        ? provider.refrigerateurs[0].boissons!
        : provider.boissons;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            padding: EdgeInsets.all(_isAdding ? 20 : 16),
            decoration: BoxDecoration(
              color: _isAdding ? Colors.green[100] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black26)],
            ),
            child: Column(
              children: [
                Text('Ajouter une vente',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                Container(
                  height: 50,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: boissonsDisponibles.length,
                    itemBuilder: (context, index) {
                      var boisson = boissonsDisponibles[index];
                      bool isSelected = boissonsSelectionnees.contains(boisson);
                      return GestureDetector(
                        onTap: () => setState(() {
                          if (isSelected)
                            boissonsSelectionnees.remove(boisson);
                          else
                            boissonsSelectionnees.add(boisson);
                        }),
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 200),
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.brown[200]
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.local_bar,
                                  size: 20, color: Colors.brown[800]),
                              SizedBox(width: 4),
                              Text(boisson.nom ?? 'Sans nom'),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                ElevatedButton.icon(
                  icon: Icon(Icons.local_drink),
                  label: Text('Enregistrer'),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[600]),
                  onPressed: boissonsSelectionnees.isNotEmpty
                      ? () => _ajouterVente(provider)
                      : null,
                ),
              ],
            ),
          ),
          SizedBox(height: 16),
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: 'Rechercher (ID, date, boisson)',
              prefixIcon: Icon(Icons.search),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.white,
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
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(vertical: 8),
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(blurRadius: 4, color: Colors.black12)
                    ],
                  ),
                  child: ListTile(
                    leading: Icon(Icons.receipt_long, color: Colors.brown[600]),
                    title: Text('Vente #${vente.id} - ${vente.montantTotal}€'),
                    subtitle: Text(
                        'Date : ${vente.dateVente.day}/${vente.dateVente.month}/${vente.dateVente.year}'),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => VenteDetailScreen(vente: vente))),
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
