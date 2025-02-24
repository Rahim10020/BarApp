import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/utils/helpers.dart';

class VenteTileArchive extends StatelessWidget {
  final Vente vente;

  const VenteTileArchive({
    super.key,
    required this.vente,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.water_drop_outlined,
                size: 60.0,
              ),
              const SizedBox(
                width: 8.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (vente.boisson.nom != "")
                    Text(
                      vente.boisson.nom!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  Text(
                    NumberFormat.currency(
                            locale: "fr_FR", symbol: "FCFA", decimalDigits: 0)
                        .format(vente.boisson.prix.last),
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (vente.boisson.modele != null)
                    Text(
                      Helpers.getModeleToString(vente.boisson.modele)!,
                      style: TextStyle(color: Colors.yellow.shade900),
                    ),
                  Text(
                    "Quantité: ${vente.quantiteVendu.toString()}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  Text(
                    "Total: ${NumberFormat.currency(locale: "fr_FR", symbol: "FCFA", decimalDigits: 0).format(vente.quantiteVendu * vente.boisson.prix.last)}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  Text(
                    "Vendu le: ${vente.dateVente.day.toString().padLeft(2, '0')}/${vente.dateVente.month.toString().padLeft(2, '0')}/${vente.dateVente.year.toString()} ${vente.dateVente.hour.toString().padLeft(2, '0')}:${vente.dateVente.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13.0,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
