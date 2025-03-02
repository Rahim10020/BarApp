import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CongelateurPage extends StatelessWidget {
  const CongelateurPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        elevation: 0,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
        centerTitle: true,
        title: Text(
          "Congélateur",
          style: GoogleFonts.poppins(
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
