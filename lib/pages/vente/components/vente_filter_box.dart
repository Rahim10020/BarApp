import 'package:flutter/material.dart';

class VenteFilterBox extends StatelessWidget {
  final IconData icon;
  final Color fond;
  final Color iconCouleur;
  final void Function()? onTap;

  const VenteFilterBox(
      {super.key,
      required this.icon,
      required this.onTap,
      required this.fond,
      required this.iconCouleur});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: fond,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Icon(
          icon,
          color: iconCouleur,
        ),
      ),
    );
  }
}
