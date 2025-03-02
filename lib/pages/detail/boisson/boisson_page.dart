import 'dart:io';

import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/ajout/ajouter_boisson_page.dart';
import 'package:projet7/pages/detail/components/delete_box.dart';
import 'package:projet7/pages/detail/components/edit_box.dart';
import 'package:projet7/pages/detail/components/freeze_button.dart';
import 'package:projet7/pages/detail/components/my_back_button.dart';
import 'package:projet7/pages/detail/components/sell_button.dart';
import 'package:projet7/provider/boisson_provider.dart';
import 'package:projet7/provider/vente_provider.dart';
import 'package:projet7/utils/helpers.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

// ignore: must_be_immutable
class BoissonPage extends StatefulWidget {
  Boisson boisson;

  BoissonPage({super.key, required this.boisson});

  @override
  State<BoissonPage> createState() => _BoissonPageState();
}

class _BoissonPageState extends State<BoissonPage> {
  int quantite = 0;

  void ajouterVente(Vente vente) {
    Navigator.pop(context);

    context.read<VenteProvider>().ajouter(vente);
  }

  @override
  Widget build(BuildContext context) {
    final boissonProvider = context.watch<BoissonProvider>();

    // Rechercher la boisson mise à jour
    final boissonMisAJour = boissonProvider.boissons.firstWhere(
      (v) => v.id == widget.boisson.id,
      orElse: () => widget.boisson, // Garder l'ancien si non trouvé
    );

    widget.boisson = boissonMisAJour;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.file(
                  File(widget.boisson.imagePath),
                  height: 150.0,
                  width: double.infinity,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    EditBox(
                      text: "Voulez-vous modifier cette boisson ?",
                      cancelAction: () => Navigator.pop(context),
                      yesAction: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AjouterBoissonPage(
                              boisson: widget.boisson,
                            ),
                          ),
                        ).then(
                          (value) {
                            if (value != null) {
                              Fluttertoast.showToast(
                                  msg: value,
                                  backgroundColor: Colors.grey.shade100,
                                  textColor: Colors.grey.shade700);
                            }
                          },
                        );
                      },
                    ),
                    DeleteBox(
                      text: "Voulez-vous supprimer cette boisson ?",
                      cancelAction: () => Navigator.pop(context),
                      yesAction: () {
                        Navigator.pop(context);
                        context
                            .read<BoissonProvider>()
                            .supprimer(widget.boisson.id);
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),

                const SizedBox(
                  height: 8.0,
                ),

                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                  child: Row(
                    children: [
                      Text(
                        widget.boisson.nom!,
                        style: TextStyle(
                            fontSize: 24.0,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Text(
                        Helpers.formatterEnCFA(widget.boisson.prix.last),
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                      if (widget.boisson.prix.length > 1)
                        Text(
                          Helpers.formatterEnCFA(widget
                              .boisson.prix[widget.boisson.prix.length - 2]),
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontSize: 18.0,
                              decoration: TextDecoration.lineThrough,
                              decorationColor:
                                  Theme.of(context).colorScheme.inversePrimary,
                              decorationThickness: 2.0),
                        ),
                      const SizedBox(
                        width: 12.0,
                      ),
                      if (widget.boisson.prix.length > 2)
                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                "Prix",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              content: Container(
                                height: 200.0,
                                child: ListView.builder(
                                  itemCount: widget.boisson.prix.length,
                                  itemBuilder: (context, index) => Column(
                                    children: [
                                      if (index == 0)
                                        Divider(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .inversePrimary,
                                        ),
                                      ListTile(
                                        title: Text(
                                          Helpers.formatterEnCFA(
                                            widget.boisson.prix.reversed
                                                .elementAt(index),
                                          ),
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .inversePrimary),
                                        ),
                                      ),
                                      Divider(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .inversePrimary,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text(
                                    "ok",
                                    style: TextStyle(
                                      fontSize: 16.0,
                                    ),
                                  ),
                                  onPressed: () => Navigator.pop(context),
                                )
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.remove_red_eye_outlined,
                            color: Theme.of(context).colorScheme.inversePrimary,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Text(
                        widget.boisson.getModele()!,
                        style: TextStyle(
                            fontSize: 16.0,
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: Row(
                    children: [
                      Text(
                        widget.boisson.estFroid ? "Froid" : "Chaud",
                        style: TextStyle(
                            fontSize: 16.0,
                            color: widget.boisson.estFroid
                                ? Colors.blue
                                : Colors.red,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        width: 8.0,
                      ),
                    ],
                  ),
                ),
                if (widget.boisson.description != "")
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 8.0,
                      left: 16.0,
                      right: 16.0,
                    ),
                    child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.boisson.description!,
                            style: TextStyle(
                                color: Theme.of(context)
                                    .colorScheme
                                    .inversePrimary),
                            softWrap: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Casiers",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                // bar.casiers
                //         .where(
                //           (c) => c.boisson.id == widget.boisson.id,
                //         )
                //         .toList()
                //         .isEmpty
                //     ? SizedBox(
                //         height: 140.0,
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Center(
                //               child: Icon(
                //                 Icons.inbox,
                //                 size: 100.0,
                //                 color: Theme.of(context).colorScheme.primary,
                //               ),
                //             ),
                //             Text(
                //               "Aucun élément",
                //               style: TextStyle(
                //                   fontSize: 18.0,
                //                   color: Theme.of(context).colorScheme.primary),
                //             ),
                //           ],
                //         ),
                //       )
                //     : SizedBox(
                //         height: 160.0,
                //         child: Expanded(
                //           child: ListView.builder(
                //             itemCount: bar.casiers
                //                 .where(
                //                   (c) => c.boisson.id == widget.boisson.id,
                //                 )
                //                 .toList()
                //                 .length,
                //             scrollDirection: Axis.horizontal,
                //             itemBuilder: (context, index) {
                //               return CasierBox(
                //                 casier: bar.casiers
                //                     .where(
                //                       (c) => c.boisson.id == widget.boisson.id,
                //                     )
                //                     .toList()[index],
                //                 onTap: () => Navigator.push(
                //                   context,
                //                   MaterialPageRoute(
                //                     builder: (context) => CasierPage(
                //                       casier: bar.casiers
                //                           .where(
                //                             (c) =>
                //                                 c.boisson.id ==
                //                                 widget.boisson.id,
                //                           )
                //                           .toList()[index],
                //                     ),
                //                   ),
                //                 ),
                //               );
                //             },
                //           ),
                //         ),
                //       ),

                const SizedBox(
                  height: 8.0,
                ),
                if (quantite > 0)
                  FreezeButton(
                      text: "Congeler",
                      onTap: () {
                        // if (widget.boisson.stock - quantite == 0) {
                        //   widget.boisson.stock -= quantite;
                        // }
                        // bar.congelerBoisson(widget.boisson, quantite);

                        // setState(
                        //   () {
                        //     quantite = 0;
                        //   },
                        // );
                        // Fluttertoast.showToast(
                        //     msg: "Boisson congelée avec succès",
                        //     backgroundColor: Colors.grey.shade100,
                        //     textColor: Colors.grey.shade700);

                        // if (widget.boisson.stock == 0) {
                        //   Navigator.pop(context);
                        // }
                      }),
                const SizedBox(
                  height: 8.0,
                ),
                SellButton(
                  couleur: quantite > 0
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).colorScheme.tertiary,
                  onTap: quantite > 0
                      ? () {
                          // ajouterVente(
                          //   Vente(
                          //     id: DateTime.now().millisecondsSinceEpoch %
                          //         0xFFFFFFFF,
                          //     boisson: widget.boisson,
                          //     quantiteVendu: quantite,
                          //     dateVente: DateTime.now(),
                          //   ),
                          // );
                        }
                      : null,
                ),
              ],
            ),
          ),
        ),
        MyBackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
