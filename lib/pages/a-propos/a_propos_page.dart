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
        title: const Text(
          "A Propos",
          style: TextStyle(
            fontSize: 17,
          ),
        ),
      ),
    );
  }
}
