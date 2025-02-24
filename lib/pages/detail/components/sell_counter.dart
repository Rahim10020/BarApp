import 'package:flutter/material.dart';

class SellCounter extends StatelessWidget {
  final String text;
  final void Function()? onDecrement;
  final void Function()? onIncrement;

  const SellCounter(
      {super.key,
      required this.text,
      required this.onDecrement,
      required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        left: 16.0,
        right: 16.0,
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(50),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Bouton de décrémentation
            GestureDetector(
              onTap: onDecrement,
              child: Icon(Icons.remove,
                  size: 20.0,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),

            // Quantité
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SizedBox(
                width: 20.0,
                child: Center(
                  child: Text(
                    text,
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),

            // Bouton d'incrémentation
            GestureDetector(
              onTap: onDecrement,
              child: Icon(Icons.add,
                  size: 20.0,
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
          ],
        ),
      ),
    );
  }
}
