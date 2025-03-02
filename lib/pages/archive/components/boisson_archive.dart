import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet7/models/boisson.dart';

class BoissonArchive extends StatelessWidget {
  final Boisson boisson;

  const BoissonArchive({
    super.key,
    required this.boisson,
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
          Row(
            children: [
              const Icon(
                Icons.water_drop_outlined,
                size: 100.0,
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
                    NumberFormat.currency(
                            locale: "fr_FR", symbol: "FCFA", decimalDigits: 0)
                        .format(boisson.prix.last),
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
