import 'package:flutter/material.dart';

class DeleteBox extends StatelessWidget {
  final String text;
  final void Function()? cancelAction;
  final void Function()? yesAction;

  const DeleteBox(
      {super.key,
      required this.text,
      required this.cancelAction,
      required this.yesAction});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(text),
            actions: [
              TextButton(
                onPressed: cancelAction,
                child: const Text("Annuler"),
              ),
              TextButton(
                onPressed: yesAction,
                child: const Text("Oui"),
              ),
            ],
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            shape: BoxShape.circle),
        child:
            Icon(Icons.delete_outlined, size: 28.0, color: Colors.red.shade900),
      ),
    );
  }
}
