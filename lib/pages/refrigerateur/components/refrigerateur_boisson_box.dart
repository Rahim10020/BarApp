import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/theme/my_colors.dart';
import 'package:projet7/utils/helpers.dart';

class RefrigerateurBoissonBox extends StatelessWidget {
  final Boisson boisson;
  final void Function()? onTap;

  const RefrigerateurBoissonBox(
      {super.key, required this.boisson, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.water_drop_outlined,
              size: 36.0,
            ),
            Column(
              children: [
                if (boisson.nom != null) Text(boisson.nom!),
                if (boisson.getModele() != null) Text(boisson.getModele()!),
                Text(
                  Helpers.formatterEnCFA(boisson.prix.last),
                  style: const TextStyle(
                    color: MyColors.rouge,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
