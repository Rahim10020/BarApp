import 'package:flutter/material.dart';
import 'package:projet7/components/boisson_box.dart';
import 'package:projet7/components/boisson_populaire_box.dart';
import 'package:projet7/components/casier_box.dart';
import 'package:projet7/models/bar.dart';
import 'package:projet7/pages/boisson_page.dart';
import 'package:projet7/pages/boisson_populaire_page.dart';
import 'package:projet7/pages/boissons_page.dart';
import 'package:projet7/pages/boissons_populaire_page.dart';
import 'package:projet7/pages/casier_page.dart';
import 'package:projet7/pages/casiers_page.dart';
import 'package:provider/provider.dart';

class BarPage extends StatelessWidget {
  const BarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<Bar>(
        builder: (context, bar, child) => Column(
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
                    "Voir les boissons",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18.0,
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
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 120,
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
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: Text(
                    "Casiers récemments ajoutés",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18.0,
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
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bar.getRecentCasiers().isEmpty
                ? SizedBox(
                    height: 180.0,
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
                          style: TextStyle(
                              fontSize: 18.0,
                              color: Theme.of(context).colorScheme.primary),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount:
                          bar.getRecentCasiers().take(10).toList().length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return CasierBox(
                          casier:
                              bar.getRecentCasiers().take(10).toList()[index],
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    "Boissons populaires",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18.0,
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                  ),
                ),
              ],
            ),
            bar.getVentesPopulaire().isEmpty
                ? SizedBox(
                    height: 180.0,
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
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                      ],
                    ),
                  )
                : Expanded(
                    child: ListView.builder(
                      itemCount: bar.getVentesLesPlusVendues().length,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return BoissonPopulaireBox(
                          boisson:
                              bar.getVentesLesPlusVendues()[index].last.boisson,
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BoissonPopulairePage(
                                ventes: bar.getVentesLesPlusVendues()[index],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
