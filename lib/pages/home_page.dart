import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:projet7/components/categorie_tile.dart';
import 'package:projet7/components/my_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      drawer: const MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: GNav(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            activeColor: Theme.of(context).colorScheme.inversePrimary,
            tabBackgroundColor: Theme.of(context).colorScheme.surface,
            padding: const EdgeInsets.all(8),
            gap: 8,
            onTabChange: (index) {
              print(index);
            },
            tabs: const [
              GButton(
                icon: Icons.home,
                text: "Home",
              ),
              GButton(
                icon: Icons.attach_money,
                text: "Ventes",
              ),
              GButton(
                icon: Icons.shopping_cart,
                text: "Cmd",
              ),
              GButton(
                icon: Icons.archive,
                text: "Archives",
              ),
            ],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            //  texte de salutation
            Column(
              children: [
                Center(
                  child: Text(
                    "Bar la Royaute",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Center(
                  child: Text(
                    "Chambres de sejours disponibles",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // partie pour les categories
            const Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  CategorieTile(image: "❤️", modele: "Grang modele"),
                  CategorieTile(image: "😊", modele: "Petit modele"),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Affichage des plus vendus
            Column(
              children: [
                // text
                Text(
                  "Les plus vendus",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                // autre column
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      // image
                      Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Center(
                          child: Text(
                            "😒",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      // nom
                      Text("Pils", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,),),
                      const SizedBox(height: 5),
                      // prix
                      Text("500fcfa", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,),),
                      const SizedBox(height: 5),
                    ],
                  ),
                )
              ],
            )
            // affichages des recemments ajoutes
          ],
        ),
      ),
    );
  }
}
