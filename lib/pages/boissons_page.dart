import 'package:flutter/material.dart';
import 'package:projet7/components/boisson_box.dart';
import 'package:projet7/models/bar.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/pages/boisson_page.dart';
import 'package:provider/provider.dart';

class BoissonsPage extends StatefulWidget {
  const BoissonsPage({super.key});

  @override
  State<BoissonsPage> createState() => _BoissonsPageState();
}

class _BoissonsPageState extends State<BoissonsPage> {
  int attributIndex = 0;
  List<Boisson> _boissonsFiltres = [];
  List<Boisson> _boissonsAffiches = [];
  String _searchText = "";

  void _appliquerFiltres() {
    final bar = Provider.of<Bar>(context, listen: false);
    List<Boisson> resultats = List.from(_boissonsFiltres);

    switch (attributIndex) {
      case 0:
        _boissonsFiltres = bar.boissons;
        break;
      case 1:
        resultats = bar.getPetitModele();
        break;
      case 2:
        resultats = bar.getGrandModele();
        break;
      default:
        break;
    }

    if (_searchText.isNotEmpty) {
      resultats = resultats
          .where(
            (b) => b.nom!.toLowerCase().contains(_searchText.toLowerCase()),
          )
          .toList();
    }

    setState(() {
      _boissonsAffiches = resultats;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bar = context.watch<Bar>();

    _boissonsFiltres = bar.boissons;

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
                      hintText: "Rechercher par nom...",
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
          _boissonsAffiches.isEmpty
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
                    itemCount: _boissonsAffiches.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.7,
                    ),
                    itemBuilder: (context, index) {
                      return BoissonBox(
                        boisson: _boissonsAffiches[index],
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BoissonPage(
                              boisson: _boissonsAffiches[index],
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
