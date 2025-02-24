import 'package:flutter/material.dart';
import 'package:projet7/components/boisson_box.dart';
import 'package:projet7/models/boisson.dart';

class BoissonPicker extends StatelessWidget {
  final Boisson boisson;
  final bool isSelected;
  final void Function()? onTap;

  const BoissonPicker({
    super.key,
    required this.boisson,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          BoissonBox(
            boisson: boisson,
            onTap: onTap,
          ),
          Checkbox(
            value: isSelected,
            onChanged: (value) {
              onTap?.call();
            },
          ),
        ],
      ),
    );
  }
}
