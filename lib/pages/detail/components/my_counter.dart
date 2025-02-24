import 'package:flutter/material.dart';

class MyCounter extends StatelessWidget {
  final String text;
  final void Function()? onDecrement;
  final void Function()? onIncrement;

  const MyCounter(
      {super.key,
      required this.text,
      required this.onDecrement,
      required this.onIncrement});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: onDecrement,
          child: Container(
            margin: const EdgeInsets.only(left: 8.0, right: 8.0),
            padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle),
            child: const Icon(Icons.remove),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        GestureDetector(
          onTap: onIncrement,
          child: Container(
            margin: const EdgeInsets.only(
              left: 8.0,
              right: 8.0,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 4.0,
              vertical: 4.0,
            ),
            decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle),
            child: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
