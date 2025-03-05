import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/refrigerateur.dart';
import 'package:projet7/theme/my_colors.dart';
import 'package:projet7/utils/helpers.dart';

class RefrigerateurBox extends StatelessWidget {
  final Refrigerateur refrigerateur;
  final void Function()? onTap;
  final void Function()? onDelete;

  const RefrigerateurBox(
      {super.key,
      required this.refrigerateur,
      required this.onTap,
      required this.onDelete});

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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.kitchen,
                  size: 72.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ID: ${refrigerateur.id}",
                      style: GoogleFonts.poppins(),
                    ),
                    Text(refrigerateur.boissonTotal.toString()),
                    Text(
                      Helpers.formatterEnCFA(refrigerateur.montantTotal),
                      style: GoogleFonts.poppins(
                        color: MyColors.rouge,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            IconButton(
              onPressed: onDelete,
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
