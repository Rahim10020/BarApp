import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/components/boisson_box.dart';
import 'package:projet7/components/casier_box.dart';
import 'package:projet7/models/bar.dart';
import 'package:projet7/pages/detail/boisson/boisson_page.dart';
import 'package:projet7/pages/detail/boisson/populaire/boisson_populaire_page.dart';
import 'package:projet7/pages/liste/boissons_page.dart';
import 'package:projet7/pages/liste/boissons_populaire_page.dart';
import 'package:projet7/pages/detail/casier/casier_page.dart';
import 'package:projet7/pages/liste/casiers_page.dart';
import 'package:projet7/theme/my_Colors.dart';
import 'package:provider/provider.dart';

class BarPage extends StatelessWidget {
  const BarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Bar>(
        builder: (context, bar, child) => SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  top: 8.0,
                  bottom: 8.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Boissons",
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const BoissonsPage(),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: Text(
                          "Voir tout",
                          style: GoogleFonts.lato(
                            color: MyColors.bleu,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              bar.boissons.isEmpty
                  ? SizedBox(
                      height: 140.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.inbox,
                              size: 100.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            "Aucun élément",
                            style: GoogleFonts.lato(
                              fontSize: 13.0,
                              color: MyColors.vert,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 140,
                      child: Expanded(
                        child: ListView.builder(
                          itemCount: bar.boissons.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return BoissonBox(
                              boisson: bar.boissons[index],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BoissonPage(
                                    boisson: bar.boissons[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 8.0, left: 16.0, right: 16.0, bottom: 8.0),
                    child: Text(
                      "Casiers récemments ajoutés",
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CasiersPage(),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text(
                        "Voir tout",
                        style: GoogleFonts.lato(
                          color: MyColors.bleu,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bar.getRecentCasiers().isEmpty
                  ? SizedBox(
                      height: 160.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.inbox,
                              size: 120.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            "Aucun élément",
                            style: GoogleFonts.lato(
                              fontSize: 13.0,
                              color: MyColors.vert,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 160.0,
                      child: Expanded(
                        child: ListView.builder(
                          itemCount:
                              bar.getRecentCasiers().take(10).toList().length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return CasierBox(
                              casier: bar
                                  .getRecentCasiers()
                                  .take(10)
                                  .toList()[index],
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CasierPage(
                                    casier: bar
                                        .getRecentCasiers()
                                        .take(10)
                                        .toList()[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      "Boissons populaires",
                      style: GoogleFonts.poppins(
                        color: Theme.of(context).colorScheme.inversePrimary,
                        fontSize: 15.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const BoissonsPopulairePage(),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: Text(
                        "Voir tout",
                        style: GoogleFonts.lato(
                          color: MyColors.bleu,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              bar.getVentesPopulaire().isEmpty
                  ? SizedBox(
                      height: 160.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Icon(
                              Icons.inbox,
                              size: 120.0,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                          Text(
                            "Aucun élément",
                            style: GoogleFonts.lato(
                              fontSize: 13,
                              color: MyColors.vert,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    )
                  : SizedBox(
                      height: 140.0,
                      child: Expanded(
                        child: ListView.builder(
                          itemCount: bar.getVentesLesPlusVendues().length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return BoissonBox(
                              boisson: bar
                                  .getVentesLesPlusVendues()[index]
                                  .last
                                  .boisson,
                              onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => BoissonPopulairePage(
                                    ventes:
                                        bar.getVentesLesPlusVendues()[index],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
