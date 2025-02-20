import 'package:flutter/material.dart';

class VenteTile extends StatelessWidget {
  final void Function()? onTap;
  final void Function()? onDelete;

  const VenteTile({super.key, required this.onTap, required this.onDelete});

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
                    const Text(
                      "5",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    const Text(
                      "15 000 FCFA",
                      style: TextStyle(
                          color: Colors.redAccent, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "Quantité: 8",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary),
                    ),
                    Text(
                      "Vendu le: 19/02/2025 à 21:22",
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
