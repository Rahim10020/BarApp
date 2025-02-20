import 'package:flutter/material.dart';
import 'package:projet7/components/build_indicator.dart';
import 'package:projet7/components/cart_filter_box.dart';
import 'package:projet7/components/vente_tile.dart';

class VentePage extends StatefulWidget {
  const VentePage({super.key});

  @override
  State<VentePage> createState() => _VentePageState();
}

class _VentePageState extends State<VentePage> {
  int triIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 8.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CartFilterBox(
                      icon: Icons.list,
                      onTap: () {
                        setState(() {
                          triIndex = 0;
                        });
                      },
                      fond: triIndex == 0
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.secondary,
                      iconCouleur: triIndex == 0
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.inversePrimary,
                    ),
                    CartFilterBox(
                      icon: Icons.arrow_upward_rounded,
                      onTap: () {
                        setState(() {
                          triIndex = 1;
                        });
                      },
                      fond: triIndex == 1
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.secondary,
                      iconCouleur: triIndex == 1
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.inversePrimary,
                    ),
                    CartFilterBox(
                      icon: Icons.arrow_downward_rounded,
                      onTap: () {
                        setState(() {
                          triIndex = 2;
                        });
                      },
                      fond: triIndex == 2
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.secondary,
                      iconCouleur: triIndex == 2
                          ? Theme.of(context).colorScheme.secondary
                          : Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ],
                ),
                const BuildIndicator(
                  title: "Total vendu",
                  value: "5000 FCFA",
                  icon: Icons.add_shopping_cart,
                ),
              ],
            ),
          ),
          2 == 1
              ? Padding(
                  padding: const EdgeInsets.only(top: 150.0, bottom: 8.0),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(Icons.inbox,
                            color: Theme.of(context).colorScheme.primary,
                            size: 150.0),
                        Text(
                          "Aucune vente disponible",
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
                  child: ListView.builder(
                    itemCount: 10,
                    itemBuilder: (context, index) => VenteTile(
                      onTap: null,
                      onDelete: () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text(
                                "Voulez-vous supprimer cette vente ?"),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text("Annuler"),
                              ),
                              TextButton(
                                onPressed: () {
                                  setState(() {
                                    if (triIndex == 0) {
                                    } else if (triIndex == 1) {
                                    } else if (triIndex == 2) {}
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text("Oui"),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
