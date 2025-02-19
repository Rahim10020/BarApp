import 'package:flutter/material.dart';

class BoissonBox extends StatelessWidget {
  final String text;
  final IconData icon;
  final void Function()? onTap;

  const BoissonBox({
    super.key,
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 36.0,
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
            const SizedBox(height: 8.0),
            Text(
              text,
              style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary),
            ),
            Text("Petit", style: TextStyle(color: Colors.yellow.shade900)),
          ],
        ),
      ),
    );
  }
}
