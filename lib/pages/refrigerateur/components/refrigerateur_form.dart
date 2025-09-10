import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:projet7/provider/bar_provider.dart';

class RefrigerateurForm extends StatefulWidget {
  final BarProvider provider;
  final TextEditingController nomController;
  final TextEditingController tempController;
  final Function() onAjouterRefrigerateur;
  final Function() onResetForm;

  const RefrigerateurForm({
    super.key,
    required this.provider,
    required this.nomController,
    required this.tempController,
    required this.onAjouterRefrigerateur,
    required this.onResetForm,
  });

  @override
  State<RefrigerateurForm> createState() => _RefrigerateurFormState();
}

class _RefrigerateurFormState extends State<RefrigerateurForm> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Text(
              'Nouveau Réfrigérateur',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: widget.nomController,
              decoration: InputDecoration(
                labelText: 'Nom',
                labelStyle: GoogleFonts.montserrat(),
              ),
            ),
            TextField(
              controller: widget.tempController,
              decoration: InputDecoration(
                labelText: 'Température (°C)',
                labelStyle: GoogleFonts.montserrat(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 16.0,
            ),
            ElevatedButton.icon(
              icon: const Icon(
                Icons.kitchen,
                color: Colors.white,
              ),
              label: Text(
                'Ajouter',
                style: GoogleFonts.montserrat(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[600],
              ),
              onPressed: widget.onAjouterRefrigerateur,
            ),
          ],
        ),
      ),
    );
  }
}
