import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BuildTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final int? maxLines;
  final String? Function(String?)? validator;

  const BuildTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.maxLines,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        labelText: label,
        hintText: hint,
        labelStyle: GoogleFonts.poppins(),
        hintStyle: GoogleFonts.poppins(),
        prefixIcon: Icon(
          icon,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
    );
  }
}
