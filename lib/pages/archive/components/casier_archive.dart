import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:projet7/models/casier.dart';

class CasierArchive extends StatelessWidget {
  final Casier casier;

  const CasierArchive({
    super.key,
    required this.casier,
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
                  if (casier.boisson.nom != "")
                    Text(
                      casier.boisson.nom!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                  Text(
                    NumberFormat.currency(
                            locale: "fr_FR", symbol: "FCFA", decimalDigits: 0)
                        .format(casier.prixTotal),
                    style: const TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Total Boisson: ${casier.quantiteBoisson}",
                    style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary),
                  ),
                  Text(
                    "Crée le: ${casier.dateCreation.day.toString().padLeft(2, '0')}/${casier.dateCreation.month.toString().padLeft(2, '0')}/${casier.dateCreation.year.toString()} ${casier.dateCreation.hour.toString().padLeft(2, '0')}:${casier.dateCreation.minute.toString().padLeft(2, '0')}",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontSize: 13.0,
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
