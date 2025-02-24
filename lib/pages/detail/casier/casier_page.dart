import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet7/components/boisson_box.dart';
import 'package:projet7/models/bar.dart';
import 'package:projet7/models/casier.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/detail/boisson/boisson_page.dart';
import 'package:projet7/pages/detail/components/delete_box.dart';
import 'package:projet7/pages/detail/components/edit_box.dart';
import 'package:projet7/pages/detail/components/my_back_button.dart';
import 'package:projet7/pages/detail/components/my_counter.dart';
import 'package:projet7/pages/detail/components/sell_button.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class CasierPage extends StatefulWidget {
  Casier casier;
  CasierPage({super.key, required this.casier});

  @override
  State<CasierPage> createState() => _CasierPageState();
}

class _CasierPageState extends State<CasierPage> {
  int quantite = 0;

  void ajouterVente(Vente venteVente) {
    Navigator.pop(context);

    context.read<Bar>().ajouterVente(venteVente);
  }

  @override
  Widget build(BuildContext context) {
    final bar = context.watch<Bar>();

    // Rechercher le vêtement mis à jour
    final casierMisAJour = bar.casiers.firstWhere(
      (v) => v.id == widget.casier.id,
      orElse: () => widget.casier, // Garder l'ancien si non trouvé
    );

    widget.casier = casierMisAJour;

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
                  EditBox(
                      text: "Voulez-vous modifier ce casier ?",
                      cancelAction: () => Navigator.pop(context),
                      yesAction: null),
                  DeleteBox(
                    text: "Voulez-vous supprimer ce casier ?",
                    cancelAction: () => Navigator.pop(context),
                    yesAction: () {
                      Navigator.pop(context);
                      context.read<Bar>().supprimerCasier(widget.casier);
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Row(
                  children: [
                    Text(
                      "Ajouté le ${widget.casier.dateCreation.day.toString().padLeft(2, '0')}/${widget.casier.dateCreation.month.toString().padLeft(2, '0')}/${widget.casier.dateCreation.year.toString()} à ${widget.casier.dateCreation.hour.toString().padLeft(2, "0")}:${widget.casier.dateCreation.minute.toString().padLeft(2, "0")}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 14.0,
                      ),
                    ),
                  ],
                ),
              ),
              if (widget.casier.dateModification != null)
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 4.0),
                  child: Row(
                    children: [
                      Text(
                        "Modifié le ${widget.casier.dateModification!.day.toString().padLeft(2, '0')}/${widget.casier.dateModification!.month.toString().padLeft(2, '0')}/${widget.casier.dateModification!.year.toString()} à ${widget.casier.dateModification!.hour.toString().padLeft(2, "0")}:${widget.casier.dateModification!.minute.toString().padLeft(2, "0")}",
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
              MyCounter(
                text:
                    "${widget.casier.quantiteBoisson - quantite >= 0 ? widget.casier.quantiteBoisson - quantite : 0}",
                onDecrement: () {
                  setState(
                    () {
                      widget.casier.quantiteBoisson--;
                      bar.modifierCasier(widget.casier);
                    },
                  );
                },
                onIncrement: () {
                  setState(() {
                    if (widget.casier.quantiteBoisson > 0) {
                      widget.casier.quantiteBoisson++;
                      bar.modifierCasier(widget.casier);
                    }
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                child: Row(
                  children: [
                    Text(
                      NumberFormat.currency(
                              locale: "fr_FR", symbol: "FCFA", decimalDigits: 0)
                          .format(widget.casier.prixTotal),
                      style: TextStyle(
                        color: Colors.red.shade700,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                      ),
                    ),
                    const SizedBox(
                      width: 8.0,
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(left: 16.0, top: 8.0, bottom: 16.0),
                child: Row(
                  children: [
                    Text(
                      "Boisson",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              bar.boissons
                      .where(
                        (b) => b.id == widget.casier.boisson.id,
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
                            "Aucune boisson",
                            style: TextStyle(
                                fontSize: 18.0,
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ],
                      ),
                    )
                  : BoissonBox(
                      boisson: bar.boissons
                          .where(
                            (b) => b.id == widget.casier.boisson.id,
                          )
                          .toList()[0],
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BoissonPage(
                            boisson: bar.boissons
                                .where(
                                  (b) => b.id == widget.casier.boisson.id,
                                )
                                .toList()[0],
                          ),
                        ),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 16.0,
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
                            if (widget.casier.quantiteBoisson - quantite > 0) {
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
              SellButton(
                couleur: quantite > 0
                    ? Theme.of(context).colorScheme.inversePrimary
                    : Theme.of(context).colorScheme.primary,
                onTap: quantite > 0
                    ? () {
                        ajouterVente(
                          Vente(
                            id: DateTime.now().millisecondsSinceEpoch %
                                0xFFFFFFFF,
                            boisson: widget.casier.boisson,
                            quantiteVendu: quantite,
                            dateVente: DateTime.now(),
                          ),
                        );
                      }
                    : null,
              ),
              const SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ),
        MyBackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ],
    );
  }
}
