import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet7/models/boisson.dart';

class BoissonPopulaireBox extends StatelessWidget {
  final Boisson boisson;
  final void Function()? onTap;

  const BoissonPopulaireBox(
      {super.key, required this.boisson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        width: 170.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.0),
                  topRight: Radius.circular(12.0),
                ),
                child: Icon(
                  Icons.water_drop_outlined,
                  size: 64.0,
                ),
              ),
            ),

            // Prix + Details
            Padding(
              padding: const EdgeInsets.only(
                left: 16.0,
                right: 16.0,
                bottom: 24.0,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ajouter une icône de devise et le mettre en Row avec le texte
                  Text(
                    NumberFormat.currency(
                            locale: "fr_FR", symbol: "FCFA", decimalDigits: 0)
                        .format(boisson.prix.last),
                    style: const TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 8.0,
                  ),

                  Row(
                      mainAxisAlignment: boisson.nom != null
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.start,
                      children: [
                        // Au lieu d'ajouter texte, ajoutez le logo même de la marque
                        Text(
                          boisson.nom!,
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          boisson.getModele()!,
                          style: TextStyle(color: Colors.yellow.shade900),
                        ),
                      ]),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
