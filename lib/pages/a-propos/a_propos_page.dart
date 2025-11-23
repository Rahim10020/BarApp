import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Page "À propos" de l'application.
///
/// Affiche les informations sur l'application:
/// - Nom de l'application (BarApp)
/// - Version actuelle
/// - Description de l'application
class AProposPage extends StatelessWidget {
  const AProposPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        backgroundColor: Colors.transparent,
        title: Text(
          "A propos",
          style: GoogleFonts.montserrat(fontSize: 16),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "BarApp",
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Text(
                        "Version",
                        style: GoogleFonts.montserrat(),
                      ),
                      Text(
                        "1.0.0",
                        style: GoogleFonts.montserrat(),
                      ),
                    ],
                  ),
                  Text(
                    "Application mobile permettant de gerer les commandes, les ventes pour un bar",
                    style: GoogleFonts.montserrat(),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
