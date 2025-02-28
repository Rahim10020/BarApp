import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/components/boisson_box.dart';
import 'package:projet7/models/bar.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/pages/detail/boisson/boisson_page.dart';
import 'package:projet7/pages/liste/components/choice_filter_box.dart';
import 'package:projet7/theme/my_colors.dart';
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
                  Future.delayed(
                    const Duration(milliseconds: 200),
                    () {
                      Navigator.pop(context);
                    },
                  );
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
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      hintText: "Rechercher par nom...",
                      hintStyle: GoogleFonts.poppins(
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
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 12.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceFilterBox(
                  text: "Tout",
                  onTap: () {
                    attributIndex = 0;
                    _appliquerFiltres();
                  },
                  couleur: attributIndex == 0
                      ? MyColors.bleu
                      : Theme.of(context).colorScheme.tertiary,
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
                        ? MyColors.bleu
                        : Theme.of(context).colorScheme.tertiary,
                  ),
                ),
                ChoiceFilterBox(
                  text: "Grand",
                  onTap: () {
                    attributIndex = 2;
                    _appliquerFiltres();
                  },
                  couleur: attributIndex == 2
                      ? MyColors.bleu
                      : Theme.of(context).colorScheme.tertiary,
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
                          style: GoogleFonts.lato(
                            fontSize: 15.0,
                            color: MyColors.vert,
                            fontWeight: FontWeight.bold,
                          ),
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
                      childAspectRatio: 0.6,
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
