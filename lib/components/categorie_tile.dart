import 'package:flutter/material.dart';

class CategorieTile extends StatelessWidget {
  final String image;
  final String modele;

  const CategorieTile({
    super.key,
    required this.image,
    required this.modele,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(50),
          ),
          padding: const EdgeInsets.all(18),
          child: Text(
            image,
            style: const TextStyle(fontSize: 25),
          ),
        ),
        // nom de la categorie
        const SizedBox(height: 9),
        Text(
          modele,
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        )
      ],
    );
  }
}
