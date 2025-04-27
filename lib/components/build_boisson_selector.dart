import 'package:flutter/material.dart';

class BuildBoissonSelector extends StatelessWidget {
  final int itemCount;
  final Widget Function(BuildContext, int) itemBuilder;

  const BuildBoissonSelector({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      child: itemCount == 0
          ? Center(
              child: Text(
                'Aucune boisson disponible',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
              ),
            )
          : ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: itemCount,
              itemBuilder: itemBuilder,
            ),
    );
  }
}
