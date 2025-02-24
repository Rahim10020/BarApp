import 'package:flutter/material.dart';
import 'package:projet7/components/casier_box.dart';
import 'package:projet7/models/bar.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/pages/detail/casier/casier_page.dart';
import 'package:projet7/pages/liste/components/choice_filter_box.dart';
import 'package:provider/provider.dart';

class CasiersPage extends StatefulWidget {
  const CasiersPage({super.key});

  @override
  State<CasiersPage> createState() => _CasiersPageState();
}

class _CasiersPageState extends State<CasiersPage> {
  int attributIndex = 0;
  List<Casier> _casiersFiltres = [];
  List<Casier> _casiersAffiches = [];
  String _searchText = "";

  void _appliquerFiltres() {
    final bar = Provider.of<Bar>(context, listen: false);
    List<Casier> resultats = List.from(_casiersFiltres);

    switch (attributIndex) {
      case 0:
        _casiersFiltres = bar.getRecentCasiers();
        break;
      case 1:
        resultats = bar.trierCasierParBoisson(resultats);
        break;
      case 2:
        resultats = bar.trierCasierParPrix(resultats);
        break;
      default:
        break;
    }

    if (_searchText.isNotEmpty) {
      resultats = resultats
          .where(
            (c) => c.boisson.nom!
                .toLowerCase()
                .contains(_searchText.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      _casiersAffiches = resultats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bar = context.watch<Bar>();

    _casiersFiltres = bar.getRecentCasiers();

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
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.primary,
                            width: 2.0),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: "Rechercher par boisson...",
                      hintStyle: TextStyle(
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ChoiceFilterBox(
                  text: "Tout",
                  onTap: () {
                    attributIndex = 0;
                    _appliquerFiltres();
                  },
                  couleur: attributIndex == 0
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.secondary,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ChoiceFilterBox(
                    text: "Petit",
                    onTap: () {
                      attributIndex = 1;
                      _appliquerFiltres();
                    },
                    couleur: attributIndex == 1
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context).colorScheme.secondary,
                  ),
                ),
                ChoiceFilterBox(
                  text: "Grand",
                  onTap: () {
                    attributIndex = 2;
                    _appliquerFiltres();
                  },
                  couleur: attributIndex == 2
                      ? Theme.of(context).colorScheme.tertiary
                      : Theme.of(context).colorScheme.secondary,
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          _casiersAffiches.isEmpty
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
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: GridView.builder(
                    itemCount: _casiersAffiches.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return CasierBox(
                        casier: _casiersAffiches[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CasierPage(
                              casier: _casiersAffiches[index],
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
