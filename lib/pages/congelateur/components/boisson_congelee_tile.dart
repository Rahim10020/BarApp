import 'package:flutter/material.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/utils/helpers.dart';

class BoissonCongeleeTile extends StatelessWidget {
  final Boisson boisson;
  final void Function()? onTap;

  const BoissonCongeleeTile({
    super.key,
    required this.boisson,
    required this.onTap,
  });

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
                    if (boisson.nom != "")
                      Text(
                        boisson.nom!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),
                      ),
                    Text(
                      Helpers.formatterEnCFA(boisson.prix.last),
                      style: const TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (boisson.modele != null)
                      Text(
                        Helpers.getModeleToString(boisson.modele)!,
                        style: TextStyle(color: Colors.yellow.shade900),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
