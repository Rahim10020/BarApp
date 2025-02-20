import 'package:flutter/material.dart';

class BuildIndicator extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const BuildIndicator(
      {super.key,
      required this.title,
      required this.value,
      required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 36.0,
          color: Theme.of(context).colorScheme.inversePrimary,
        ),
        const SizedBox(
          height: 2.0,
        ),
        Text(title),
        const SizedBox(height: 2.0),
        Text(
          value,
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.red.shade700,
          ),
        ),
      ],
    );
  }
}
