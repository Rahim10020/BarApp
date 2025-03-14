import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/pages/vente/components/build_indicator.dart';
import 'package:projet7/pages/vente/components/vente_filter_box.dart';
import 'package:projet7/pages/vente/components/vente_tile.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/provider/bar_provider.dart';
import 'package:projet7/theme/my_Colors.dart';
import 'package:projet7/utils/vente_util.dart';
import 'package:provider/provider.dart';

class VentePage extends StatefulWidget {
  const VentePage({super.key});

  @override
  State<VentePage> createState() => _VentePageState();
}

class _VentePageState extends State<VentePage> {
  List<Vente>? ventes;
  int triIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Consumer<BarProvider>(
        builder: (context, bar, child) {
          if (triIndex == 0) {
            ventes = bar.ventes.reversed.toList();
          }
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 8.0, bottom: 8.0, left: 8.0, right: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const BuildIndicator(
                      title: "Total vendu",
                      value: "2 000 FCFA",
                      icon: Icons.add_shopping_cart,
                    ),
                    const SizedBox(height: 16.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        VenteFilterBox(
                          icon: Icons.list,
                          onTap: () {
                            setState(() {
                              triIndex = 0;
                              ventes = bar.ventes.reversed.toList();
                            });
                          },
                          fond: triIndex == 0
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Theme.of(context).colorScheme.secondary,
                          iconCouleur: triIndex == 0
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.inversePrimary,
                        ),
                        VenteFilterBox(
                          icon: Icons.arrow_upward_rounded,
                          onTap: () {
                            setState(() {
                              triIndex = 1;
                              ventes = VenteUtil.getGrandesVentes(bar.ventes);
                            });
                          },
                          fond: triIndex == 1
                              ? Theme.of(context).colorScheme.inversePrimary
                              : Theme.of(context).colorScheme.secondary,
                          iconCouleur: triIndex == 1
                              ? Theme.of(context).colorScheme.secondary
                              : Theme.of(context).colorScheme.inversePrimary,
                        ),
                        VenteFilterBox(
                          icon: Icons.arrow_downward_rounded,
                          onTap: () {
                            setState(() {
                              triIndex = 2;
                              ventes = VenteUtil.getPetitesVentes(bar.ventes);
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
                  ],
                ),
              ),
              bar.ventes.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 120.0, bottom: 8.0),
                      child: Center(
                        child: Column(
                          children: [
                            Icon(
                              Icons.inbox,
                              color: Theme.of(context).colorScheme.primary,
                              size: 120.0,
                            ),
                            Text(
                              "Aucune vente",
                              style: GoogleFonts.lato(
                                fontSize: 14.0,
                                color: MyColors.vert,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: ventes?.length,
                        itemBuilder: (context, index) => VenteTile(
                          vente: ventes![index],
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
                                        bar.supprimerVente(ventes![index].id);
                                        setState(() {
                                          if (triIndex == 0) {
                                            ventes =
                                                bar.ventes.reversed.toList();
                                          } else if (triIndex == 1) {
                                            ventes = VenteUtil.getGrandesVentes(
                                                bar.ventes);
                                          } else if (triIndex == 2) {
                                            ventes = VenteUtil.getPetitesVentes(
                                                bar.ventes);
                                          }
                                        });
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
          );
        },
      ),
    );
  }
}
