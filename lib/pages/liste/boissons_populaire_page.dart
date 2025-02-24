import 'package:flutter/material.dart';
import 'package:projet7/components/boisson_box.dart';
import 'package:projet7/models/bar.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/detail/boisson/boisson_page.dart';
import 'package:projet7/models/modele.dart';
import 'package:provider/provider.dart';

class BoissonsPopulairePage extends StatefulWidget {
  const BoissonsPopulairePage({super.key});

  @override
  State<BoissonsPopulairePage> createState() => _BoissonsPopulairePageState();
}

class _BoissonsPopulairePageState extends State<BoissonsPopulairePage> {
  int attributIndex = 0;
  List<List<Vente>> _ventesFiltres = [];
  List<List<Vente>> _ventesAffiches = [];
  String _searchText = "";

  void _appliquerFiltres() {
    final bar = Provider.of<Bar>(context, listen: false);
    List<List<Vente>> resultats = List.from(_ventesFiltres);

    switch (attributIndex) {
      case 0:
        _ventesFiltres = bar.getVentesLesPlusVendues();
      case 1:
        resultats = resultats
            .where((b) => b.last.boisson.modele == Modele.petit)
            .toList();
        break;
      case 2:
        resultats = resultats
            .where((b) => b.last.boisson.modele == Modele.grand)
            .toList();
        break;
      default:
        break;
    }

    if (_searchText.isNotEmpty) {
      resultats = resultats
          .where(
            (v) => v[0]
                .boisson
                .nom!
                .toLowerCase()
                .contains(_searchText.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      _ventesAffiches = resultats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bar = context.watch<Bar>();

    _ventesFiltres = bar.getVentesLesPlusVendues();

    _appliquerFiltres();

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 50.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  FocusScope.of(context).unfocus(); // Ferme le clavier
                  Future.delayed(const Duration(milliseconds: 200), () {
                    Navigator.pop(context);
                  });
                },
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 8.0,
                    right: 32.0,
                  ),
                  child: TextField(
                    onChanged: (value) {
                      _searchText = value;
                      _appliquerFiltres();
                    },
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(vertical: 2.0),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: "Rechercher par boisson...",
                      hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      prefixIcon: Icon(
                        Icons.search,
                        color: Theme.of(context).colorScheme.tertiaryContainer,
                      ),
                      fillColor: Theme.of(context).colorScheme.primary,
                      focusColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 16.0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    attributIndex = 0;
                    _appliquerFiltres();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 18.0,
                      right: 18.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: attributIndex == 0
                          ? Theme.of(context).colorScheme.tertiary
                          : Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text("Tout"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    attributIndex = 1;
                    _appliquerFiltres();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(
                      left: 16.0,
                      right: 16.0,
                    ),
                    padding: const EdgeInsets.only(
                      left: 18.0,
                      right: 18.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: attributIndex == 1
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text("Petit"),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    attributIndex = 2;
                    _appliquerFiltres();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 18.0,
                      right: 18.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: attributIndex == 2
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text("Grand"),
                  ),
                ),
              ],
            ),
          ),
          _ventesAffiches.isEmpty
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
                          "Aucun résultat",
                          style: TextStyle(
                              fontSize: 20.0,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: GridView.builder(
                    itemCount: _ventesAffiches.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.6,
                    ),
                    itemBuilder: (context, index) {
                      return BoissonBox(
                        boisson: _ventesAffiches[index].last.boisson,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoissonPage(
                              boisson: _ventesAffiches[index].last.boisson,
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
