import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';

class BoissonPicker extends StatelessWidget {
  final Boisson boisson;
  final bool isSelected;
  final void Function()? onTap;

  const BoissonPicker({
    super.key,
    required this.boisson,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.secondary,
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Column(
              children: [
                Icon(
                  Icons.water_drop_outlined,
                  size: 36.0,
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
                const SizedBox(height: 8.0),
                Text(
                  boisson.nom!.toUpperCase(),
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary),
                ),
                Text(boisson.getModele()!,
                    style: TextStyle(color: Colors.yellow.shade900)),
              ],
            ),
          ),
          const SizedBox(
            height: 16.0,
          ),
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              onTap?.call();
            },
          ),
        ],
      ),
    );
  }
}
