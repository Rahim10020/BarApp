import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/components/casier_box.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/pages/detail/casier/casier_page.dart';
import 'package:projet7/pages/liste/components/choice_filter_box.dart';
import 'package:projet7/provider/casier_provider.dart';
import 'package:projet7/theme/my_colors.dart';
import 'package:projet7/utils/casier_util.dart';
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
    final casierProvider = Provider.of<CasierProvider>(context, listen: false);
    List<Casier> resultats = List.from(_casiersFiltres);

    switch (attributIndex) {
      case 0:
        // _casiersFiltres = CasierUtil.getRecentCasiers(casierProvider.casiers);
        break;
      case 1:
        resultats = CasierUtil.trierCasierParBoisson(resultats);
        break;
      case 2:
        resultats = CasierUtil.trierCasierParPrix(resultats);
        break;
      default:
        break;
    }

    if (_searchText.isNotEmpty) {
      // resultats = resultats
      //     .where(
      //       (c) => c.boisson.nom!
      //           .toLowerCase()
      //           .contains(_searchText.toLowerCase()),
      //     )
      //     .toList();
    }

    setState(() {
      _casiersAffiches = resultats;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final casierProvider = context.watch<CasierProvider>();

    // _casiersFiltres = CasierUtil.getRecentCasiers(casierProvider.casiers);

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
                      hintText: "Rechercher par casiers...",
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
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
          const SizedBox(height: 8.0),
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
                    itemCount: _casiersAffiches.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
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
