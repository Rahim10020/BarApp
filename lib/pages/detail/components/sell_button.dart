import 'package:flutter/material.dart';

class SellButton extends StatelessWidget {
  final void Function()? onTap;
  final Color couleur;

  const SellButton({super.key, required this.couleur, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 64.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        decoration: BoxDecoration(
            color: couleur, borderRadius: BorderRadius.circular(20.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Vendre",
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
            ),

            const SizedBox(
              width: 20.0,
            ),

            // Icon
            Icon(Icons.sell,
                color: Theme.of(context).colorScheme.inversePrimary),
          ],
        ),
      ),
    );
  }
}
