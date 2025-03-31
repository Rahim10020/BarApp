import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
      body: Column(children: [Text("")]),
    );
  }
}
