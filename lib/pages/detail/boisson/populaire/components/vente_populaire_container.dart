import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet7/models/vente.dart';

class VentePopulaireContainer extends StatelessWidget {
  final Vente vente;

  const VentePopulaireContainer({super.key, required this.vente});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      margin: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12.0)),
      child: const Row(
        children: [
          // CircleAvatar(
          //   backgroundColor: Colors.white,
          //   backgroundImage: Image.file(File(vente.boisson.imagePath)).image,
          // ),
          Icon(Icons.water_drop_outlined),
          SizedBox(width: 12.0),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // SizedBox(
              //   width: 100,
              //   child: Row(
              //     children: [
              //       vente.boisson.nom != ""
              //           ? Text(
              //               vente.boisson.nom!,
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 color:
              //                     Theme.of(context).colorScheme.inversePrimary,
              //               ),
              //             )
              //           : Text(
              //               "Nom Inconnue",
              //               style: TextStyle(
              //                 fontWeight: FontWeight.bold,
              //                 color:
              //                     Theme.of(context).colorScheme.inversePrimary,
              //               ),
              //             ),
              //       const Text(
              //         " - ",
              //         style: TextStyle(
              //           fontWeight: FontWeight.bold,
              //         ),
              //       ),
              //       vente.boisson.modele != null
              //           ? Text(
              //               vente.boisson.getModele()!,
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.yellow.shade900),
              //             )
              //           : Text(
              //               "Modèle inconnue",
              //               style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.yellow.shade900),
              //             ),
              //     ],
              //   ),
              // ),
              // Text(
              //   "${vente.quantiteVendu} x ${NumberFormat.currency(locale: "fr_FR", symbol: "FCFA", decimalDigits: 0).format(vente.boisson.prix.last)} = ${NumberFormat.currency(locale: "fr_FR", symbol: "FCFA", decimalDigits: 0).format(vente.prixTotal)}",
              //   style: TextStyle(
              //       fontSize: 16.0,
              //       color: Theme.of(context).colorScheme.inversePrimary),
              // ),
            ],
          ),
        ],
      ),
    );
  }
}
