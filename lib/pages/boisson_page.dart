import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet7/components/casier_box.dart';
import 'package:projet7/models/bar.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/ajouter_boisson_page.dart';
import 'package:projet7/pages/casier_page.dart';
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

  void ajouterVente(Vente venteVente) {
    Navigator.pop(context);

    context.read<Bar>().ajouterVente(venteVente);
  }

  @override
  Widget build(BuildContext context) {
    final bar = context.watch<Bar>();

    // Rechercher le vêtement mis à jour
    final boissonMisAJour = bar.boissons.firstWhere(
      (v) => v.id == widget.boisson.id,
      orElse: () => widget.boisson, // Garder l'ancien si non trouvé
    );

    widget.boisson = boissonMisAJour;

    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: Column(
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: 150,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                              "Voulez-vous modifier cette boisson ?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Annuler"),
                            ),
                            TextButton(
                              onPressed: () {
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
                              child: const Text("Oui"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 8.0, top: 16.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle),
                      child: Icon(
                        Icons.edit_outlined,
                        size: 28.0,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text(
                              "Voulez-vous supprimer cette boisson ?"),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("Annuler"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                context
                                    .read<Bar>()
                                    .supprimerBoisson(widget.boisson);
                                Navigator.pop(context);
                              },
                              child: const Text("Oui"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 16.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 8.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle),
                      child: Icon(Icons.delete_outlined,
                          size: 28.0, color: Colors.red.shade900),
                    ),
                  ),
                ],
              ),
              // const SizedBox(
              //   height: 12.0,
              // ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Ajouté le ${widget.boisson.dateAjout.day.toString().padLeft(2, '0')}/${widget.boisson.dateAjout.month.toString().padLeft(2, '0')}/${widget.boisson.dateAjout.year.toString()} à ${widget.boisson.dateAjout.hour.toString().padLeft(2, "0")}:${widget.boisson.dateAjout.minute.toString().padLeft(2, "0")}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.boisson.dateModification != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Row(
                    children: [
                      Text(
                        "Modifié le ${widget.boisson.dateModification!.day.toString().padLeft(2, '0')}/${widget.boisson.dateModification!.month.toString().padLeft(2, '0')}/${widget.boisson.dateModification!.year.toString()} à ${widget.boisson.dateModification!.hour.toString().padLeft(2, "0")}:${widget.boisson.dateModification!.minute.toString().padLeft(2, "0")}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14.0,
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(
                height: 8.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.boisson.stock > 0) {
                          widget.boisson.stock--;
                          bar.modifierBoisson(widget.boisson);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 8.0, right: 8.0),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 4.0, vertical: 4.0),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle),
                      child: const Icon(Icons.remove),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: Text(
                      "${widget.boisson.stock - quantite >= 0 ? widget.boisson.stock - quantite : 0}",
                      style: const TextStyle(
                        fontSize: 18.0,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (widget.boisson.stock > 0) {
                          widget.boisson.stock++;
                          bar.modifierBoisson(widget.boisson);
                        }
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.only(
                        left: 8.0,
                        right: 8.0,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.secondary,
                          shape: BoxShape.circle),
                      child: const Icon(Icons.add),
                    ),
                  ),
                ],
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
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Row(
                  children: [
                    Text(
                      NumberFormat.currency(
                              locale: "fr_FR", symbol: "FCFA", decimalDigits: 0)
                          .format(widget.boisson.prix.last),
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
                        NumberFormat.currency(
                                locale: "fr_FR",
                                symbol: "FCFA",
                                decimalDigits: 0)
                            .format(widget
                                .boisson.prix[widget.boisson.prix.length - 2]),
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.inversePrimary,
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
                                        NumberFormat.currency(
                                                locale: "fr_FR",
                                                symbol: "FCFA",
                                                decimalDigits: 0)
                                            .format(
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
                padding: const EdgeInsets.only(top: 8.0, left: 16.0),
                child: Row(
                  children: [
                    Text(
                      "Petit",
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Theme.of(context).colorScheme.inversePrimary,
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
                              color:
                                  Theme.of(context).colorScheme.inversePrimary),
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
              bar.casiers
                      .where(
                        (c) => c.boisson.id == widget.boisson.id,
                      )
                      .toList()
                      .isEmpty
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
                        itemCount: bar.casiers
                            .where(
                              (c) => c.boisson.id == widget.boisson.id,
                            )
                            .toList()
                            .length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return CasierBox(
                            casier: bar.casiers
                                .where(
                                  (c) => c.boisson.id == widget.boisson.id,
                                )
                                .toList()[index],
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CasierPage(
                                  casier: bar.casiers
                                      .where(
                                        (c) =>
                                            c.boisson.id == widget.boisson.id,
                                      )
                                      .toList()[index],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Bouton de décrémentation
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (quantite > 0) {
                              quantite--;
                            }
                          });
                        },
                        child: Icon(Icons.remove,
                            size: 20.0,
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),

                      // Quantité
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: SizedBox(
                          width: 20.0,
                          child: Center(
                            child: Text(
                              quantite.toString(),
                              style: const TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Bouton d'incrémentation
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (widget.boisson.stock - quantite > 0) {
                              quantite++;
                            }
                          });
                        },
                        child: Icon(Icons.add,
                            size: 20.0,
                            color:
                                Theme.of(context).colorScheme.inversePrimary),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              GestureDetector(
                onTap: quantite > 0
                    ? () {
                        ajouterVente(
                          Vente(
                            id: DateTime.now().millisecondsSinceEpoch %
                                0xFFFFFFFF,
                            boisson: widget.boisson,
                            quantiteVendu: quantite,
                            dateVente: DateTime.now(),
                          ),
                        );
                      }
                    : null,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 64.0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16.0, vertical: 16.0),
                  decoration: BoxDecoration(
                      color: quantite > 0
                          ? Theme.of(context).colorScheme.inversePrimary
                          : Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(20.0)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Vendre",
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),

                      const SizedBox(
                        width: 20.0,
                      ),

                      // Icon
                      Icon(Icons.sell,
                          color: Theme.of(context).colorScheme.tertiary),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
        SafeArea(
          child: Opacity(
            opacity: 0.6,
            child: Container(
              margin: const EdgeInsets.only(left: 25.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.secondary,
                  shape: BoxShape.circle),
              child: IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back_ios_rounded)),
            ),
          ),
        ),
      ],
    );
  }
}
