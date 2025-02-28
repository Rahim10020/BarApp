import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChoiceFilterBox extends StatelessWidget {
  final String text;
  final void Function()? onTap;
  final Color couleur;

  const ChoiceFilterBox({
    super.key,
    required this.text,
    required this.onTap,
    required this.couleur,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.only(
          left: 18.0,
          right: 18.0,
          top: 4.0,
          bottom: 4.0,
        ),
        decoration: BoxDecoration(
          color: couleur,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
