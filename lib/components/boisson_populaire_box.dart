import 'package:flutter/material.dart';

class BoissonPopulaireBox extends StatelessWidget {
  final void Function()? onTap;

  const BoissonPopulaireBox({super.key, required this.onTap});

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
                  const Text(
                    "500 FCFA",
                    style: TextStyle(
                        color: Colors.redAccent, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(
                    height: 8.0,
                  ),

                  Row(
                      mainAxisAlignment: 2 != 1
                          ? MainAxisAlignment.spaceBetween
                          : MainAxisAlignment.start,
                      children: [
                        // Au lieu d'ajouter texte, ajoutez le logo même de la marque
                        Text(
                          "MALTA",
                          style: TextStyle(
                              color:
                                  Theme.of(context).colorScheme.inversePrimary,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "grand",
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
