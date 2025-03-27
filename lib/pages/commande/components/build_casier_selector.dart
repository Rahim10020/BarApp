import 'package:flutter/material.dart';

class BuildCasierSelector extends StatelessWidget {
  final int? itemCount;
  final Widget? Function(BuildContext, int) itemBuilder;

  const BuildCasierSelector(
      {super.key, required this.itemCount, required this.itemBuilder});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: itemBuilder,
      ),
    );
  }
}
