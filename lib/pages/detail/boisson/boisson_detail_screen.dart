import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/models/boisson.dart';
import 'package:projet7/components/build_info_card.dart';
import 'package:projet7/utils/helpers.dart';

/// Écran de détail d'une boisson.
///
/// Affiche les informations complètes d'une boisson:
/// - Nom et prix actuel
/// - État (froide ou non)
/// - Modèle (petit/grand)
/// - Description
class BoissonDetailScreen extends StatelessWidget {
  final Boisson boisson;

  const BoissonDetailScreen({super.key, required this.boisson});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        title: Text(
          boisson.nom ?? 'Boisson',
          style: GoogleFonts.montserrat(fontSize: 16),
        ),
        backgroundColor: Colors.brown[800],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BuildInfoCard(
              label: 'Nom',
              value: boisson.nom ?? 'N/A',
            ),
            BuildInfoCard(
              label: 'Prix',
              value: Helpers.formatterEnCFA(boisson.prix.last),
            ),
            BuildInfoCard(
              label: 'Froide',
              value: boisson.estFroid ? 'Oui' : 'Non',
            ),
            BuildInfoCard(
              label: 'Modèle',
              value: boisson.getModele() ?? 'N/A',
            ),
            BuildInfoCard(
              label: 'Description',
              value: boisson.description ?? 'Aucune',
            ),
          ],
        ),
      ),
    );
  }
}
