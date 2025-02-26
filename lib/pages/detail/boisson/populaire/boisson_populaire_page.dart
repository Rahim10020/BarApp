import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet7/pages/detail/boisson/populaire/components/vente_populaire_container.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/pages/detail/components/my_back_button.dart';

class BoissonPopulairePage extends StatelessWidget {
  final List<Vente> ventes;

  const BoissonPopulairePage({super.key, required this.ventes});

  @override
  Widget build(BuildContext context) {
    double totalPrix = ventes.fold(0, (sum, vente) => sum + vente.prixTotal);
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Image.file(
                  File(ventes.last.boisson.imagePath),
                  height: 150.0,
                  width: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0, top: 8.0),
                  child: Row(
                    children: [
                      Text(
                        "Ajouté le ${ventes.last.boisson.dateAjout.day.toString().padLeft(2, '0')}/${ventes.last.boisson.dateAjout.month.toString().padLeft(2, '0')}/${ventes.last.boisson.dateAjout.year.toString()} à ${ventes.last.boisson.dateAjout.hour.toString().padLeft(2, "0")}:${ventes.last.boisson.dateAjout.minute.toString().padLeft(2, "0")}",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontSize: 14.0,
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
                        NumberFormat.currency(
                                locale: "fr_FR",
                                symbol: "FCFA",
                                decimalDigits: 0)
                            .format(ventes.last.boisson.prix.last),
                        style: TextStyle(
                          color: Colors.red.shade700,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                    ],
                  ),
                ),
                if (ventes.last.boisson.description != "")
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
                            ventes.last.boisson.description!,
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
                  padding:
                      const EdgeInsets.only(left: 48.0, right: 48.0, top: 16.0),
                  child: Divider(
                    color: Theme.of(context).colorScheme.secondary,
                    thickness: 2.0,
                  ),
                ),
                Text(
                  "VENTES",
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      decorationColor:
                          Theme.of(context).colorScheme.inversePrimary),
                ),
                Column(
                  children: [
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: ventes.length,
                      itemBuilder: (context, index) {
                        final vente = ventes[index];
                        return VentePopulaireContainer(
                          vente: vente,
                        );
                      },
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.only(
                      top: 16.0, left: 32.0, right: 32.0, bottom: 8.0),
                  margin: const EdgeInsets.only(
                      top: 8.0, left: 12.0, right: 12.0, bottom: 8.0),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    "Total : ${NumberFormat.currency(locale: "fr_FR", symbol: "FCFA", decimalDigits: 0).format(totalPrix)}",
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
