import 'package:flutter/material.dart';
import 'package:projet7/components/casier_box.dart';
import 'package:projet7/pages/casier_page.dart';

class CasiersPage extends StatefulWidget {
  const CasiersPage({super.key});

  @override
  State<CasiersPage> createState() => _CasiersPageState();
}

class _CasiersPageState extends State<CasiersPage> {
  int attributIndex = 0;
  String _searchText = "";

  void appliquerPremierTri(bool petit, bool grand) {
    _appliquerFiltresCombines();
  }

  void reinitialiserPremierTri() {
    attributIndex = 0;
    setState(() {});

    _appliquerFiltresCombines();
  }

  void _appliquerRecherche(String text) {
    setState(() {
      _searchText = text;
    });

    _appliquerFiltresCombines();
  }

  void _appliquerFiltresCombines() {
    if (_searchText.isNotEmpty) {}

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
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
                    onChanged: _appliquerRecherche,
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
                GestureDetector(
                  onTap: () => reinitialiserPremierTri(),
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 18.0,
                      right: 18.0,
                      top: 4.0,
                      bottom: 4.0,
                    ),
                    decoration: BoxDecoration(
                      color: attributIndex == 0
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.secondary,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text("Tout"),
                  ),
                ),
                GestureDetector(
                  onTap: () => appliquerPremierTri(true, false),
                  child: Container(
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
                    child: const Text("boisson"),
                  ),
                ),
                GestureDetector(
                  onTap: () => appliquerPremierTri(false, true),
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
                    child: const Text("prix"),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 8.0,
          ),
          2 == 1
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
                    itemCount: 10,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return CasierBox(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CasierPage(),
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
