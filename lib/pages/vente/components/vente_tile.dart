import 'package:flutter/material.dart';
import 'package:projet7/models/vente.dart';
import 'package:projet7/utils/helpers.dart';

class VenteTile extends StatelessWidget {
  final Vente vente;
  final void Function()? onTap;
  final void Function()? onDelete;

  const VenteTile(
      {super.key,
      required this.vente,
      required this.onTap,
      required this.onDelete});

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
          GestureDetector(
            onTap: onTap,
            child: Row(
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
                    // if (vente.boisson.nom != "")
                    //   Text(
                    //     vente.boisson.nom!,
                    //     style: const TextStyle(
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16.0,
                    //     ),
                    //   ),
                    // Text(
                    //   Helpers.formatterEnCFA(vente.boisson.prix.last),
                    //   style: const TextStyle(
                    //     color: Colors.redAccent,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),
                    // if (vente.boisson.modele != null)
                    //   Text(
                    //     Helpers.getModeleToString(vente.boisson.modele)!,
                    //     style: TextStyle(color: Colors.yellow.shade900),
                    //   ),
                    Text(
                      "Quantité: ${vente.lignesVente.length.toString()}",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    // Text(
                    //   "Total: ${Helpers.formatterEnCFA(vente.quantiteVendu * vente.boisson.prix.last)}",
                    //   style: TextStyle(
                    //       color: Theme.of(context).colorScheme.inversePrimary),
                    // ),
                    Text(
                      "Vendu le: ${Helpers.formatterDate(vente.dateVente)}",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 13.0,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outlined,
              color: Colors.red,
              size: 30.0,
            ),
          ),
        ],
      ),
    );
  }
}
