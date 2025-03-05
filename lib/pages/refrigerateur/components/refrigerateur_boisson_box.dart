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
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.kitchen,
              size: 72.0,
            ),
            Column(
              children: [
                Text(boisson.nom!),
                Text(boisson.getModele()!),
                Text(
                  Helpers.formatterEnCFA(boisson.prix.last),
                  style: GoogleFonts.poppins(
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
