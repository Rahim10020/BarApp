import 'package:flutter/material.dart';

class MyBackButton extends StatelessWidget {
  final void Function()? onPressed;

  const MyBackButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Opacity(
        opacity: 0.6,
        child: Container(
          margin: const EdgeInsets.only(left: 25.0),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
              shape: BoxShape.circle),
          child: IconButton(
              onPressed: onPressed,
              icon: const Icon(Icons.arrow_back_ios_rounded)),
        ),
      ),
    );
  }
}
