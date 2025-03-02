import 'package:flutter/material.dart';
import 'package:projet7/models/vente.dart';

class VenteTileArchive extends StatelessWidget {
  final Vente vente;

  const VenteTileArchive({
    super.key,
    required this.vente,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 16.0,
        left: 16.0,
        right: 16.0,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                Icons.water_drop_outlined,
                size: 60.0,
              ),
              SizedBox(
                width: 8.0,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
